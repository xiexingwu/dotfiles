return {
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
}
