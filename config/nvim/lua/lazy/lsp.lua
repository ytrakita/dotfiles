local vim = vim
local api = vim.api
local map = vim.keymap.set

local diagnostic = vim.diagnostic
local map_tbl = {
  [' e'] = diagnostic.open_float,
  ['[d'] = function() diagnostic.jump { count = -1, float = true } end,
  [']d'] = function() diagnostic.jump { count = 1, float = true } end,
  [' q'] = diagnostic.setloclist,
}
for lhs, rhs in pairs(map_tbl) do
  map('n', lhs, rhs, { noremap = true, silent = true })
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bnum)
  -- Enable completion triggered by <c-x><c-o>
  api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bnum })

  local lsp_buf = vim.lsp.buf

  local buf_map_tbl = {
    gD = lsp_buf.declaration,
    gd = lsp_buf.definition,
    K = lsp_buf.hover,
    gi = lsp_buf.implementation,
    ['<C-K>'] = lsp_buf.signature_help,
    [' wa'] = lsp_buf.add_workspace_folder,
    [' wr'] = lsp_buf.remove_workspace_folder,
    [' wl'] = function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
    [' D'] = lsp_buf.type_definition,
    [' rn'] = lsp_buf.rename,
    [' ca'] = lsp_buf.code_action,
    gr = lsp_buf.references,
    -- [' f'] = function() vim.lsp.buf.format { async = true } end,
  }
  for lhs, rhs in pairs(buf_map_tbl) do
    map('n', lhs, rhs, {
      noremap = true, silent = true, buffer = bnum,
    })
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '●',
            [vim.diagnostic.severity.WARN] = '○',
            [vim.diagnostic.severity.INFO] = '■',
            [vim.diagnostic.severity.HINT] = '□',
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
          },
        },
      }

      -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json')
                or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend(
            'force',
            client.config.settings.Lua,
            {
              runtime = {
                version = 'LuaJIT',
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  '${3rd}/luv/library'
                },
              },
            })
        end,
        on_attach = on_attach,
        settings = {
          Lua = {},
        },
      })

      require 'mason'.setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      require 'mason-lspconfig'.setup {
        ensure_installed = { 'lua_ls', 'julials', 'pyright' },
      }
    end,
  },
  { 'mason-org/mason-lspconfig.nvim', lazy = true },
  { 'mason-org/mason.nvim', lazy = true },
  { 'folke/neodev.nvim', lazy = true },
}
