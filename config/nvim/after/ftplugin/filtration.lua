local keymaps = {
  ['<CR>'] = function() require 'filtration'.do_action() end,
  s = function() require 'filtration'.do_action('s') end,
  t = function() require 'filtration'.do_action('t') end,
  v = function() require 'filtration'.do_action('v') end,
  q = function() require 'filtration'.quit() end,
  D = function() require 'filtration'.delete() end,
  i = function() require 'filtration'.filter() end,
  ['<C-L>'] = '<Cmd>mode<CR>',
  ['<C-B>'] = '<C-B>',
  ['<C-F>'] = '<C-F>',
  ['<C-N>'] = 'j',
  ['<C-P>'] = 'k',
  gg = 'gg',
  G = 'G',
}

local function map(lhs, rhs)
  local opts = { buffer = true, silent = true, nowait = true }
  vim.keymap.set('n', lhs, rhs, opts)
end

for lhs, rhs in pairs(keymaps) do
  map(lhs, rhs)
end
