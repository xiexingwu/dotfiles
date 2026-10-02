vim.filetype.add({
  extension = {
    marko = 'marko', -- missing Treesitter grammar for marko but there's github linguist: https://github.com/marko-js/marko-tmbundle
  },
  pattern = {
    ['Brewfile.*'] = 'Brewfile',
    -- dbt: SQL + Jinja inside a dbt project (models, macros, tests, ...)
    ['.*%.sql'] = {
      function(path)
        if vim.fs.root(path, 'dbt_project.yml') then return 'dbt' end
      end,
      { priority = 10 },
    },
  },
})

-- Ghostty scrollback history
vim.filetype.add({
  pattern = {
    -- [os.getenv('TMPDIR') .. '.*/history.txt'] = function(path, bufnr, ext)  -- not matching for some reason?
    [".*/history.txt"] = function(path, bufnr, ext)
      return 'scrollback'
    end,
    [".*/screen.txt"] = function(path, bufnr, ext)
      return 'scrollback'
    end,
  }
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup('scrollback', {}),
  pattern = 'scrollback',
  callback = function()
    vim.cmd("norm G")
  end,
})
