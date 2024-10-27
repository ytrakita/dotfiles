local opt = vim.opt_local

opt.buflisted = false
opt.swapfile = false
opt.bufhidden = 'hide'

opt.list = false
opt.wrap = false
opt.foldenable = false
opt.foldcolumn = '0'
opt.colorcolumn = ''
opt.number = false
opt.relativenumber = false
opt.scrolloff = 1
opt.spell = false
opt.statusline = [[%!v:lua.require'statusline'.qf_line()]]

vim.keymap.set('n', 'q', '<C-W>q<C-L>', { buffer = true })
