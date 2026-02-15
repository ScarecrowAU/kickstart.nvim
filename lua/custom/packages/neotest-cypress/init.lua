local lib = require 'neotest.lib'

local adapter = { name = 'neotest-cypress' }

adapter.root = lib.files.match_root_pattern('cypress.config.js', 'cypress.config.ts')

function adapter.filter_dir(name)
  local skip = { node_modules = true, screenshots = true, videos = true, snapshots = true, downloads = true, fixtures = true }
  return not skip[name]
end

function adapter.is_test_file(file_path)
  if not file_path then return false end
  if not file_path:match '%.cy%.[jt]sx?$' then return false end
  -- Verify a cypress config exists upward from this file
  local dir = vim.fn.fnamemodify(file_path, ':h')
  local found = vim.fs.find({ 'cypress.config.js', 'cypress.config.ts' }, {
    path = dir,
    upward = true,
    type = 'file',
  })
  return #found > 0
end

local function make_predicate(names)
  if #names == 1 then return string.format('(#eq? @func_name "%s")', names[1]) end
  local quoted = {}
  for _, name in ipairs(names) do
    quoted[#quoted + 1] = '"' .. name .. '"'
  end
  return '(#any-of? @func_name ' .. table.concat(quoted, ' ') .. ')'
end

local function make_query()
  local groups = {
    { names = { 'describe', 'context' }, capture = 'namespace' },
    { names = { 'it' }, capture = 'test' },
  }

  local parts = {}
  for _, group in ipairs(groups) do
    local predicate = make_predicate(group.names)

    -- Plain call: describe('name', () => {})
    parts[#parts + 1] = string.format(
      '((call_expression\n'
        .. '  function: (identifier) @func_name %s\n'
        .. '  arguments: (arguments (string (string_fragment) @%s.name) (arrow_function))\n'
        .. ')) @%s.definition',
      predicate,
      group.capture,
      group.capture
    )

    -- Member expression: describe.only('name', () => {})
    parts[#parts + 1] = string.format(
      '((call_expression\n'
        .. '  function: (member_expression\n'
        .. '    object: (identifier) @func_name %s\n'
        .. '  )\n'
        .. '  arguments: (arguments (string (string_fragment) @%s.name) (arrow_function))\n'
        .. ')) @%s.definition',
      predicate,
      group.capture,
      group.capture
    )
  end

  local query = table.concat(parts, '\n')
  return query .. '\n' .. string.gsub(query, 'arrow_function', 'function_expression')
end

function adapter.discover_positions(path) return lib.treesitter.parse_positions(path, make_query(), { nested_tests = true }) end

function adapter.build_spec(args)
  local position = args.tree:data()
  -- Always run at file level — Cypress doesn't support test-level filtering
  local file_path = position.path
  if position.type ~= 'file' then
    -- Walk up to find the file node
    local parent = args.tree:parent()
    while parent and parent:data().type ~= 'file' do
      parent = parent:parent()
    end
    if parent then file_path = parent:data().path end
  end

  local root = adapter.root(file_path)
  if not root then return nil end

  -- Find cypress binary
  local cypress_bin
  local bin_path = root .. '/node_modules/.bin/cypress'
  if vim.fn.executable(bin_path) == 1 then
    cypress_bin = bin_path
  else
    cypress_bin = 'npx cypress'
  end

  -- Make spec path relative to root
  local relative_path = file_path:sub(#root + 2)

  -- Detect component vs e2e
  local extra_args = ''
  if file_path:match '/components?/' then extra_args = ' --component' end

  local command = cypress_bin .. ' run --spec ' .. relative_path .. ' --reporter json' .. extra_args

  return {
    command = command,
    cwd = root,
  }
end

--- Build a fullTitle string for a neotest tree node by walking up its ancestors
local function build_full_title(tree)
  local parts = {}
  local node = tree
  while node do
    local data = node:data()
    if data.type == 'test' or data.type == 'namespace' then table.insert(parts, 1, data.name) end
    node = node:parent()
  end
  return table.concat(parts, ' ')
end

--- Extract the outermost JSON object from mixed stdout output
local function extract_json(output)
  local depth = 0
  local start_idx = nil
  for i = 1, #output do
    local ch = output:sub(i, i)
    if ch == '{' then
      if depth == 0 then start_idx = i end
      depth = depth + 1
    elseif ch == '}' then
      depth = depth - 1
      if depth == 0 and start_idx then return output:sub(start_idx, i) end
    end
  end
  return nil
end

function adapter.results(spec, result, tree)
  local results = {}
  local output_path = result.output
  if not output_path then return results end

  local ok, lines = pcall(vim.fn.readfile, output_path)
  if not ok then return results end

  local raw_output = table.concat(lines, '\n')
  local json_str = extract_json(raw_output)
  if not json_str then
    -- No JSON found — mark file as failed
    local file_id = tree:data().id
    results[file_id] = {
      status = 'failed',
      short = 'Could not parse Cypress JSON output',
      output = output_path,
    }
    return results
  end

  local parse_ok, report = pcall(vim.fn.json_decode, json_str)
  if not parse_ok or not report then
    local file_id = tree:data().id
    results[file_id] = {
      status = 'failed',
      short = 'Failed to decode Cypress JSON output',
      output = output_path,
    }
    return results
  end

  -- Build fullTitle → position_id lookup from tree
  local title_to_id = {}
  for _, node in tree:iter_nodes() do
    local data = node:data()
    if data.type == 'test' then
      local full_title = build_full_title(node)
      title_to_id[full_title] = data.id
    end
  end

  -- Map passes
  if report.passes then
    for _, test in ipairs(report.passes) do
      local id = title_to_id[test.fullTitle]
      if id then results[id] = { status = 'passed', output = output_path } end
    end
  end

  -- Map failures
  if report.failures then
    for _, test in ipairs(report.failures) do
      local id = title_to_id[test.fullTitle]
      if id then
        local err_msg = ''
        if test.err and test.err.message then err_msg = test.err.message end
        results[id] = {
          status = 'failed',
          short = err_msg,
          output = output_path,
          errors = err_msg ~= '' and {
            { message = err_msg },
          } or nil,
        }
      end
    end
  end

  -- Map pending/skipped
  if report.pending then
    for _, test in ipairs(report.pending) do
      local id = title_to_id[test.fullTitle]
      if id then results[id] = { status = 'skipped', output = output_path } end
    end
  end

  -- Set file-level result
  local file_id = tree:data().id
  local has_failures = report.failures and #report.failures > 0
  results[file_id] = {
    status = has_failures and 'failed' or 'passed',
    output = output_path,
  }

  return results
end

return adapter
