local vim = vim
local api = vim.api
local vfn = vim.fn
local vv = vim.v

local M = {}

local function get_cms()
  local cms = vim.bo.commentstring:match('(.*)%%s') or ''
  return vim.trim(vim.pesc(cms))
end

local function get_content()
  local marker = ('%%s*%s.*$'):format(vim.opt.foldmarker:get()[1])
  local cms = ('%%s*%s$'):format(get_cms())
  local lnum = vv.foldstart
  local line = api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  return line:gsub(marker, ''):gsub(cms, '')
end

local function get_textwidth()
  local wnum = api.nvim_get_current_win()
  local offwidth = vfn.getwininfo(wnum)[1].textoff
  return api.nvim_win_get_width(0) - offwidth
end

function M.foldtext()
  local content = get_content()
  local line_cnt = ('%3d L'):format(vv.foldend - vv.foldstart + 1)
  local fillchar = vim.opt.fillchars:get().fold

  local textwidth = get_textwidth()
  local levwidth = vv.foldlevel * 2
  local full_contentwidth = vfn.strdisplaywidth(content)
  local max_contentwidth = textwidth - line_cnt:len() - 2 - levwidth

  local contentwidth = math.min(full_contentwidth, max_contentwidth - 1)
  local fillwidth = textwidth - contentwidth - line_cnt:len() - 3 - levwidth

  return table.concat({
    vfn.strcharpart(content, 0, contentwidth),
    fillchar:rep(fillwidth),
    line_cnt,
    fillchar:rep(levwidth),
  }, ' ')
end

return M
