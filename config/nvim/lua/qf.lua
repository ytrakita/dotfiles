local vim = vim
local api = vim.api
local vfn = vim.fn

local M = {}

-- https://github.com/kevinhwang91/nvim-bqf
function M.textfunc(info)
  local items
  local lines = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  -- It's a good opportunity to change current directory in quickfixtextfunc :)
  --
  -- local alterBufnr = fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = vfn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vfn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local max_fnamewidth = 26
  local fnamefmt1 = '%-s'
  local fnamefmt2 = '…%.' .. (max_fnamewidth - 1) .. 's'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local line
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = api.nvim_buf_get_name(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = vfn.fnamemodify(fname, ':~:.')
        end
        local fnamewidth = vfn.strdisplaywidth(fname)
        if fnamewidth <= max_fnamewidth then
          fname = fnamefmt1:format(fname)
        else
          fname = vfn.strcharpart(fname, fnamewidth - max_fnamewidth + 1, fnamewidth)
          fname = fnamefmt2:format(fname)
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      line = ('%s │%5d:%-3d│%s %s'):format(fname, lnum, col, qtype, e.text)
    else
      line = e.text
    end
    table.insert(lines, line)
  end
  return lines
end

return M
