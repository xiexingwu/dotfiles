return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  config = function()
    local dropbar_api = require('dropbar.api')
    vim.keymap.set('n', '<Leader>pc', dropbar_api.pick, { desc = 'Dropbar: [P]ick [C]ontext' })
    vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
    vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
  end
}
