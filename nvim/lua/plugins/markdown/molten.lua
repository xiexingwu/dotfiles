MarkdownMode = function()
  return vim.g.started_by_firenvim or vim.env["MD_MODE"] == "1"
end
-- Provide a command to create a blank new Python notebook
-- note: the metadata is needed for Jupytext to understand how to parse the notebook.
-- if you use another language than Python, you should change it in the template.
local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
      "file_extension": ".py",
      "mimetype": "text/x-python",
      "name": "python",
      "nbconvert_exporter": "python",
      "pygments_lexer": "ipython3"
     }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]

function new_notebook()
  vim.ui.input(
    { prompt = "Enter new name for notebook (without extension)" },
    function(new_name)
      if new_name ~= nil and new_name ~= "" then
        local path = new_name .. ".ipynb"
        local file = io.open(path, "w")
        if file then
          file:write(default_notebook)
          file:close()
          vim.cmd("edit " .. path)
        else
          print("Error: Could not open new notebook file for writing.")
        end
      else
        return
      end
    end)
end

-- this is the file for repl like functionality in code
-- quarto.nvim is kinda related, as it lets me edit jupyter notebook type files, but that has it's
-- own config file
return {
  {
    "benlubas/molten-nvim",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "3rd/image.nvim",
      "jmbuhr/otter.nvim",
    },
    ft = { "python", "markdown", "quarto" }, -- this is just to avoid loading image.nvim, loading molten at the start has minimal startup time impact
    init = function()
      vim.g.molten_auto_open_output = true

      vim.g.molten_output_win_max_height = 12
      vim.g.molten_output_show_more = true
      vim.g.molten_wrap_output = true
      vim.g.molten_output_win_border = { "", "━", "", "" }
      vim.g.molten_use_border_highlights = true

      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true

      vim.g.molten_image_location = "both" -- "float" | "virt" | "both"
      vim.g.molten_image_provider = "image.nvim"

      vim.g.molten_tick_rate = 142

      ---ExCommand for new notebook
      vim.api.nvim_create_user_command('MoltenNewNotebook', function()
        new_notebook()
      end, {
        nargs = 0,
      })

      ---Post Init
      vim.api.nvim_create_autocmd("User", {
        pattern = "MoltenInitPost",
        callback = function()
          -- autoactivate otter
          require('otter').activate()

          local r = require("quarto.runner")
          -- Run key maps
          vim.keymap.set("n", "<localleader>R", r.run_all, { desc = "[R]un all" })
          -- vim.keymap.set("n", "<localleader>R", function() r.run_all(true) end, { desc = "[R]un all" })
          vim.keymap.set("n", "<C-CR>", function()
            r.run_cell(); vim.cmd(":MoltenNext")
          end, { desc = "Run cell and go to next cell" })
          vim.keymap.set("n", "<S-CR>", r.run_cell, { desc = "Run cell" })
          -- vim.keymap.set("n", "<S-CR>", r.run_line, { desc = "Run line" })
          vim.keymap.set("n", "<localleader>ra", r.run_below, { desc = "[r]un [a]fter (incl)" })
          vim.keymap.set("n", "<localleader>ru", r.run_above, { desc = "[r]un [u]pto (incl)" })
          vim.keymap.set("n", "<localleader>!", ":MoltenRestart!<CR>", { desc = "[!]Restart Kernel" })

          -- Navigation key maps
          vim.keymap.set("n", "<localleader>n", new_notebook, { desc = "[n]ew notebook" })

          vim.keymap.set("n", "<localleader>g", ":MoltenGoto<CR>", { desc = "Molten: Goto", silent = true })
          vim.keymap.set("n", "<localleader>j", ":MoltenNext<CR>", { desc = "Molten: Next", silent = true })
          vim.keymap.set("n", "<localleader>k", ":MoltenPrev<CR>", { desc = "Molten: Prev", silent = true })

          vim.keymap.set("n", "<localleader>E", ":MoltenExportOutput ", { desc = "[E]xport" })
          vim.keymap.set("n", "<localleader>I", ":MoltenImportOutput<CR>", { desc = "[I]mport" })

          vim.keymap.set("n", "<localleader>K", ":noautocmd MoltenEnterOutput<CR>:noautocmd MoltenEnterOutput<CR>",
            { desc = "Molten: Output - Show", silent = true }) -- twice to enter the output window
          vim.keymap.set("n", "<localleader>q", ":MoltenHideOutput<CR>", { desc = "Molten: Output - [q]uit", silent = true })
          vim.keymap.set("n", "<localleader>x", ":MoltenDelete<CR>", { desc = "Molten: [x] delete cell", silent = true })

          -- -- if we're in a python file, change the configuration a little
          -- if vim.bo.filetype == "python" then
          --   vim.fn.MoltenUpdateOption("molten_virt_lines_off_by_1", false)
          --   vim.fn.MoltenUpdateOption("molten_virt_text_output", false)
          -- end
        end,
      })

      -- auto import output chunks from a jupyter notebook
      local imb = function(e)
        vim.schedule(function()
          local kernels = vim.fn.MoltenAvailableKernels()

          local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            return metadata.kernelspec.name
          end
          local ok, kernel_name = pcall(try_kernel_name)

          if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv("VIRTUAL_ENV")
            if venv ~= nil then
              kernel_name = string.match(venv, "/.+/(.+)")
            end
          end

          if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
          end
          vim.cmd("MoltenImportOutput")
        end)
      end

      -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = { "*.ipynb" },
        callback = function(e)
          if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            imb(e)
          end
        end,
      })

      -- automatically import output chunks from a jupyter notebook
      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = { "*.ipynb" },
        callback = imb,
      })

      -- automatically export output chunks to a jupyter notebook
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.ipynb" },
        callback = function()
          if require("molten.status").initialized() == "Molten" then
            vim.cmd(":MoltenExportOutput!")
          end
        end,
      })
    end,
  },
  {
    "3rd/image.nvim",
    -- "benlubas/image.nvim",
    -- dev = true,
    -- enabled = false,
    cond = not MarkdownMode(),
    dependencies = { "https://github.com/leafo/magick" },
    ft = { "markdown", "norg" },
    config = function()
      local image = require("image")

      ---@diagnostic disable-next-line: missing-fields
      image.setup({
        backend = "kitty",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "quarto" }, -- markdown extensions (ie. quarto) can go here
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = false,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },
          typst = {
            enabled = true,
            filetypes = { "typst" },
          },
        },
        max_width = 100,
        max_height = 12,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,    -- toggles images when windows are overlapped
        editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "fidget", "" },
      })
    end,
  },
  { "3rd/diagram.nvim", dependencies = { "image.nvim" }, enabled = false, opts = {} },
}
