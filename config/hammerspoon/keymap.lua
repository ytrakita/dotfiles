local hs = hs
local hotkey = hs.hotkey

local M = {}; M.__index = M

function M.keyStroke(char, mods)
  if mods then
    mods = type(mods) == 'string' and { mods } or mods
  end
  mods = mods or {}
  return function()
    hs.eventtap.keyStroke(mods, char, 0)
  end
end

local function filterEnable(windowFilter, hk)
  local wf = hs.window.filter
  windowFilter:subscribe(wf.windowFocused, function()
    hk:enable()
  end)
  windowFilter:subscribe(wf.windowUnfocused, function()
    hk:disable()
  end)
end

function M.set(mods, char, fn, opts)
  local hk = hotkey.new(mods, char, fn, nil, fn)

  if opts and opts.wf then
    filterEnable(opts.wf, hk)
    return
  end

  hk:enable()
end

return M
