local api = vim.api

local M = {}

local p = {
  verylightgray = '#dbe6ec',
  lightgray = '#99a9b3',
  darkgray = '#3b444f',
  verydarkgray = '#2c3643',
  green = '#16c98d',
  softblue = '#8abee5',
  purple = '#ff708e',
  cyan = '#27dede',
  blue = '#288ad6',
}

local hl_tbl = {
  Command = p.verylightgray,
  Insert = p.green,
  Normal = p.softblue,
  Replace = p.purple,
  Terminal = p.cyan,
  Visual = p.blue,
}

function M.highlight()
  local s = 'StatusLine'
  for name, val in pairs(hl_tbl) do
    api.nvim_set_hl(0, s .. name .. '0', { fg = p.verydarkgray, bg = val })
    api.nvim_set_hl(0, s .. name .. '1', { fg = val, bg = p.darkgray })
  end
  api.nvim_set_hl(0, s .. 'Inactive', { fg = p.lightgray, bg = p.darkgray })
  api.nvim_set_hl(0, s .. 'Preview', { fg = p.lightgray, bg = p.darkgray })
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

local function cmd_line()
  local line = { '%#StatusLineCommand0#', 'C-LINE', '%#StatusLineCommand1#' }
  return table.concat(line, ' ')
end

local function active_line()
  local line = {
    hi_group(0),
    get_mode(),
    hi_group(1),
    filename(0),
    '%=',
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
