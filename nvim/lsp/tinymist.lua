local config = {
  cmd = { 'tinymist' },
  filetypes = { 'typst' },
  root_markers = { 'main.typ', '.git' },
  settings = {
    -- Use your favourite pdf viewer that auto refreshes, e.g. sioyek
    exportPdf = "onSave",
    projectResolution = "lockDatabase",
    formatterMode = "typstyle",
  },
}

return config
