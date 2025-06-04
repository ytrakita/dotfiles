local vim = vim

return {
  {
    'folke/lazy.nvim',
  },
  {
    'fladson/vim-kitty',
    ft = 'kitty',
  },
  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'ds', 'cs', 'S' },
    config = true,
  },
  {
    dir = '~/repos/lightalign',
    keys = {
      { 'ga', '<Plug>(align)', mode = { 'n', 'x' }},
      { 'gA', '<Plug>(align_left)', mode = { 'n', 'x' }},
    },
  },
  {
    dir = '~/repos/floatmenu.nvim',
    opts = {},
    lazy = true,
  },
  {
    dir = '~/repos/filtration.nvim',
    keys = { ' b' },
    config = function()
      local filtration = require 'filtration'

      filtration.setup {
        menu = {
          keymap = {
            menu = {
              ['i'] = { 'filter' },
              ['q'] = { 'quit' },
              ['<CR>'] = { 'do_action', '' },
              ['s'] = { 'do_action', 's' },
              ['v'] = { 'do_action', 'v' },
              ['t'] = { 'do_action', 't' },
              ['<C-B>'] = '<C-B>',
              ['<C-F>'] = '<C-F>',
              ['<C-N>'] = 'j',
              ['<C-P>'] = 'k',
              ['gg'] = 'gg',
              ['G'] = 'G',
            },
            prompt = {
              ['<CR>'] = { 'select', true },
              ['<ESC>'] = { 'quit' },
              ['<C-N>'] = { 'select', true },
              ['<C-P>'] = { 'select', false },
            },
          },
        },
        sources = { 'fd', 'rg', 'buffer', 'mru', 'help_tags' },
      }

      local map = vim.keymap.set
      map('n', ' bf', filtration.display_prompt.fd, {})
      map('n', ' bg', filtration.display_prompt.rg, {})
      map('n', ' bb', filtration.display_menu.buffer, {})
      map('n', ' bh', filtration.display_menu.mru, {})
      map('n', ' bt', filtration.display_prompt.help_tags, {})
    end,
  },
  {
    'romgrk/fzy-lua-native',
    build = 'make',
    lazy = true,
  },
  {
    dir = '~/repos/tfx.nvim',
    keys = { ' f' },
    config = function()
      local tfx = require 'tfx'

      tfx.setup {
        keymap = {
          h = { 'collapse' },
          l = { 'expand' },
          ['<CR>'] = { 'go', '' },
          ['s'] = { 'go', 's' },
          ['v'] = { 'go', 'v' },
          ['t'] = { 'go', 't' },
          u = { 'up' },
          q = { 'quit' },
          o = { 'add' },
          D = { 'delete' },
          R = { 'rename' },
        },
      }

      local map = vim.keymap.set
      map('n', ' ff', tfx.explore, {})
      map('n', ' fx', tfx.explore_current_dir, {})
    end,
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
