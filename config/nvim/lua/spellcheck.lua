local vim = vim
local api = vim.api
local vfn = vim.fn

local M = {}

local function get_spell_list()
  local bufnr = api.nvim_get_current_buf()
  local wrapscan = vim.opt.wrapscan:get()
  local view = vfn.winsaveview()
  local spell_list = {}

  vim.opt.wrapscan = false
  vim.cmd 'silent! keepjumps normal! gg0'

  local cursor = { 1, 0 }

  while true do
    vim.cmd 'silent! keepjumps normal! ]s'
    local pos = api.nvim_win_get_cursor(0)
    if pos[1] == cursor[1] and pos[2] == cursor[2] then
      break
    end
    local word, type = unpack(vfn.spellbadword())
    table.insert(spell_list, {
      bufnr = bufnr,
      lnum = pos[1],
      col = pos[2] + 1,
      text = ('%s: %s'):format(type, word),
    })
    cursor = pos
  end

  vfn.winrestview(view)
  vim.opt.wrapscan = wrapscan

  return spell_list
end

function M.open_list()
  if not vim.opt.spell:get() then
    vim.notify('Option spell is false')
    return
  end
  vfn.setloclist(0, {}, 'r')
  local spell_list = get_spell_list()
  vfn.setloclist(0, spell_list)
  if vim.tbl_isempty(vfn.getloclist(0)) then
    api.nvim_echo({ { 'No spell errors' } }, false, {})
    return
  end
  vfn.setloclist(0, {}, 'a', { title = 'spell check' })
  vim.cmd.lopen()
end

return M
