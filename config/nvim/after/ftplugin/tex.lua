local vim = vim
local api = vim.api
local map = vim.keymap.set

vim.g.plaintex_delimiters = 1
vim.g.tex_flavor = 'latex'
vim.g.tex_comment_nospell = 1

vim.opt_local.colorcolumn = '80'
vim.opt_local.spell = true

vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'

vim.treesitter.query.set('latex', 'folds', [[
  [
    (generic_environment (begin (curly_group_text
      text: (text) @_name
      (#any-contains? @_name
       "frame"
       "theorem"
       "proposition"
       "lemma"
       "corollary"
       "assumption"
       "axiom"
       "condition"
       "definition"
       "example"
       "exercise"
       "postulate"
       "claim"
       "note"
       "remark"
       "proof"))))
  ] @fold
]])

local prev_map = {
  [' ll'] = 'toggle',
  [' lv'] = 'view_pdf',
  [' ls'] = 'save_pdf',
  [' le'] = 'qf_toggle',
}

for lhs, fn in pairs(prev_map) do
  map('n', lhs, function() require 'texpreview'[fn]() end, { buffer = true })
end

map('n', ' lc', function()
  local texprev = require 'texpreview'
  texprev.save_pdf()
  vim.schedule(texprev.clean)
end, { buffer = true })

map('n', ' lt', function()
  require 'latex-toc'.display()
end, { buffer = true })

map('i', [[\{]], [[\{\}<Left><Left>]], { buffer = true })

local ts_tbl = {
  ['@punctuation.special.latex'] = { link = 'Label' }, -- enum_item
  ['@namespace.latex'] = { link = 'include' },
}

for name, val in pairs(ts_tbl) do
  api.nvim_set_hl(0, name, val)
end

do
  require 'texmap'.init(require 'texmap'.config)

  local opts = { buffer = true, silent = true, nowait = true }

  map('n', 'cse', '<Plug>(rename_env)', opts)
  map('n', 'dse', '<Plug>(delete_env)', opts)
  map('n', 'cs$', '<Plug>(display_dollars)', opts)
  map('n', 'ds$', '<Plug>(delete_dollars)', opts)
  map('n', 'csd', '<Plug>(resize_delims)', opts)
  map('n', 'dsd', '<Plug>(delete_delims)', opts)

  map({ 'n', 'x', 'o' }, ']]', '<Plug>(next_section)zt', opts)
  map({ 'n', 'x', 'o' }, '[[', '<Plug>(prev_section)zt', opts)
  map({ 'n', 'x', 'o' }, ']m', '<Plug>(next_item)', opts)
  map({ 'n', 'x', 'o' }, '[m', '<Plug>(prev_item)', opts)

  map({ 'x', 'o' }, 'aP', '<Plug>(a_section)', opts)
  map({ 'x', 'o' }, 'iP', '<Plug>(i_section)', opts)
  map({ 'x', 'o' }, 'ae', '<Plug>(a_env)', opts)
  map({ 'x', 'o' }, 'ie', '<Plug>(i_env)', opts)
  map({ 'x', 'o' }, 'a$', '<Plug>(a_dollar)', opts)
  map({ 'x', 'o' }, 'i$', '<Plug>(i_dollar)', opts)
  map({ 'x', 'o' }, 'ad', '<Plug>(a_delim)', opts)
  map({ 'x', 'o' }, 'id', '<Plug>(i_delim)', opts)
  map({ 'x', 'o' }, 'am', '<Plug>(a_item)', opts)
  map({ 'x', 'o' }, 'im', '<Plug>(i_item)', opts)
end
