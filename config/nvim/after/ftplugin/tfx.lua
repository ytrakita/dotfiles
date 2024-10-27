local api = vim.api

local keymaps = {
  ['<CR>'] = function() require 'lfx'.go() end,
  s = function() require 'lfx'.go('s') end,
  t = function() require 'lfx'.go('t') end,
  v = function() require 'lfx'.go('v') end,
  q = function() require 'lfx'.quit() end,
  u = function() require 'lfx'.up() end,
  l = function() require 'lfx'.expand() end,
  h = function() require 'lfx'.collapse() end,
  zf = function() require 'lfx'.collapse() end,
  ['<C-L>'] = [[<Cmd>mode<CR>]],
  ['<C-B>'] = '<C-B>',
  ['<C-F>'] = '<C-F>',
  ['<C-N>'] = 'j',
  ['<C-P>'] = 'k',
  gg = function() api.nvim_win_set_cursor(0, { 2, 0 }) end,
  G = 'G',
}

local function map(lhs, rhs)
  local opts = { buffer = true, silent = true, nowait = true }
  vim.keymap.set('n', lhs, rhs, opts)
end

for lhs, rhs in pairs(keymaps) do
  map(lhs, rhs)
end
