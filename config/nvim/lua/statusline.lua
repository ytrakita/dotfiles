local api = vim.api

local M = {}

local p = {
  verylightgray = '#dbe6ec',
  lightgray = '#99a9b3',
  darkgray = '#3b444f',
  verydarkgray = '#2c3643',
  cyan = '#27dede',
  blue = '#288ad6',
  purple = '#ff708e',
  green = '#16c98d',
  red = '#fa5e5b',
  orange = '#ffc83f',
  softblue = '#8abee5',
}

local hl_tbl = {
  Command = p.verylightgray,
  Insert = p.green,
  Normal = p.softblue,
  Replace = p.purple,
  Terminal = p.cyan,
  Visual = p.blue,
}

local hl_tbl_git = {
  Add = p.green,
  Change = p.orange,
  Delete = p.red,
}

function M.highlight()
  local s = 'StatusLine'
  for name, val in pairs(hl_tbl) do
    api.nvim_set_hl(0, s .. name .. '0', { fg = p.verydarkgray, bg = val })
    api.nvim_set_hl(0, s .. name .. '1', { fg = val, bg = p.darkgray })
  end
  for name, val in pairs(hl_tbl_git) do
    api.nvim_set_hl(0, s .. name, { fg = val, bg = p.darkgray })
  end
  for _, name in ipairs({ 'Inactive', 'Preview' }) do
    api.nvim_set_hl(0, s .. name, { fg = p.lightgray, bg = p.darkgray })
  end
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

local function hl_group(num)
  local mode_group = get_mode_group()
  return table.concat { '%#StatusLine', mode_group, num, '#' }
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
  local str = mode_map[mode_code] or mode_code
  return table.concat({ hl_group(0), str, '' }, ' ')
end

local function get_fname(bnum)
  local bname = api.nvim_buf_get_name(bnum)
  local fname = vim.fn.fnamemodify(bname, ':~:.')
  local is_modified = api.nvim_get_option_value('modified', { buf = bnum })
  local is_readonly = api.nvim_get_option_value('readonly', { buf = bnum })
  return table.concat {
    hl_group(1),
    '%=   %<',
    bname == '' and '[No Name]' or fname,
    is_modified and ' +' or '',
    is_readonly and ' -' or '',
    ' %=',
  }
end

local function get_texprevstatus()
  local str = vim.b.texpreview and ' ●' or ''
  return table.concat { hl_group(1), str }
end

local function get_gitstatus()
  local tab = vim.b.gitsigns_status_dict
  if not tab then return '' end
  local branch = tab.head and table.concat {
    hl_group(1), '  ', tab.head,
  } or ''
  local added = tab.added and table.concat {
    '%#StatusLineAdd#', ' +', tab.added,
  } or ''
  local changed = tab.changed and table.concat {
    '%#StatusLineChange#', ' ~', tab.changed,
  } or ''
  local removed = tab.removed and table.concat {
    '%#StatusLineDelete#', ' -', tab.removed,
  } or ''
  return table.concat { branch, added, changed, removed }
end

local function get_ftype()
  local str = vim.bo.filetype == '' and 'no ft' or vim.bo.filetype
  return table.concat({ hl_group(1), str }, ' ')
end

local function get_cursor()
  return table.concat({ hl_group(1), hl_group(0), '%4l:%-2c ' }, ' ')
end

local function cmd_line()
  local line = { '%#StatusLineCommand0#', 'C-LINE', '%#StatusLineCommand1#' }
  return table.concat(line, ' ')
end

local function active_line()
  return table.concat {
    get_mode(),
    get_fname(0),
    get_texprevstatus(),
    get_gitstatus(),
    get_ftype(),
    get_cursor(),
  }
end

local function preview_line()
  local line = { '%#StatusLinePreview#', 'PREVIEW', }
  return table.concat(line, ' ')
end

local function inactive_line()
  local win = vim.g.statusline_winid
  local bnum = api.nvim_win_get_buf(win)
  local line = { '%#StatusLineInactive#', '%=', get_fname(bnum), '%=' }
  return table.concat(line, ' ')
end

function M.statusline(is_cmdline)
  local win = vim.g.statusline_winid
  local bnum = api.nvim_win_get_buf(win)
  local bname = api.nvim_buf_get_name(bnum)
  if win == api.nvim_get_current_win() then
    return is_cmdline and cmd_line() or active_line()
  elseif bname:find('[Preview]', 1, true) then
    return preview_line()
  else
    return inactive_line()
  end
end

function M.qf_line()
  local wnum = api.nvim_get_current_win()
  local is_loclist = vim.fn.getwininfo(wnum)[1].loclist == 1
  local group = 'Inactive'
  if vim.g.statusline_winid == wnum then
    group = is_loclist and 'Command0' or 'Replace0'
  end
  return table.concat({
    ('%%#StatusLine%s#'):format(group),
    is_loclist and 'LOCATION LIST' or "QUICKFIX",
    '%#StatusLineInactive#',
  }, ' ')
end

return M
