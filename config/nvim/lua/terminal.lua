local api = vim.api

local M = {}

---@alias terminal.State terminal.Proc[]

---@type terminal.State
local state = {}

---@class terminal.Proc
---@field name string
---@field cmd string|string[]
---@field buf? integer
---@field win? integer
local Proc = {}
Proc.__index = Proc

---@param cmd string|string[]
---@return terminal.Proc
function Proc.new(cmd)
  local obj = { cmd = cmd }
  if type(cmd) == 'string' then
    obj.name = cmd
    if cmd == '' then
      obj.name = nil
      obj.cmd = api.nvim_get_option_value('shell', {})
    end
  end
  return setmetatable(obj, Proc)
end

function Proc:run()
  vim.fn.jobstart(self.cmd, { term = true })
end

function Proc:_init_buf()
  local prebuf = api.nvim_get_current_buf()
  self.buf = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(self.buf)

  self:run()

  local ft = self.name or 'terminal'
  api.nvim_set_option_value('filetype', ft, { buf = self.buf })

  api.nvim_set_current_buf(prebuf)
end

---@alias terminal.Winpos 'f'|'s'|'v'

---@param winpos terminal.Winpos
function Proc:open(winpos)
  if not(self.buf and api.nvim_buf_is_valid(self.buf)) then
    self:_init_buf()
  end
  if winpos == 's' or winpos == 'v' then
    vim.cmd.wincmd(winpos)
    api.nvim_set_current_buf(self.buf)
    self.win = api.nvim_get_current_win()
  elseif winpos == 'f' then
    local ui = api.nvim_list_uis()[1]
    local height = math.ceil(ui.height * 0.8) - 4
    local width = math.ceil(ui.width * 0.8)
    self.win = api.nvim_open_win(self.buf, true, {
      style = 'minimal',
      relative = 'editor',
      height = height,
      width = width,
      row = math.ceil((ui.height - height) / 2) - 1,
      col = math.ceil((ui.width - width) / 2),
    })
  end
  vim.cmd.startinsert()
end

---@param cmd string|string[]
---@param winpos terminal.Winpos
function M.open(cmd, winpos)
  if not vim.tbl_contains({ 'f', 's', 'v' }, winpos) then return end

  for _, proc in ipairs(state) do
    if proc.name == cmd then
      return proc:open(winpos)
    end
  end

  local proc = Proc.new(cmd)
  proc:open(winpos)
  table.insert(state, proc)
end

return M
