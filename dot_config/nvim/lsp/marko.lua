local config = {
  cmd = { 'marko-language-server', '--stdio' },
  filetypes = { 'marko' },
  root_markers = { 'package.json', },
}

return config
