return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
  config = function()
    require 'nvim-treesitter'.setup {}
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('vim-treesitter-start', {}),
      callback = function() pcall(vim.treesitter.start) end,
    })
  end,
}
