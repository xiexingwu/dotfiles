-- Parsers only; highlighting is started per filetype below (nvim-treesitter main has no `highlight.enable`)
local parsers = { "googlesql", "jinja", "jinja_inline" }

-- BigQuery dialect (own grammar, not in nvim-treesitter's registry)
local googlesql = {
  url = "https://github.com/xiexingwu/tree-sitter-googlesql",
  queries = "queries/googlesql",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main branch does not support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Must exist before install(): nvim-treesitter fires `User TSUpdate` when it loads its parser list
    vim.api.nvim_create_autocmd("User", {
      group = vim.api.nvim_create_augroup("treesitter-parsers", { clear = true }),
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").googlesql = { install_info = googlesql }
      end,
    })
    require("nvim-treesitter").install(parsers)

    vim.treesitter.language.register("googlesql", "sql")
    -- dbt models are Jinja templates; after/queries/jinja/injections.scm injects googlesql into the text between tags
    vim.treesitter.language.register("jinja", "dbt")

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      pattern = { "sql", "dbt", "jinja" },
      callback = function(args)
        -- pcall: parser may still be installing on first run; regex syntax (e.g. syntax/dbt.vim) stays as fallback
        pcall(vim.treesitter.start, args.buf)
        vim.bo[args.buf].commentstring = args.match == "jinja" and "{# %s #}" or "-- %s"
      end,
    })
  end,
}
