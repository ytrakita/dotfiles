local vim = vim

return {
  { 'folke/lazy.nvim' },
  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'ds', 'cs', 'S' },
    config = true,
  },
  {
    dir = '~/repos/floatmenu.nvim',
    opts = {},
    lazy = true,
  },
  {
    dir = '~/repos/filtration.nvim',
    keys = {
      { ' bf', function() require 'filtration'.display_prompt.fd() end },
      { ' bg', function() require 'filtration'.display_prompt.rg() end },
      { ' bb', function() require 'filtration'.display_menu.buffer() end },
      { ' bh', function() require 'filtration'.display_menu.mru() end },
      { ' bt', function() require 'filtration'.display_prompt.help_tags() end },
    },
    opts = {
      highlights = {
        filtrationMatch = { fg = '#ffc83f', bold = true },
        filtrationActiveBorder = { fg = '#16c98d', bg = '#3b444f', bold = true },
      },
    },
  },
  {
    'romgrk/fzy-lua-native',
    build = 'make',
    lazy = true,
  },
  {
    dir = '~/repos/tfx.nvim',
    keys = {
      { ' ff', function() require 'tfx'.explore() end },
      { ' fx', function()
        local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
        require 'tfx'.explore(path)
      end },
    },
    opts = {},
  },
  {
    dir = '~/repos/closer.nvim',
    event = 'InsertEnter',
    opts = {
      ft = {
        tex = {
          ['('] = ')',
          ['['] = ']',
          ['{'] = '}',
          ["`"] = "'",
          ['$'] = '$',
        },
        rust = {
          ['('] = ')',
          ['['] = ']',
          ['{'] = '}',
          ['"'] = '"',
          ['|'] = '|',
          ['<'] = '>',
        },
        ['filtration-prompt'] = {},
      },
    },
  },
  {
    dir = '~/repos/texpreview.nvim',
    ft = 'tex',
    opts = {},
  },
  {
    dir = '~/repos/latex-toc.nvim',
    ft = 'tex',
    opts = {},
  },
  {
    dir = '~/repos/texmap.nvim',
    ft = 'tex',
    opts = {
      imaps = {
        enable = {
          { lhs = 'e', rhs = [[\eps]] },
          { lhs = 'I', rhs = [[\implies]] },
        },
        disable = { '(', ')' },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bnum)
        local gitsigns = require 'gitsigns'
        vim.keymap.set('n', ']c', function()
          gitsigns.nav_hunk('next')
          vim.cmd.normal 'zt'
        end, { buffer = bnum })
        vim.keymap.set('n', '[c', function()
          gitsigns.nav_hunk('prev')
          vim.cmd.normal 'zt'
        end, { buffer = bnum })
        vim.keymap.set('n', ' gs', gitsigns.stage_hunk)
        vim.keymap.set('n', ' gr', gitsigns.reset_hunk)

        vim.keymap.set('v', ' gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
        vim.keymap.set('v', ' gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)
      end
    },
  },
  {
    'levouh/tint.nvim',
    opts = {
      window_ignore_function = function(winid)
        -- Do not tint `terminal` or floating windows, tint everything else
        return vim.api.nvim_win_get_config(winid).relative ~= ''
      end
    },
  },
  require 'lazy.ts',
  require 'lazy.lsp',
  require 'lazy.cmp',
  -- require 'lazy.ddc',
}
