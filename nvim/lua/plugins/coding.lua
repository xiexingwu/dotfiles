return {
  -- Formatting
  {
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
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    opts = {},
  },

  -- Find & Replace
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      local grug = require('grug-far');
      grug.setup();

      vim.keymap.set('n', '<leader>F',
        function() grug.open() end,
        { desc = 'Grug: [F]ind' }
      )
      vim.keymap.set('n', '<leader>ff',
        function() grug.open({ prefills = { paths = vim.fn.expand("%") } }) end,
        { desc = "Grug: [F]ind in [F]ile" })

      vim.keymap.set('n', '<leader>sg',
        function() grug.open({ engine = 'astgrep' }) end,
        { desc = "Grug: [S]emantic [G]rep (ast-grep)" })

      vim.keymap.set('n', '<leader>fw',
        function() grug.open({ prefills = { search = vim.fn.expand("<cword>") } }) end,
        { desc = "Grug: [F]ind this [W]ord" })

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('grug-far-keymap', { clear = true }),
        pattern = { 'grug-far' },
        callback = function()
          -- jump back to search input by hitting left arrow in normal mode:
          vim.keymap.set('n', '<left>', function()
            vim.api.nvim_win_set_cursor(vim.fn.bufwinid(0), { 2, 0 })
          end, { buffer = true })

          -- open a result location and immediately close grug-far.nvim
          vim.api.nvim_buf_set_keymap(0, 'n', '<C-enter>', '<localleader>o<localleader>c', {})
        end,
      })
    end,
  },

  -- Multicursor
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local mc = require("multicursor-nvim")

      mc.setup()

      local set = vim.keymap.set

      -- Easy way to add and remove cursors using the main cursor.
      set("n", "M", mc.toggleCursor, { desc = "[M]C: Toggle cursor" })
      set({ "n", "v" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "MC: up" })
      set({ "n", "v" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "MC: down" })

      -- Add word/selection
      set({ "n", "v" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "MC: [n]ext" })

      -- bring back cursors if you accidentally clear them
      set("n", "<leader>mr", mc.restoreCursors, { desc = "[M]C: [r]estore" })

      -- Add all matches in the document
      set({ "n", "v" }, "<leader>ma", mc.matchAllAddCursors, { desc = "[M]C: [A]ll" }) -- BUG: breaks if no search and cursor on ({""}) and maybe other symbols?

      -- Rotate the main cursor.
      set({ "n", "v" }, "<left>", mc.prevCursor, { desc = "MC: previous cursor" })
      set({ "n", "v" }, "<right>", mc.nextCursor, { desc = "MC: next cursor" })

      -- Split visual selections by regex.
      set("v", "<leader>mS", mc.splitCursors, { desc = "[M]C: [S]plit" })

      -- Append/insert for each line of visual selections.
      set("v", "I", mc.insertVisual, { desc = "MC: Visual Insert" })
      set("v", "A", mc.appendVisual, { desc = "MC: Visual Append" })

      -- match new cursors within visual selections by regex.
      set("v", "M", mc.matchCursors, { desc = "MC: [M]atch by regex" })

      -- -- Select lines and rotate/circshift (disabled until needed)
      -- set("v", "<leader>mt", function() mc.transposeCursors(1) end, { desc = "[M]C: [t]ranspose forwards" })
      -- set("v", "<leader>mT", function() mc.transposeCursors(-1) end, { desc = "[M]C: [T]ranspose backwards" })

      -- Escape support
      set("n", "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          -- Default <esc> handler.
        end
      end)

      -- -- Jumplist support (disabled until needed)
      -- set({ "v", "n" }, "<c-i>", mc.jumpForward)
      -- set({ "v", "n" }, "<c-o>", mc.jumpBackward)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { link = "Cursor" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end
  },
}
