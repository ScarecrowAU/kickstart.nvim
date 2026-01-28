-- Function to load plugin without crashing if it doesn't exist
TryLoad = function(plugin)
  local status, result = pcall(require, plugin)
  if status then return result end
end
