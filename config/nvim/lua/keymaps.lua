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
    ['*'] = '*zv',
    ['#'] = '#zv',
    [' '] = '',
    [' s'] = '<Cmd>silent! write | source %<CR>',
    [' tf'] = function() require 'terminal'.open('terminal', 'f') end,
    [' tt'] = function() require 'terminal'.open('terminal', 'f') end,
    [' ts'] = function() require 'terminal'.open('terminal', 's') end,
    [' tv'] = function() require 'terminal'.open('terminal', 'v') end,
    ['<Leader>s'] = function() require 'spellcheck'.open_list() end,
    [' lg'] = function() require 'terminal'.open('lazygit', 'f') end,
  },
  i = {
    ['<C-A>'] = '<C-O>^',
    ['<C-B>'] = '<Left>',
    ['<C-D>'] = '<Del>',
    ['<C-E>'] = '<End>',
    ['<C-F>'] = '<Right>',
    ['<C-J>'] = '',
    ['<C-K>'] = '<C-O>"_D',
    ['<C-T>'] = '<Esc><Left>"zx"zpa',
  },
  x = {
    p = 'pgvygv<ESC>',
    ['<'] = '<gv',
    ['>'] = '>gv',
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
