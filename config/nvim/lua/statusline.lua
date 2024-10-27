local api = vim.api

local M = {}

local hl_tbl = {
  StatusLineInactive = { fg = '#99a9b3', bg = '#3b444f' },
  StatusLinePreview = { fg = '#99a9b3', bg = '#3b444f' },
  StatusLineCommand0 = { fg = '#2c3643', bg = '#dbe6ec' },
  StatusLineCommand1 = { fg = '#dbe6ec', bg = '#3b444f' },
  StatusLineInsert0 = { fg = '#2c3643', bg = '#16c98d' },
  StatusLineInsert1 = { fg = '#16c98d', bg = '#3b444f' },
  StatusLineNormal0 = { fg = '#2c3643', bg = '#8abee5' },
  StatusLineNormal1 = { fg = '#8abee5', bg = '#3b444f' },
  StatusLineReplace0 = { fg = '#2c3643', bg = '#ff708e' },
  StatusLineReplace1 = { fg = '#ff708e', bg = '#3b444f' },
  StatusLineTerminal0 = { fg = '#2c3643', bg = '#27dede' },
  StatusLineTerminal1 = { fg = '#27dede', bg = '#3b444f' },
  StatusLineVisual0 = { fg = '#2c3643', bg = '#288ad6' },
  StatusLineVisual1 = { fg = '#288ad6', bg = '#3b444f' },
}

function M.highlight()
  for name, val in pairs(hl_tbl) do
    api.nvim_set_hl(0, name, val)
  end
end

local function filename(bnum)
  local bufname = api.nvim_buf_get_name(bnum)
  local basename = vim.fs.basename(bufname)
  local is_modified = api.nvim_get_option_value('modified', { buf = bnum })
  local is_readonly = api.nvim_get_option_value('readonly', { buf = bnum })
  return table.concat {
    bufname == '' and '[No Name]' or basename,
    is_modified and ' +' or '',
    is_readonly and ' -' or '',
  }
end

local function get_mode()
  local mode_code = api.nvim_get_mode()['mode']
  local mode_map = {
    ['n'] = 'NORMAL',
    ['no'] = 'O-PENDING',
    ['nov'] = 'O-PENDING',
    ['noV'] = 'O-PENDING',
    ['no'] = 'O-PENDING',
    ['niI'] = 'NORMAL',
    ['niR'] = 'NORMAL',
    ['niV'] = 'NORMAL',
    ['nt'] = 'NORMAL',
    ['v'] = 'VISUAL',
    ['V'] = 'V-LINE',
    [''] = 'V-BLOCK',
    ['s'] = 'SELECT',
    ['S'] = 'S-LINE',
    [''] = 'S-BLOCK',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    ['Rc'] = 'REPLACE',
    ['Rv'] = 'V-REPLACE',
    ['Rx'] = 'REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'EX',
    ['ce'] = 'EX',
    ['r'] = 'REPLACE',
    ['rm'] = 'MORE',
    ['r?'] = 'CONFIRM',
    ['!'] = 'SHELL',
    ['t'] = 'TERMINAL',
  }

  return mode_map[mode_code] or mode_code
end

local function get_mode_group()
  local mode = vim.fn.mode()
  if vim.tbl_contains({ 'v', 'V', '', 's', 'S', '' }, mode) then
    return 'Visual'
  elseif vim.tbl_contains({ 'R', 'r' }, mode) then
    return 'Replace'
  elseif mode == 'i' then
    return 'Insert'
  elseif mode == 'c' then
    return 'Command'
  elseif mode == 't' then
    return 'Terminal'
  end
  return 'Normal'
end

local function hi_group(num)
  local mode_group = get_mode_group()
  return table.concat { '%#StatusLine', mode_group, num, '#' }
end

local function get_skk_mode()
  local skk_mode_map = {
    hira = 'あ',
    kata = 'ア',
    hankata = 'ｱ',
  }
  return skk_mode_map[vim.g['skkeleton#mode']] or ''
end

local function cmd_line()
  local line = { '%#StatusLineCommand0#', 'C-LINE', '%#StatusLineCommand1#' }
  return table.concat(line, ' ')
end

local function toc_line()
  local line = { '%#StatusLineNormal1#', 'CONTENTS' }
  return table.concat(line, ' ')
end

local function active_line()
  local line = {
    hi_group(0),
    get_mode(),
    hi_group(1),
    filename(0),
    '%=',
    get_skk_mode(),
    vim.b.texpreview and '●' or '',
    vim.bo.filetype == '' and 'no ft' or vim.bo.filetype,
    '%3p%%',
    hi_group(0),
    '%4l:%-2c ',
  }
  return table.concat(line, ' ')
end

local function preview_line()
  local line = { '%#StatusLinePreview#', 'PREVIEW', }
  return table.concat(line, ' ')
end

local function inactive_line()
  local win = vim.g.statusline_winid
  local bnum = api.nvim_win_get_buf(win)
  local line = { '%#StatusLineInactive#', filename(bnum) }
  return table.concat(line, ' ')
end

function M.statusline()
  local win = vim.g.statusline_winid
  local bnum = api.nvim_win_get_buf(win)
  local bufname = api.nvim_buf_get_name(bnum)

  if bufname:find('[Command Line]', 1, true) then
    return cmd_line()
  elseif bufname:find('Table of contents (VimTeX)', 1, true) then
    return toc_line()
  elseif win == api.nvim_get_current_win() then
    return active_line()
  elseif bufname:find('[Preview]', 1, true) then
    return preview_line()
  else
    return inactive_line()
  end
end

function M.qf_line()
  local wnum = api.nvim_get_current_win()
  local is_active = vim.g.statusline_winid == wnum
  local group, color, line

  if vim.fn.getwininfo(wnum)[1].loclist == 1 then
    group = is_active and 'Command0' or 'Inactive'
    color = ('%%#StatusLine%s#'):format(group)
    line = { color, 'LOCATION LIST', '%#StatusLineInactive#' }
  else
    group = is_active and 'Replace0' or 'Inactive'
    color = ('%%#StatusLine%s#'):format(group)
    line = { color, 'QUICKFIX', '%#StatusLineInactive#' }
  end

  return table.concat(line, ' ')
end

return M
