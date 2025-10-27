local vim = vim
local api = vim.api

local M = {}

local types = {
  lazygit = function() vim.fn.jobstart('lazygit', { term = true }) end,
  terminal = vim.cmd.terminal,
}

for type, fn in pairs(types) do
  types[type] = { fn = fn }
end

local function init_buf(type)
  local prebuf = api.nvim_get_current_buf()

  local bnum = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(bnum)

  types[type].fn()

  api.nvim_set_option_value('filetype', type, { buf = bnum })
  api.nvim_set_current_buf(prebuf)

  return bnum
end

local function open_float_win(bnum)
  local height = math.ceil(vim.o.lines * 0.8) - 4
  local width = math.ceil(vim.o.columns * 0.8)
  local wnum = api.nvim_open_win(bnum, true, {
    style = 'minimal',
    relative = 'editor',
    height = height,
    width = width,
    row = math.ceil((vim.o.lines - height) / 2) - 1,
    col = math.ceil((vim.o.columns - width) / 2),
  })
  return wnum
end

function M.open(type, opt)
  if not vim.tbl_contains({ 's', 'v', 'f' }, opt) then return end

  local bnum = types[type].buf or init_buf(type)

  if opt == 's' or opt == 'v' then
    vim.cmd.wincmd(opt)
    api.nvim_set_current_buf(bnum)
    types[type].win = api.nvim_get_current_win()
  elseif opt == 'f' then
    types[type].win = open_float_win(bnum)
  end

  vim.cmd.startinsert()

  if not types[type].buf then
    types[type].buf = bnum
  end
end

return M
