vim.keymap.set({ 'n', 'x' }, '<Plug>(align_right)', function()
  vim.o.operatorfunc = [[v:lua.require'align'.right]]
  return 'g@'
end, { expr = true })
vim.keymap.set({ 'n', 'x' }, '<Plug>(align_left)', function()
  vim.o.operatorfunc = [[v:lua.require'align'.left]]
  return 'g@'
end, { expr = true })

return {
  n = {
    l = function()
      local key = vim.fn.foldclosed(vim.fn.line('.')) == -1 and 'l' or 'zo0'
      vim.cmd.normal { args = { key }, bang = true }
    end,
    n = 'nzv',
    N = 'Nzv',
    Q = '',
    ZQ = '',
    ZZ = '',
    ga = '<Plug>(align_left)',
    gA = '<Plug>(align_right)',
    ['*'] = '*zv',
    ['#'] = '#zv',
    [' '] = '',
    [' s'] = '<Cmd>silent! write | source %<CR>',
    [' tf'] = function() require 'terminal'.open('', 'f') end,
    [' tt'] = function() require 'terminal'.open('', 'f') end,
    [' ts'] = function() require 'terminal'.open('', 's') end,
    [' tv'] = function() require 'terminal'.open('', 'v') end,
    [' lg'] = function() require 'terminal'.open('lazygit', 'f') end,
  },
  i = {
    ['<C-A>'] = '<C-G>U<C-O>^',
    ['<C-B>'] = '<C-G>U<Left>',
    ['<C-D>'] = '<C-G>U<Del>',
    ['<C-E>'] = '<C-G>U<End>',
    ['<C-F>'] = '<C-G>U<Right>',
    ['<C-J>'] = '',
    ['<C-K>'] = '<C-O>"_D',
    ['<C-T>'] = '<C-G>U<Esc><Left>"zx"zpa',
  },
  x = {
    p = 'pgvygv<ESC>',
    ['<'] = '<gv',
    ['>'] = '>gv',
    ga = '<Plug>(align_left)',
    gA = '<Plug>(align_right)',
  },
  c = {
    ['<C-A>'] = '<Home>',
    ['<C-B>'] = '<Left>',
    ['<C-D>'] = '<Del>',
    ['<C-E>'] = '<End>',
    ['<C-F>'] = '<Right>',
    ['<C-K>'] = function()
      local fn = vim.fn
      local pos = fn.getcmdpos()
      local line = pos > 1 and fn.getcmdline():sub(1, pos - 1) or ''
      fn.setcmdline(line)
    end,
    ['<C-N>'] = '<Down>',
    ['<C-P>'] = '<Up>',
    ['%%'] = [[<C-R>= getcmdtype() == ':' ? expand('%:h') : '%%'<CR>]],
  },
  t = {
    ['<ESC>'] = [[<C-\><C-N>]],
  },
}
