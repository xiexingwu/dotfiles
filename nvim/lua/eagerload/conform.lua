return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      -- Customize or remove this keymap to your liking
      "<leader>fm",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "[F]or[m]at buffer (Conform)",
    },
  },
  opts = {
    -- Set default options
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      superhtml = {
        inherit = false,
        command = 'superhtml',
        stdin = true,
        args = { 'fmt', '--stdin-super' },
      },
      ziggy = {
        inherit = false,
        command = 'ziggy',
        stdin = true,
        args = { 'fmt', '--stdin' },
      },
      ziggy_schema = {
        inherit = false,
        command = 'ziggy',
        stdin = true,
        args = { 'fmt', '--stdin-schema' },
      },
    },

    formatters_by_ft = {
      shtml = { 'superhtml' },
      ziggy = { 'ziggy' },
      ziggy_schema = { 'ziggy_schema' },
    },
    format_on_save = nil,
    format_after_save = nil,
  }
}
