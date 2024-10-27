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
    dir = '~/repos/filtration.nvim',
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
    dir = '~/repos/tfx.nvim',
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
    keys = {
      { '<BS>', '<Plug>(closer_bs)', mode = 'i' },
      { '<C-H>', '<Plug>(closer_bs)', mode = 'i' },
      { '<CR>', '<Plug>(closer_cr)', mode = 'i' },
      { ' ', '<Plug>(closer_space)', mode = 'i' },
    },
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
        vim.keymap.set('n', ']c', function()
          require 'gitsigns'.next_hunk()
        end, { buffer = bnum })
        vim.keymap.set('n', '[c', function()
          require 'gitsigns'.prev_hunk()
        end, { buffer = bnum })
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
  {
    'vim-denops/denops.vim',
    event = { 'CursorHold', 'FocusLost' },
  },
  require 'lazy.ts',
  require 'lazy.lsp',
  require 'lazy.cmp',
  -- require 'lazy.ddc',
}
