return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup()

    local set = vim.keymap.set

    -- Easy way to add and remove cursors using the main cursor.
    set("n", "M", mc.toggleCursor, { desc = "[M]C: Toggle cursor" })
    set({ "n", "v" }, "<up>", function() mc.lineAddCursor(-1) end, { desc = "MC: up"})
    set({ "n", "v" }, "<down>", function() mc.lineAddCursor(1) end, { desc = "MC: down"})

    -- Add word/selection
    set({ "n", "v" }, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "MC: [n]ext" })

    -- bring back cursors if you accidentally clear them
    set("n", "<leader>mr", mc.restoreCursors, { desc = "[M]C: [r]estore" })

    -- Add all matches in the document
    set({ "n", "v" }, "<leader>ma", mc.matchAllAddCursors, { desc = "[M]C: [A]ll" }) -- BUG: breaks if no search and cursor on ({""}) and maybe other symbols?

    -- Rotate the main cursor.
    set({ "n", "v" }, "<left>", mc.prevCursor, { desc = "MC: previous cursor"})
    set({ "n", "v" }, "<right>", mc.nextCursor, { desc = "MC: next cursor"})

    -- Split visual selections by regex.
    set("v", "<leader>mS", mc.splitCursors, { desc = "[M]C: [S]plit" })

    -- Append/insert for each line of visual selections.
    set("v", "I", mc.insertVisual, { desc = "MC: Visual Insert"})
    set("v", "A", mc.appendVisual, { desc = "MC: Visual Append"})

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
}
