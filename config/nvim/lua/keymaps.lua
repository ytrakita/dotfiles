return {
  n = {
    l = function()
      local key = vim.fn.foldclosed(vim.fn.line('.')) == -1 and 'l' or 'zo0'
      vim.cmd.normal { args = { key }, bang = true }
    end,
    n = 'nzvzt',
    N = 'Nzvzt',
    Q = '',
    Y = 'y$',
    ZQ = '',
    ZZ = '',
    ['*'] = '*zt',
    ['#'] = '#zt',
    ['<C-L>'] = '<Cmd>nohlsearch<CR><C-L>',
    [' '] = '',
    [' s'] = '<Cmd>silent! write | source %<CR>',
    [' tf'] = function() require 'terminal'.open('f') end,
    [' tt'] = function() require 'terminal'.open('f') end,
    [' ts'] = function() require 'terminal'.open('s') end,
    [' tv'] = function() require 'terminal'.open('v') end,
    [']s'] = ']szt',
    ['[s'] = '[szt',
    [']S'] = ']Szt',
    ['[S'] = '[Szt',
    ['<Leader>s'] = function() require 'spellcheck'.open_list() end,
  },
  i = {
    ['<C-A>'] = '<C-O>^',
    ['<C-B>'] = '<Left>',
    ['<C-D>'] = '<Del>',
    ['<C-E>'] = '<End>',
    ['<C-F>'] = '<Right>',
    ['<C-K>'] = '<C-O>"_D',
    ['<C-T>'] = '<Esc><Left>"zx"zpa',
  },
  x = {
    ['p'] = 'pgvygv<ESC>',
    ['<'] = '<gv',
    ['>'] = '>gv',
  },
  c = {
    ['<C-A>'] = '<Home>',
    ['<C-B>'] = '<Left>',
    ['<C-D>'] = '<Del>',
    ['<C-E>'] = '<End>',
    ['<C-F>'] = '<Right>',
    ['<C-K>'] = [[<C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos() - 2]<CR>]],
    ['<C-N>'] = '<Down>',
    ['<C-P>'] = '<Up>',
    ['%%'] = [[<C-R>= getcmdtype() == ':' ? expand('%:h') : '%%'<CR>]],
  },
  t = {
    ['<ESC>'] = [[<C-\><C-N>]],
  }
}