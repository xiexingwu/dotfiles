return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  dependencies = {
    { 'gonstoll/wezterm-types', lazy = true },
  },
  opts = {
    library = {
      -- always load the LazyVim library
      "LazyVim",
      -- Only load the lazyvim library when the `LazyVim` global is found
      { path = "LazyVim",                                                               words = { "LazyVim" } },
      -- Load the wezterm types when the `wezterm` module is required
      -- Needs `justinsgithub/wezterm-types` to be installed
      { path = "wezterm-types",                                                         mods = { "wezterm" } },
      { path = "/Users/xiexingwu/.config/hammerspoon/Spoons/EmmyLua.spoon/annotations", words = { "hs" } },
    },
    -- always enable unless `vim.g.lazydev_enabled = false`
    -- This is the default
    enabled = function(root_dir)
      return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end,
    -- disable when a .luarc.json file is found
    enabled = function(root_dir)
      return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
    end,
  },
}
