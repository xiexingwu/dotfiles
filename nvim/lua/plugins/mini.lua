local g_clues = {
  { mode = 'n', keys = 'gc', desc = '+[C]omment' },
  { mode = 'n', keys = 'gf', desc = 'Go to [F]ile (Cursor)' },
  { mode = 'n', keys = 'gi', desc = 'Go last [I]nsert' },
  { mode = 'n', keys = 'gj', desc = "Screenline [J]",         postkeys = "g" },
  { mode = 'n', keys = 'gk', desc = "Screenline [K]",         postkeys = "g" },
  { mode = 'n', keys = 'gU', desc = "[U]ppercase" },
  { mode = 'n', keys = 'gu', desc = "Lowercase" },
  { mode = 'n', keys = 'gv', desc = "Last [V]isual" },
  { mode = 'n', keys = 'gx', desc = 'E[X]ecute file (Cursor)' },
  { mode = 'n', keys = 'g;', desc = "Change List (older)",    postkeys = "g" },
  { mode = 'n', keys = 'g,', desc = "Change List (newer)",    postkeys = "g" },

  { mode = 'n', keys = 'gp', desc = "+Set [P]in (Smart Motion)" },
  { mode = 'n', keys = 'gP', desc = "+Set [P]in Global (Smart Motion)" },
}

local z_clues = {
  { mode = 'n', keys = 'za', desc = 'Toggle fold' },
  { mode = 'n', keys = 'zh', desc = "Screen Scroll [H]",             postkeys = "z" },
  { mode = 'n', keys = 'zl', desc = "Screen Scroll [L]",             postkeys = "z" },
  { mode = 'n', keys = 'zj', desc = 'Fold jump [J]',                 postkeys = "z" },
  { mode = 'n', keys = 'zk', desc = 'Fold jump [K]',                 postkeys = "z" },
  { mode = 'n', keys = 'zN', desc = "Fold [N]one (set foldenable)" },
  { mode = 'n', keys = 'zn', desc = "Fold [N]one (reset foldenable)" },

  { mode = 'x', keys = 'zf', desc = '[F]old selection' },
}

local win_clues = {
  { mode = 'n', keys = '<C-W>+',  desc = 'Split height +',             postkeys = "<C-W>" },
  { mode = 'n', keys = '<C-W>-',  desc = 'Split height -',             postkeys = "<C-W>" },
  { mode = 'n', keys = '<C-W><',  desc = 'Split width -',              postkeys = "<C-W>" },
  { mode = 'n', keys = '<C-W>>',  desc = 'Split width +',              postkeys = "<C-W>" },
  { mode = 'n', keys = '<C-W>=',  desc = 'Balance windows' },
  { mode = 'n', keys = '<C-w>_',  desc = 'Hide _ split (full height)' },
  { mode = 'n', keys = '<C-w>|',  desc = 'Hide | split (full width)' },
  { mode = 'n', keys = '<C-w>f',  desc = 'Split [F]ile' },
  { mode = 'n', keys = '<C-w>d',  desc = 'Split [D]efinition' },
  { mode = 'n', keys = '<C-w>o',  desc = 'Split [O]nly (close others)' },
  { mode = 'n', keys = '<C-w>v',  desc = 'Split [V]ertical' },
  { mode = 'n', keys = '<C-w>s',  desc = '[S]plit Horizontal' },

  { mode = 'n', keys = '<C-w>g',  desc = '+Tab' },
  { mode = 'n', keys = '<C-w>gf', desc = 'Tabedit [F]ile' },
}


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
      n_lines = 100,
      mappings = {
        find = "",
        find_left = "",
        highlight = "",
      }
    })

    -- clue
    local miniclue = require('mini.clue')
    miniclue.setup({
      window = {
        delay = 200,
        config = { width = 50 }
      },
      triggers = {
        { mode = { 'n', 'x' }, keys = '<Leader>' },

        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = 'z' },

        { mode = 'n',          keys = '<C-w>' },
      },

      clues = {
        { mode = 'n', keys = '<Leader>b',  desc = "+Buffer" },
        { mode = 'n', keys = '<Leader>g',  desc = "+Git" },
        { mode = 'n', keys = '<Leader>h',  desc = "+Help" },
        { mode = 'n', keys = '<Leader>m',  desc = "+Marks (Haunt)" },
        { mode = 'n', keys = '<Leader>p',  desc = "+Picker" },
        { mode = 'n', keys = '<Leader>s',  desc = "+Search" },
        { mode = 'n', keys = '<Leader>t',  desc = "+Toggle" },
        { mode = 'n', keys = '<Leader>z',  desc = "+ZK" },

        miniclue.gen_clues.registers(),
        g_clues,
        z_clues,

        win_clues,
      },
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
