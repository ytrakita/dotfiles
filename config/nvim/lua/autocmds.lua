return {
  {
    event = 'FileType',
    pattern = 'qf',
    callback = function(tbl)
      require 'floatmenu.tcursor'.create_autocmd(tbl.buf)
      require 'floatmenu.tcursor'.hide_cursor()
    end,
  },
  {
    event = 'BufWritePre',
    pattern = '*',
    callback = function(tbl)
      local fn = vim.fn
      local dir = fn.fnamemodify(tbl.file, ':p:h')
      if fn.isdirectory(dir) == 0 then
        fn.mkdir(dir, 'p')
      end
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd [[silent! %substitute/\s\+$//ge]]
      vim.api.nvim_win_set_cursor(0, pos)
    end,
  },
  {
    event = 'BufWritePost',
    pattern = '$MYVIMRC',
    command = 'source $MYVIMRC',
    nested = true,
  },
  {
    event = 'BufNewFile',
    pattern = '*.tex',
    callback = function()
      local data = vim.fn.stdpath 'data'
      local path = vim.fs.joinpath(data, 'templates', 'template.tex')
      if not vim.uv.fs_stat(path) then return end
      local lines = {}
      for line in io.lines(path) do
        table.insert(lines, line)
      end
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.api.nvim_win_set_cursor(0, { 13, 0 })
    end,
  },
  {
    event = 'CmdwinEnter',
    pattern = ':',
    command = [[silent! global/\v(^w?q?a?!?$|^\a\s?$)/delete]],
  },
  {
    event = 'CmdwinEnter',
    pattern = '[:\\/\\?=]',
    callback = function()
      vim.wo.foldcolumn = '0'
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = 'no'
      vim.keymap.set('n', 'q', '<C-W>q', { buffer = true })
    end,
  },
  {
    event = 'CmdwinEnter',
    pattern = '*',
    callback = function()
      vim.o.statusline = [[%!v:lua.require'statusline'.statusline(1)]]
    end,
  },
  {
    event = 'CmdwinLeave',
    pattern = '*',
    callback = function()
      vim.o.statusline = [[%!v:lua.require'statusline'.statusline()]]
    end,
  },
  {
    event = 'ColorScheme',
    pattern = '*',
    callback = function()
      local hl_tbl = {
        Normal = { fg = '#dbe6ec' },
        FoldColumn = { fg = '#288ad6' },
        TabLineSel = {},
        WinSeparator = {},
        filtrationMatch = { fg = '#ffc83f', bold = true },
        filtrationActiveBorder = {
          fg = '#27dede', bg = '#3b444f', bold = true,
        },
        filtrationBorder = { fg = '#67747c', bg = '#3b444f', bold = false },
      }
      for name, val in pairs(hl_tbl) do
        vim.api.nvim_set_hl(0, name, val)
      end
      require 'statusline'.highlight()
      require 'tabline'.highlight()
    end,
  },
  {
    event = 'TextYankPost',
    pattern = '*',
    callback = function() vim.hl.on_yank() end,
  },
  {
    event = 'ModeChanged',
    pattern = '*',
    command = 'redrawstatus',
  },
}
