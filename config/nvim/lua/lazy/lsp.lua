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

      local lspconfig = require 'lspconfig'

      local julia_env_path = vim.fs.joinpath(
        os.getenv 'JULIA_DEPOT_PATH', 'environments'
      )

      lspconfig.julials.setup {
        julia_env_path = julia_env_path,
        single_file_support = true,
        on_new_config = function(new_config, _)
          local julia_path = vim.fs.joinpath(
            julia_env_path, 'nvim-lspconfig', 'bin', 'julia'
          )
          if lspconfig.util.path.is_file(julia_path) then
            new_config.cmd[1] = julia_path
          end
        end,
        on_attach = on_attach,
        root_dir = function(fname)
          local util = require'lspconfig.util'
          return util.root_pattern 'Project.toml'(fname)
            or util.find_git_ancestor(fname)
            or util.path.dirname(fname)
        end,
      }
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
        on_attach = on_attach,
      }
      lspconfig.pyright.setup {
        on_attach = on_attach,
      }

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
  { 'williamboman/mason-lspconfig.nvim', lazy = true },
  { 'williamboman/mason.nvim', lazy = true },
  { 'folke/neodev.nvim', lazy = true },
}
