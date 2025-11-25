local startup = require 'startup'
local autocmds = require 'autocmds'
local keymaps = require 'keymaps'
local options = require 'options'

local vim = vim
local api = vim.api
local vfn = vim.fn

if vfn.has 'vim_starting' == 1 then
  for name, val in pairs(startup) do
    api.nvim_set_var(name, val)
  end
end

local lazypath = table.concat({ vfn.stdpath 'data', 'lazy', 'lazy.nvim' }, '/')
if not vim.uv.fs_stat(lazypath) then
  vim.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)
require 'lazy'.setup('plugins', {
  dev = {
    path = vim.fs.joinpath(os.getenv 'HOME', 'repos'),
    fallback = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  colorscheme = { 'chester' },
  rocks = { enabled = false },
})

local id = api.nvim_create_augroup('MyAutoCmd', {})
for _, def in ipairs(autocmds) do
  local event = def.event
  local opts = vim.tbl_extend('keep', def, { group = id })
  opts.event = nil
  api.nvim_create_autocmd(event, opts)
end

vim.cmd.colorscheme 'chester'

api.nvim_set_hl(0, 'SignColumn', { bg = 'None' })
api.nvim_set_hl(0, 'CursorLineNr', { fg = '#feef6d', bg = '#3b444f' })

for _, v in ipairs({ 'Add', 'Change', 'Delete' }) do
  api.nvim_set_hl(0, 'GitSigns' .. v, { link = 'Diff' .. v })
end

for _, group in ipairs(vfn.getcompletion('@lsp', 'highlight')) do
  api.nvim_set_hl(0, group, {})
end

for mode, maps in pairs(keymaps) do
  for lhs, rhs in pairs(maps) do
    vim.keymap.set(mode, lhs, rhs)
  end
end

for name, value in pairs(options) do
  vim.opt[name] = value
  vim.opt_global[name] = value
end

vim.o.secure = true
