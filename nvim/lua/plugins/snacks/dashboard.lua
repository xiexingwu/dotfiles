return {
  preset = {
    keys = {
      { icon = " ", key = "<leader>", desc = "Restore Session", section = "session" },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
  },

  sections = {
    { section = "header" },
    { section = "keys", gap = 1, pading = 1 },

    { gap = 1, pading = 1 },

    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
    {
      icon = " ",
      title = "Git Status",
      section = "terminal",
      enabled = function()
        return Snacks.git.get_root() ~= nil
      end,
      cmd = "git status --short --branch --renames",
      height = 5,
      padding = 1,
      ttl = 5 * 60,
      indent = 3,
    },

    { section = "startup" },
  },
}
