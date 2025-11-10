vim.filetype.add {
  extension = {
    cls = 'plaintex',
    def = 'plaintex',
    sty = 'plaintex',
    tex = 'tex',
    snippets = 'snippets',
  },
  filename  = {
    Brewfile = 'ruby',
    ['kitty.conf'] = 'kitty',
  },
  pattern = {
    ['.*/git/config'] = 'git_config',
    ['.*/git/ignore'] = 'gitignore',
    ['.*/_layouts/.*%.html'] = 'liquid',
    ['.*/_includes/.*%.html'] = 'liquid',
  },
}
