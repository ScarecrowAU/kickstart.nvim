local M = {}

local config_cache = {}

--- Walk upward from start_dir looking for any file in config_names.
--- Results are cached per (cache_key, start_dir) until cleared.
---@param start_dir string
---@param config_names string[]
---@param cache_key string
---@return boolean
function M.find_config_upward(start_dir, config_names, cache_key)
  local key = cache_key .. ':' .. start_dir
  if config_cache[key] ~= nil then
    return config_cache[key]
  end

  local current_dir = start_dir
  while current_dir ~= '/' do
    for _, name in ipairs(config_names) do
      if vim.fn.filereadable(current_dir .. '/' .. name) == 1 then
        config_cache[key] = true
        return true
      end
    end
    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  config_cache[key] = false
  return false
end

--- Check if an oxc config file exists upward from buf_dir.
---@param buf_dir string
---@return boolean
function M.has_oxc_config(buf_dir)
  return M.find_config_upward(buf_dir, { '.oxlintrc.json', 'oxlintrc.json' }, 'oxc')
end

local prettier_config_names = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.js',
  '.prettierrc.cjs',
  '.prettierrc.mjs',
  '.prettierrc.yaml',
  '.prettierrc.yml',
  '.prettierrc.toml',
  'prettier.config.js',
  'prettier.config.cjs',
  'prettier.config.mjs',
}

--- Check if a prettier config exists upward from buf_dir.
--- Also checks for a "prettier" key in package.json.
---@param buf_dir string
---@return boolean
function M.has_prettier_config(buf_dir)
  local key = 'prettier:' .. buf_dir
  if config_cache[key] ~= nil then
    return config_cache[key]
  end

  local current_dir = buf_dir
  while current_dir ~= '/' do
    for _, name in ipairs(prettier_config_names) do
      if vim.fn.filereadable(current_dir .. '/' .. name) == 1 then
        config_cache[key] = true
        return true
      end
    end

    local package_json = current_dir .. '/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      local content = vim.fn.readfile(package_json)
      local json_str = table.concat(content, '\n')
      if json_str:match '"prettier"' then
        config_cache[key] = true
        return true
      end
    end

    current_dir = vim.fn.fnamemodify(current_dir, ':h')
  end

  config_cache[key] = false
  return false
end

--- Clear the config detection cache.
function M.clear_config_cache()
  config_cache = {}
  vim.notify('Tool config cache cleared', vim.log.levels.INFO)
end

vim.api.nvim_create_user_command('ClearToolConfigCache', M.clear_config_cache, {})

return M
