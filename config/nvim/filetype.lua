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
    ['.*/_layouts/.*%.html'] = 'liquid',
    ['.*/_includes/.*%.html'] = 'liquid',
  },
}
