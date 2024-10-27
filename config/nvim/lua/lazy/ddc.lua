local vim = vim
local api = vim.api
local vfn = vim.fn

return {
  {
    'Shougo/ddc.vim',
    event = { 'InsertEnter', 'CmdLineEnter' },
    dependencies = {
      { 'vim-denops/denops.vim' },
      { 'Shougo/ddc-ui-native' },
      { 'Shougo/ddc-ui-none' },
      { 'Shougo/ddc-around' },
      { 'matsui54/ddc-buffer' },
      { 'Shougo/ddc-source-nvim-lsp' },
      { 'LumaKernel/ddc-file' },
      { 'Shougo/ddc-matcher_head' },
      { 'tani/ddc-fuzzy' },
      { 'Shougo/ddc-sorter_rank' },
      {
        'Shougo/pum.vim',
        dependencies = {
          'vim-denops/denops.vim',
          'Shougo/ddc-ui-pum',
        },
        config = function()
          vfn['pum#set_option'] {
            highlight_columns = {
              kind = 'SpecialComment',
              menu = 'SpecialComment',
            },
          }

          vim.keymap.set({ 'i' }, '<C-N>', function()
            vfn['pum#map#insert_relative'](1)
          end)
          vim.keymap.set({ 'i' }, '<C-P>', function()
            vfn['pum#map#insert_relative'](-1)
          end)
          vim.keymap.set({ 'i' }, '<C-Y>', function()
            vfn['pum#map#confirm']()
          end)
        end,
      },
      {
        'vim-skk/skkeleton',
        dependencies = { 'vim-denops/denops.vim' },
        keys = {
          { '<C-J>', '<Plug>(skkeleton-enable)', mode = { 'i', 'c', 'l' } },
        },
        config = function()
          vfn['skkeleton#config'] {
            globalDictionaries = { '~/.local/share/skk/SKK-JISYO.L' },
            userDictionary = '~/Library/Application Support/AquaSKK/skk-jisyo.utf8',
            keepState = false,
            eggLikeNewline = true,
          }
          vfn['skkeleton#register_kanatable']('rom', {
            ['('] = { '（', '' },
            [')'] = { '）', '' },
            ['z '] = { '　', '' },
            ['/'] = { '・', '' },
          })

          api.nvim_create_autocmd('User', {
            pattern = 'skkeleton-enable-pre',
            callback = function()
              vfn['ddc#custom#patch_buffer']('sources', { 'skkeleton' })
            end
          })
        end,
        priority = 10,
      },
    },
    config = function()
      vfn['ddc#custom#patch_global'] {
        ui = { 'pum' },
        sources = { 'around', 'buffer', 'nvim-lsp', 'file' },
        -- sources = { 'around', 'buffer', 'nvim-lsp', 'file', 'skkeleton' },
        sourceOptions = {
          ['_'] = {
            matchers = { 'matcher_head' },
            sorters = { 'sorter_rank' }
          },
          around = { mark = 'A' },
          buffer = { mark = 'B' },
          ['nvim-lsp'] = { mark = 'lsp' },
          file = {
            mark = 'F',
            isVolatile = true,
            forceCompletionPattern = [[\S/\S*]],
          },
          skkeleton = {
            mark = 'SKK',
            matchers = { 'skkeleton' },
            sorters = {},
            isVolatile = true,
          },
        },
        sourceParams = {
          around = { maxSize = 500 },
          buffer = {
            requireSameFiletype = false,
            limitBytes = 5000000,
            fromAltBuf = true,
            forceCollect = true,
          },
          ['nvim-lsp'] = { kindLabels = { Class = 'c' } }
        },
      }
      vfn['ddc#custom#patch_filetype']('filtration-prompt', 'ui', 'none')
      vfn['ddc#enable']()
    end,
  },
}
