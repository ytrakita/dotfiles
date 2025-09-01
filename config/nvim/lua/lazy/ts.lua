return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufRead', 'BufNewFile', 'InsertEnter' },
  config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = 'all',
      sync_install = false,
      auto_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
