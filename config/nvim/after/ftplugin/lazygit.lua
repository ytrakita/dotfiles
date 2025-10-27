local opt = vim.opt_local

opt.list = false
opt.wrap = false
opt.foldenable = false
opt.foldcolumn = '0'
opt.colorcolumn = ''
opt.number = false
opt.relativenumber = false
opt.scrolloff = 1

vim.keymap.set('n', 'q', '<C-W>q<C-L>', { buffer = true })
vim.keymap.set('n', '<C-L>', 'zt<Cmd>nohlsearch<CR><C-L>', {
  buffer = true, silent = true,
})

vim.keymap.set('t', 'q', '<Cmd>wincmd q<CR>', { buffer = true })
vim.keymap.set('t', '<ESC>', '<ESC>', { buffer = true })
