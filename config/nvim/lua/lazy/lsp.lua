local api = vim.api

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bnum)
  -- Enable completion triggered by <c-x><c-o>
  api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {
    buf = bnum,
  })

  local lsp_buf = vim.lsp.buf

  local buf_map_tbl = {
    K = function() lsp_buf.hover { border = 'single' } end,
    gi = lsp_buf.implementation,
    ['<C-K>'] = lsp_buf.signature_help,
    [' wa'] = lsp_buf.add_workspace_folder,
    [' wr'] = lsp_buf.remove_workspace_folder,
    [' wl'] = function() vim.print(lsp_buf.list_workspace_folders()) end,
    [' D'] = lsp_buf.type_definition,
    [' rn'] = lsp_buf.rename,
    [' ca'] = lsp_buf.code_action,
    gr = lsp_buf.references,
    -- [' f'] = function() lsp_buf.format { async = true } end,
  }
  for lhs, rhs in pairs(buf_map_tbl) do
    vim.keymap.set('n', lhs, rhs, { silent = true, buffer = bnum })
  end

  vim.keymap.set('i', '<C-S>', function()
    lsp_buf.signature_help { border = 'single' }
  end)
end

vim.lsp.enable { 'lua_ls', 'pyright', 'julials' }

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local dx = vim.diagnostic

      dx.config {
        virtual_text = true,
        signs = {
          text = {
            [dx.severity.ERROR] = '●',
            [dx.severity.WARN] = '○',
            [dx.severity.INFO] = '■',
            [dx.severity.HINT] = '□',
          },
          numhl = {
            [dx.severity.ERROR] = 'DiagnosticSignError',
            [dx.severity.WARN] = 'DiagnosticSignWarn',
            [dx.severity.INFO] = 'DiagnosticSignInfo',
            [dx.severity.HINT] = 'DiagnosticSignHint',
          },
        },
      }
      vim.lsp.config('*', { on_attach = on_attach })

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
