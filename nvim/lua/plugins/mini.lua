return {
  'nvim-mini/mini.nvim',
  version = false,
  config = function()
    -- Around/Inside
    require("mini.ai").setup() -- af a<Space>, a? etc.

    -- Align
    require("mini.align").setup({
      mappings = { start = "", start_with_preview = "ga" },
      modifiers = {
        ['d'] = function(steps, _)
          table.insert(
            steps.pre_justify,
            MiniAlign.new_step("remove delimiter", function(parts, opts)
              parts.apply_inplace(function(s, data)
                if data.col % 2 == 0 and s == opts.split_pattern then
                  return ''
                else
                  return s
                end
              end)
            end)
          )
        end
      },
    })

    -- Comment
    require("mini.comment").setup()

    -- Completion
    vim.opt.completeopt = 'menuone,noselect,fuzzy,nosort,popup'
    vim.opt.complete = '' -- disable fallback
    local on_attach = function(args)
      vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
    vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })
    require("mini.completion").setup({
      lsp_completion = { source_func = 'omnifunc', auto_setup = false },
      fallback_action = '',               -- disable fallback
      mappings = { force_fallback = '' }, -- disable fallback
    })

    -- Keymap
    local keymap = require("mini.keymap")
    keymap.map_combo({ 'n', 'i', 'x', 'c' }, '<Esc><Esc>', function() vim.cmd('nohlsearch') end)

    -- Move
    require("mini.move").setup({
      mappings = {
        left = "H",
        down = "J",
        up = "K",
        right = "L",

        line_left = "",
        line_down = "",
        line_up = "",
        line_right = "",
      },
    })

    -- Pairs
    require("mini.pairs").setup()

    -- Surround
    require("mini.surround").setup({
      mappings = {
        find = "",
        find_left = "",
        highlight = "",
      }
    })

    -- cmdline
    require("mini.cmdline").setup({
      autocomplete = {
        delay = 500,
      }
    })

    -- highlight cursor word
    require("mini.cursorword").setup()

    -- Icons
    require("mini.icons").setup()

    -- lualine
    require("mini.statusline").setup({
      use_icons = true
    })
  end
}
