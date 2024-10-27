local hs = hs
local app = hs.application


do -- config watcher

local configWatcher = require 'configWatcher'

configWatcher:start()

end


do -- keymap

local keymap = require 'keymap'

local function openKitty()
  local kitty = app.find('kitty')

  if not kitty then
    app.open('kitty')
    return
  end

  if kitty:isFrontmost() then
    kitty:hide()
    return
  end

  app.open('kitty')
  local win = kitty:mainWindow()
  win:setSize(win:frame().w, win:screen():frame().h)
  win:setTopLeft(0, 0)
end

keymap.set({ 'ctrl' }, 'i', keymap.keyStroke('tab'))
keymap.set({ 'ctrl' }, 'm', keymap.keyStroke('return'))
keymap.set({ 'ctrl' }, '[', keymap.keyStroke('escape'))
keymap.set({}, 'f12', openKitty)

local term_apps = { Terminal = false, kitty = false }
local wf = hs.window.filter.new():setFilters(term_apps)
keymap.set({ 'ctrl' }, 'u', keymap.keyStroke('delete', 'cmd'), { wf = wf })
keymap.set({ 'ctrl' }, 'w', keymap.keyStroke('delete', 'option'), { wf = wf })

end


do -- misc

app.enableSpotlightForNameSearches(true)

local function notify(text)
  local tab = { title = 'Hammerspoon', informativeText = text }
  hs.notify.new(tab):send()
end

end
