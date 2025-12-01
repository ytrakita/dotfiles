local vim = vim
local api = vim.api
local ts = vim.treesitter

vim.g.plaintex_delimiters = 1
vim.g.tex_flavor = 'latex'
vim.g.tex_comment_nospell = 1

vim.opt_local.commentstring = '% %s'

vim.opt_local.colorcolumn = '80'
vim.opt_local.spell = true
vim.opt_local.foldmethod = 'expr'
vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

vim.treesitter.query.set('latex', 'folds', [[
  [
    (generic_environment (begin (curly_group_text
      text: (text) @_name
      (#any-contains? @_name
       "frame"
       "dframe"
       "figure"
       "table"
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
       "conjecture"
       "proof"))))
  ] @fold
]])

local ts_tbl = {
  ['@punctuation.special.latex'] = { link = 'Label' }, -- enum_item
  ['@namespace.latex'] = { link = 'include' },
}

for name, val in pairs(ts_tbl) do
  api.nvim_set_hl(0, name, val)
end

local delims = {}

do
  local function get_delim_ranges(delim)
    local motion = 'a' .. delim
    local tbl = require 'nvim-surround.config'.get_selection { motion = motion }
    local ind_brace = delim == '}' and 1 or 0
    local lr, lc = unpack(tbl.first_pos)
    local rr, rc = unpack(tbl.last_pos)

    if delim == '}'
      and api.nvim_buf_get_text(0, lr - 1, lc - 2, lr - 1, lc, {}) ~= '\\{' then
      return
    end

    return { lr, lc - ind_brace, lr, lc + 1 }, { rr, rc - ind_brace, rr, rc + 1 }
  end

  local mark_ns = api.nvim_create_namespace('ft_tex_delims')

  local function highlight_delims(l_range, r_range)
    local mark_id_tbl = {}
    for _, range in ipairs({ l_range, r_range }) do
      local r1, r2, r3, r4 = unpack(range)
      local id = api.nvim_buf_set_extmark(0, mark_ns, r1 - 1, r2 - 1, {
        end_row = r3 - 1,
        end_col = r4 - 1,
        hl_group = 'texmapSurrounds',
      })
      table.insert(mark_id_tbl, id)
    end
    return mark_id_tbl
  end

  local size_tbl = { 'normal', 'big', 'Big', 'bigg', 'Bigg', 'auto' }

  local function get_size_cmds(size)
    if not vim.tbl_contains(size_tbl, size) then return end

    if size == 'normal' then return { left = '', right = '' } end
    if size == 'auto' then return { left = '\\left', right = '\\right' } end
    return { left = '\\' .. size .. 'l', right = '\\' .. size ..'r' }
  end

  local function _resize_delims(l_range, r_range, size)
    local size_cmds = get_size_cmds(size)
    if not size_cmds then return end

    local lr, lc = l_range[1] - 1, l_range[2] - 1
    local rr, rc = r_range[1] - 1, r_range[2] - 1

    api.nvim_buf_set_text(0, rr, rc, rr, rc, { size_cmds.right })
    api.nvim_buf_set_text(0, lr, lc, lr, lc, { size_cmds.left })
  end

  function delims.resize(delim)
    local l_range, r_range = get_delim_ranges(delim)
    if not l_range then return end

    local l_node = ts.get_node { pos = { l_range[1] - 1, l_range[2] } }
    if not require 'texmap.utils'.is_mathzone(l_node) then return end

    local mark_id_tbl = highlight_delims(l_range, r_range)

    vim.schedule(function()
      local opts = { prompt = 'New size: ' }
      vim.ui.select(size_tbl, opts, function(item)
        if item then
          _resize_delims(l_range, r_range, item)
        end
        for _, id in ipairs(mark_id_tbl) do
          api.nvim_buf_del_extmark(0, mark_ns, id)
        end
      end)
    end)

  end
end

require 'texmap'.init(require 'texmap'.config)

local keymaps = {
  n = {
    [' ll'] = function() require 'texpreview'.toggle() end,
    [' lb'] = function() require 'texpreview'.typeset() end,
    [' lv'] = function() require 'texpreview'.view_pdf() end,
    [' ls'] = function() require 'texpreview'.save_pdf() end,
    [' le'] = function() require 'texpreview'.qf_toggle() end,
    [' lc'] = function()
      local texprev = require 'texpreview'
      texprev.save_pdf()
      vim.schedule(texprev.clean)
    end,
    [' lt'] = function() require 'latex-toc'.display() end,
    cse = '<Plug>(rename_env)',
    dse = '<Plug>(delete_env)',
    ['cs$'] = '<Plug>(display_dollars)',
    ['ds$'] = '<Plug>(delete_dollars)',
    csd = '<Plug>(resize_delims)',
    dsd = '<Plug>(delete_delims)',
    [' r)'] = function() delims.resize(')') end,
    [' r]'] = function() delims.resize(']') end,
    [' r}'] = function() delims.resize('}') end,
  },
  nxo = {
    [']]'] = '<Plug>(next_section)',
    ['[['] = '<Plug>(prev_section)',
    [']m'] = '<Plug>(next_item)',
    ['[m'] = '<Plug>(prev_item)',
  },
  i = {
    ['\\{'] = [[\{\}<Left><Left>]],
  },
  xo = {
    aP = '<Plug>(a_section)',
    iP = '<Plug>(i_section)',
    ae = '<Plug>(a_env)',
    ie = '<Plug>(i_env)',
    ['a$'] = '<Plug>(a_dollar)',
    ['i$'] = '<Plug>(i_dollar)',
    ad = '<Plug>(a_delim)',
    id = '<Plug>(i_delim)',
    am = '<Plug>(a_item)',
    im = '<Plug>(i_item)',
  },
}

for mode, keymap in pairs(keymaps) do
  local mode_tbl = #mode > 1 and vim.fn.split(mode, '\\zs') or { mode }
  for lhs, rhs in pairs(keymap) do
    vim.keymap.set(mode_tbl, lhs, rhs, { buffer = true })
  end
end
