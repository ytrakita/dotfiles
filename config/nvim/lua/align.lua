local api = vim.api

local M = {}

---get the maximum in the list of numbers
---@param tbl number[]
---@return number
local function maximum(tbl)
  local max = tbl[1]
  for i = 2, #tbl do
    max = math.max(max, tbl[i])
  end
  return max
end

---@param lines string[]
---@param char string
---@param init integer
---@return integer[]
local function get_indices(lines, char, init)
  local indices = {}
  for lnum, line in ipairs(lines) do
    indices[lnum] = line:find(char, init) or 0
  end
  return indices
end

---@class align.Opts
---@field is_left? boolean

---@param lines string[]
---@param char string
---@param init integer
---@param opts align.Opts
---@return string[]
---@return integer
local function alignat(lines, char, init, opts)
  local indices = get_indices(lines, char, init)
  local max_idx = maximum(indices)
  local ret = {}
  for lnum, line in ipairs(lines) do
    local idx = indices[lnum]
    if idx > 0 then
      local diff = max_idx - idx
      idx = idx + (opts.is_left and -1 or 0)
      local post = line:sub(idx + 1)
      local pad = #post > 0 and (' '):rep(diff) or ''
      line = line:sub(1, idx) .. pad .. post
    end
    ret[lnum] = line
  end
  return ret, max_idx
end

---@param lines string[]
---@param char string
---@param opts align.Opts
---@return string[]
local function align(lines, char, opts)
  local init
  while not init or init > 0 do
    init = init or 0
    lines, init = alignat(lines, char, init + 1, opts)
  end
  return lines
end

---@param is_left boolean
local function handle(is_left, ...)
  local char = vim.fn.getcharstr()

  if type(char) ~= 'string' or #char > 1 then return end

  local lnum1, lnum2 = select(1, ...), select(2, ...)
  if type(lnum1) == 'string' then
    lnum1 = api.nvim_buf_get_mark(0, '[')[1]
    lnum2 = api.nvim_buf_get_mark(0, ']')[1]
  end

  local lines = api.nvim_buf_get_lines(0, lnum1 - 1, lnum2, true)
  local aligned = align(lines, char, { is_left = is_left })
  api.nvim_buf_set_lines(0, lnum1 - 1, lnum2, false, aligned)
end

function M.left(...)
  handle(true, ...)
end

function M.right(...)
  handle(false, ...)
end

return M
