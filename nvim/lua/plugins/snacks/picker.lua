-- Only overrides of snacks.picker defaults; see `:h snacks-picker-config` for the rest.
---@type snacks.picker.Config
return {
  matcher = {
    cwd_bonus = true, -- give bonus for matching files in the cwd
    frecency = true,  -- frecency bonus
  },
  win = {
    input = {
      keys = {
        ["q"] = "close",
        ["<a-i>"] = { { "toggle_ignored", "toggle_hidden" }, mode = { "i", "n" } },
        ["<c-l>"] = { "loclist", mode = { "i", "n" } },
      },
    },
  },
}
