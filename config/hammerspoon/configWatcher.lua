-- https://github.com/Hammerspoon/Spoons/blob/master/Source/ReloadConfiguration.spoon/init.lua

local hs = hs

local M = {}; M.__index = M

M.watch_paths = { hs.configdir }

local function reloadConfig(files)
  local doReload

  for _, file in ipairs(files) do
    if file:sub(-4) == '.lua' then
      doReload = true
      break
    end
  end

  if doReload then
    hs.reload()
  end
end

function M:start()
  local watchers = {}
  for _, dir in ipairs(self.watch_paths) do
    watchers[dir] = hs.pathwatcher.new(dir, reloadConfig):start()
  end
  self.watchers = watchers
  return self
end

return M
