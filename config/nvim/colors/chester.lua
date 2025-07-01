local vim = vim
local api = vim.api

vim.cmd.highlight 'clear'
vim.cmd.syntax 'reset'

vim.g.colors_name = 'chester'

vim.o.background = 'dark'
vim.o.termguicolors = true

local p = {
  white = '#ffffff',
  verylightgray = '#dbe6ec',
  lightgray = '#99a9b3',
  gray = '#67747c',
  darkgray = '#3b444f',
  verydarkgray = '#2c3643',

  cyan = '#27dede',
  blue = '#288ad6',
  purple = '#ff708e',
  green = '#16c98d',
  red = '#fa5e5b',
  orange = '#ffc83f',
  lightorange = '#feef6d',

  softblue = '#8abee5',
  softgreen = '#c7e6aa',

  selectblue = '#1d508d',
}

local tbl = {
  -- highlight groups
  ColorColumn = { bg = p.darkgray },
  Conceal = { fg = p.lightgray, bg = p.darkgray },
  CurSearch = { link = 'Search' },
  Cursor = {},
  lCursor = {},
  CursorColumn = { bg = p.darkgray },
  CursorIM = {},
  CursorLine = {},
  Directory = { fg = p.cyan },
  DiffAdd = { fg = p.green },
  DiffChange = { fg = p.orange },
  DiffDelete = { fg = p.red },
  DiffText = { fg = p.blue },
  EndOfBuffer = { fg = p.gray },
  TermCursor = { reverse = true },
  TermCursorNC = {},
  ErrorMsg = { fg = p.white, bg = p.red },
  WinSeparator = { fg = p.verydarkgray, bg = p.verydarkgray },
  Folded = { fg = p.blue },
  FoldColumn = { fg = p.blue, bg = p.verydarkgray },
  SignColumn = { fg = p.cyan, bg = p.darkgray },
  IncSearch = { link = 'Search' },
  Substitute = { link = 'Search' },
  LineNr = { fg = p.lightgray },
  LineNrAbove = { fg = p.lightgray },
  LineNrBelow = { fg = p.lightgray },
  CursorLineNr = { fg = p.lightgray, bg = p.darkgray },
  CursorLineFold = { link = 'Folded' },
  CursorLineSign = { link = 'SignColumn' },
  MatchParen = { bold = true, underline = true },
  ModeMsg = { bold = true },
  MsgArea = {},
  MsgSeparator = { link = 'StatusLine' },
  MoreMsg = { fg = p.cyan },
  NonText = { fg = p.gray },
  Normal = { fg = p.verylightgray, bg = p.verydarkgray },
  NormalFloat = { bg = p.darkgray },
  FloatBorder = { link = 'NormalFloat' },
  FloatTitle = { fg = p.purple, bg = p.darkgray, bold = true },
  FloatFooter = { link = 'FloatTitle' },
  NormalNC = {},
  Pmenu = { bg = p.darkgray },
  PmenuSel = { bg = p.selectblue },
  PmenuKind = { link = 'Pmenu' },
  PmenuKindSel = { link = 'PmenuSel' },
  PmenuExtra = { link = 'Pmenu' },
  PmenuExtraSel = { link = 'PmenuSel' },
  PmenuSbar = { bg = p.gray },
  PmenuThumb = { fg = p.white, bg = p.white },
  Question = { fg = p.green, bold = true },
  QuickFixLine = { link = 'PmenuSel' },
  Search = { bg = p.selectblue },
  SnippetTabstop = { bg = p.selectblue },
  SpecialKey = { fg = p.gray },
  SpellBad = { sp = p.red, undercurl = true },
  SpellCap = { sp = p.blue, undercurl = true },
  SpellLocal = { sp = p.cyan, undercurl = true },
  SpellRare = { sp = p.purple, undercurl = true },
  StatusLine = { fg = p.softblue, bg = p.verydarkgray },
  StatusLineNC = { fg = p.lightgray, bg = p.verydarkgray },
  TabLine = { fg = p.lightgray, bg = p.darkgray },
  TabLineFill = { fg = p.lightgray, bg = p.darkgray },
  TabLineSel = { fg = p.softblue, bg = p.verydarkgray, bold = true },
  Title = { fg = p.purple, bold = true },
  Visual = { bg = p.selectblue },
  VisualNOS = {},
  WarningMsg = { fg = p.red },
  Whitespace = { fg = p.gray },
  WildMenu = { bg = '#1d508d' },
  Winbar = { link = 'StatusLine' },
  WinbarNC = { link = 'StatusLineNC' },

  -- Syntax highlight
  Comment = { fg = p.lightgray },

  Constant = { fg = p.orange },
  String = { fg = p.green },
  Character = { fg = p.cyan },
  Number = { fg = p.orange },
  Boolean = { fg = p.cyan },
  Float = { fg = p.cyan },

  Identifier = { fg = p.purple },
  Function = { fg = p.cyan },

  Statement = { fg = p.softblue },
  Conditional = { fg = p.softblue },
  Repeat = { fg = p.softblue },
  Label = { fg = p.softblue },
  Operator = { fg = p.verylightgray },
  Keyword = { fg = p.softblue },
  Exception = { fg = p.softblue },

  PreProc = { fg = p.blue },
  Include = { fg = p.blue },
  Define = { fg = p.blue },
  Macro = { fg = p.blue },
  PreCondit = { fg = p.blue },

  Type = { fg = p.purple },
  StorageClass = { fg = p.purple },
  Structure = { fg = p.purple },
  Typedef = { fg = p.purple },

  Special = { fg = p.orange },
  SpecialChar = { fg = p.orange },
  Tag = { fg = p.orange },
  Delimiter = { fg = p.verylightgray },
  SpecialComment = { fg = p.orange },
  Debug = { fg = p.orange },

  Underlined = { fg = p.blue, underline = true },

  Ignore = {},

  Error = { fg = p.white, bg = p.red, bold = true },

  Todo = { fg = p.red, standout = true, bold = true },

  Added = { link = 'DiffAdd' },
  Changed = { link = 'DiffChange' },
  Removed = { link = 'DiffDelete' },

  -- Diagnostic highlight
  DiagnosticError = { fg = p.red },
  DiagnosticWarn = { fg = p.orange },
  DiagnosticInfo = { fg = p.cyan },
  DiagnosticHint = { fg = p.softblue },
  DiagnosticOk = { fg = p.softgreen },

  -- Identifiers

  ['@variable'] = { link = 'Normal' },
  ['@variable.builtin'] = { link = 'Keyword' },
  ['@variable.parameter'] = { link = 'Identifier' },
  ['@variable.member'] = { link = 'Identifier' },

  ['@constant'] = { link = 'Constant' },
  ['@constant.builtin'] = { link = 'Special' },
  ['@constant.macro'] = { link = 'Define' },

  ['@module'] = { link = 'Identifier' },
  ['@module.builtin'] = { link = 'Identifier' },
  ['@label'] = { link = 'Label' },

  -- Literals

  ['@string'] = { link = 'String' },
  ['@string.regexp'] = { link = 'SpecialChar' },
  ['@string.escape'] = { link = 'SpecialChar' },

  ['@character'] = { link = 'Character' },
  ['@character.special'] = { link = 'SpecialChar' },

  ['@boolean'] = { link = 'Boolean' },
  ['@number'] = { link = 'Number' },
  ['@number.float'] = { link = 'Float' },

  -- Types

  ['@type'] = { link = 'Type' },
  ['@type.definition'] = { link = 'Typedef' },

  ['@attribute'] = { link = 'Constant' },
  ['@property'] = { link = 'Identifier' },

  -- Functions

  ['@function'] = { link = 'Function' },
  ['@function.builtin'] = { link = 'Special' },
  ['@function.macro'] = { link = 'Macro' },

  ['@function.method'] = { link = 'Function' },
  ['@function.method.call'] = { link = 'Function' },

  ['@constructor'] = { link = 'Special' },
  ['@operator'] = { link = 'Operator' },

  -- Keywords

  ['@keyword'] = { link = 'Keyword' },
  ['@keyword.function'] = { link = 'Keyword' },
  ['@keyword.operator'] = { link = 'Keyword' },
  ['@keyword.import'] = { link = 'Include' },
  ['@keyword.storage'] = { link = 'StorageClass' },
  ['@keyword.repeat'] = { link = 'Repeat' },
  ['@keyword.return'] = { link = 'Keyword' },
  ['@keyword.debug'] = { link = 'Debug' },
  ['@keyword.exception'] = { link = 'Exception' },

  ['@keyword.conditional'] = { link = 'Conditional' },
  ['@keyword.conditional.ternary'] = { link = 'Conditional' },

  ['@keyword.directive'] = { link = 'PreProc' },
  ['@keyword.directive.define'] = { link = 'Define' },

  -- Punctuation

  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { link = 'Delimiter' },

  -- Comments

  ['@comment'] = { link = 'Comment' },
  ['@comment.documentation'] = { link = 'Comment' },

  ['@comment.error'] = { link = 'DiagnosticError' },
  ['@comment.warning'] = { link = 'WarningMsg' },
  ['@comment.todo'] = { link = 'Todo' },
  ['@comment.note'] = { link = 'Todo' },

  -- Markup

  ['@markup.strong'] = { bold = true },
  ['@markup.italic'] = { italic = true },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.underline'] = { link = 'Underlined' },

  ['@markup.heading'] = { link = 'Title' },
  ['@markup.heading.2'] = { fg = p.purple },

  ['@markup.math'] = { link = 'Special' },
  ['@markup.environment'] = { link = 'Statement' },
  ['@markup.environment.name'] = { link = 'PreCondit' },

  ['@markup.link'] = { link = 'Identifier' },
  ['@markup.link.label'] = { link = 'SpecialChar' },
  ['@markup.link.url'] = { link = 'Underlined' },

  ['@markup.raw'] = { link = 'String' },

  ['@markup.list'] = { link = 'Delimiter' },

  ['@markup.emphasis'] = { fg = p.purple, bold = true, italic = true },

  -- Misc

  ['@diff.plus'] = { link = 'DiffAdd' },
  ['@diff.minus'] = { link = 'DiffDelete' },
  ['@diff.delta'] = { link = 'DiffChange' },

  ['@tag'] = { link = 'Tag' },
  ['@tag.attribute'] = { link = 'Tag' },
  ['@tag.delimiter'] = { link = 'Tag' },

  ['@structure'] = { link = 'Structure' },

  ['@annotation'] = { link = 'Annotation' },
}

for name, val in pairs(tbl) do
  api.nvim_set_hl(0, name, val)
end
