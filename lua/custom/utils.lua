TryLoad = function(plugin)
  local status, result = pcall(require, plugin)
  if status then return result end
end
