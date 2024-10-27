local vim = vim
local api = vim.api

local M = {}

local state = {}

local function init_buf()
  local prebuf = api.nvim_get_current_buf()

  vim.cmd.terminal()

  local bnum = api.nvim_get_current_buf()
  api.nvim_set_option_value('filetype', 'terminal', { buf = bnum })
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

function M.open(opt)
  if not vim.tbl_contains({ 's', 'v', 'f' }, opt) then return end

  local bnum = state.buf or init_buf()

  if opt == 's' or opt == 'v' then
    vim.cmd.wincmd(opt)
    api.nvim_set_current_buf(bnum)
    state.win = api.nvim_get_current_win()
  elseif opt == 'f' then
    state.win = open_float_win(bnum)
  end

  vim.cmd.startinsert()

  if not state.buf then
    state.buf = bnum
  end
end

return M
