local vim = vim
local api = vim.api
local vfn = vim.fn

local function i(p)
  p.event = { 'InsertEnter' }
  return p
end

local function c(p)
  p.event = { 'CmdLineEnter' }
  return p
end

return {
  { 'onsails/lspkind.nvim', lazy = true },
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdLineEnter' },
    config = function()
      vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

      local cmp = require 'cmp'
      local cmpmap = cmp.mapping

      cmp.setup {
        snippet = {
          expand = function(args)
            require 'snippy'.expand_snippet(args.body)
          end
        },
        mapping = {
          ['<CR>'] = cmpmap.confirm { select = false },
          ['<C-N>'] = cmpmap(cmpmap.select_next_item(), { 'i', 'c' }),
          ['<C-P>'] = cmpmap(cmpmap.select_prev_item(), { 'i', 'c' }),
          ['<A-U>'] = cmpmap(cmpmap.scroll_docs(-4), { 'i', 'c' }),
          ['<A-D>'] = cmpmap(cmpmap.scroll_docs(4), { 'i', 'c' }),
          ['<Tab>'] = cmpmap(function(fallback)
            local col = vfn.col '.' - 1
            if cmp.visible() then
              cmp.select_next_item()
            elseif col == 0
              or api.nvim_get_current_line():sub(col, col):match '%s' then
              fallback()
            else
              cmp.complete()
            end
          end, { 'i', 's' }),
          ['<S-Tab'] = cmpmap(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'treesitter', trigger_characters = { '.' }, option = {} },
          { name = 'snippy' },
          {
            name = 'buffer',
            option = {
              keyword_pattern = [[\%(#[\da-fA-F]\{6}\>\|-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(\%(-\|::\)\h\w*\)*\)]],
              get_bufnrs = api.nvim_list_bufs,
            },
          },
          { name = 'rg' },
          { name = 'emoji' },
          {
            name = 'look',
            keyword_length = 2,
            option = { convert_case = true, loud = true },
          },
        },
      }
      cmp.setup.filetype({ 'filtration-prompt' }, { sources = {} })
      cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' },
        })
      })

      require 'cmp.utils.debug'.flag = vim.env.CMP_DEBUG ~= nil
    end,
  },

  c { 'hrsh7th/cmp-cmdline' },
  c { 'hrsh7th/cmp-path' },

  i { 'hrsh7th/cmp-buffer' },
  i { 'hrsh7th/cmp-emoji' },
  i { 'hrsh7th/cmp-nvim-lsp' },
  i { 'lukas-reineke/cmp-rg' },
  i { 'octaltree/cmp-look' },
  i { 'ray-x/cmp-treesitter' },

  {
    'hrsh7th/cmp-nvim-lua',
    ft = 'lua',
  },

  i { 'dcampos/cmp-snippy' },
  {
    'dcampos/nvim-snippy',
    opts = {
      mappings = {
        is = {
          ['<C-L>'] = 'expand_or_advance',
          ['<C-;>'] = 'previous',
        },
        nx = {
          ['<leader>x'] = 'cut_text',
        },
      },
    },
    lazy = true,
  },
  { 'honza/vim-snippets', lazy = true },
}
