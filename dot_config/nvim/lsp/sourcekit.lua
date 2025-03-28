local config = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'objc', 'objcpp', 'c', 'cpp' },
    root_markers = { "buildServer.json", "*.xcodeproj" },
    get_language_id = function(_, ftype)
      local t = { objc = 'objective-c', objcpp = 'objective-cpp' }
      return t[ftype] or ftype
    end,
    capabilities = {
      textDocument = {
        diagnostic = {
          dynamicRegistration = true,
          relatedDocumentSupport = true,
        },
      },
    },
  }
return config
