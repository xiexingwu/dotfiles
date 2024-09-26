return { -- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		vim.filetype.add({ extension = { templ = "templ" } })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				--  To jump back, press <C-T>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				--[[ local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})
				end ]]
			end,
		})

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP Specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable the following language servers
		local servers = {
			-- clangd = {},
			gopls = {},
			tsserver = {},
			templ = {},

			omnisharp = {
				cmd = { "dotnet", "/Users/xiexingwu/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
				settings = {
					FormattingOptions = {
						-- Enables support for reading code style, naming convention and analyzer
						-- settings from .editorconfig.
						EnableEditorConfigSupport = true,
						-- Specifies whether 'using' directives should be grouped and sorted during
						-- document formatting.
						OrganizeImports = nil,
					},
					MsBuild = {
						-- If true, MSBuild project system will only load projects for files that
						-- were opened in the editor. This setting is useful for big C# codebases
						-- and allows for faster initialization of code navigation features only
						-- for projects that are relevant to code that is being edited. With this
						-- setting enabled OmniSharp may load fewer projects and may thus display
						-- incomplete reference lists for symbols.
						LoadProjectsOnDemand = nil,
					},
					RoslynExtensionsOptions = {
						-- Enables support for roslyn analyzers, code fixes and rulesets.
						EnableAnalyzersSupport = nil,
						-- Enables support for showing unimported types and unimported extension
						-- methods in completion lists. When committed, the appropriate using
						-- directive will be added at the top of the current file. This option can
						-- have a negative impact on initial completion responsiveness,
						-- particularly for the first few completion sessions after opening a
						-- solution.
						EnableImportCompletion = nil,
						-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
						-- true
						AnalyzeOpenDocumentsOnly = nil,
					},
					Sdk = {
						-- Specifies whether to include preview versions of the .NET SDK when
						-- determining which version to use for project loading.
						IncludePrereleases = true,
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							-- Tells lua_ls where to find all the Lua files that you have loaded
							-- for your neovim configuration.
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
							-- If lua_ls is really slow on your computer, you can try this instead:
							-- library = { vim.env.VIMRUNTIME },
						},
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
						-- diagnostics = { disable = { 'missing-fields' } },
					},
				},
			},
		}

		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format lua code
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

-- return {
-- 	{
-- 		"VonHeikemen/lsp-zero.nvim",
-- 		branch = "v3.x",
-- 		lazy = true,
-- 		config = false,
-- 		init = function()
-- 			-- Disable automatic setup, we are doing it manually
-- 			vim.g.lsp_zero_extend_cmp = 0
-- 			vim.g.lsp_zero_extend_lspconfig = 0
-- 		end,
-- 	},
--
-- 	-- Autocompletion
-- 	{
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter",
-- 		dependencies = {
-- 			{ "L3MON4D3/LuaSnip" },
-- 		},
-- 		config = function()
-- 			-- Here is where you configure the autocompletion settings.
-- 			local lsp_zero = require("lsp-zero")
-- 			lsp_zero.extend_cmp()
--
-- 			-- And you can configure cmp even more, if you want to.
-- 			local cmp = require("cmp")
-- 			local cmp_action = lsp_zero.cmp_action()
--
-- 			cmp.setup({
-- 				sources = {
-- 					{ name = "nvim_lsp" },
-- 				},
-- 				mapping = {
-- 					["<C-y>"] = cmp.mapping.confirm({ select = false }),
-- 					["<C-e>"] = cmp.mapping.abort(),
-- 					-- ["<Up>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
-- 					-- ["<Down>"] = cmp.mapping.select_next_item({ behavior = "select" }),
-- 					["<C-p>"] = cmp.mapping(function()
-- 						if cmp.visible() then
-- 							cmp.select_prev_item({ behavior = "select" })
-- 						else
-- 							cmp.complete()
-- 						end
-- 					end),
-- 					["<C-n>"] = cmp.mapping(function()
-- 						if cmp.visible() then
-- 							cmp.select_next_item({ behavior = "select" })
-- 						else
-- 							cmp.complete()
-- 						end
-- 					end),
-- 				},
-- 				snippet = {
-- 					expand = function(args)
-- 						require("luasnip").lsp_expand(args.body)
-- 					end,
-- 				},
-- 				formatting = lsp_zero.cmp_format(),
-- 			})
-- 		end,
-- 	},
--
-- 	-- LSP
-- 	{
-- 		"neovim/nvim-lspconfig",
-- 		cmd = { "LspInfo", "LspInstall", "LspStart" },
-- 		event = { "BufReadPre", "BufNewFile" },
-- 		dependencies = {
-- 			{ "hrsh7th/cmp-nvim-lsp" },
-- 			{ "williamboman/mason-lspconfig.nvim" },
-- 			{ "williamboman/mason.nvim" },
-- 		},
-- 		config = function()
-- 			local lsp_zero = require("lsp-zero")
-- 			lsp_zero.extend_lspconfig()
--
-- 			--- if you want to know more about lsp-zero and mason.nvim
-- 			--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
-- 			lsp_zero.on_attach(function(client, bufnr)
-- 				-- see :help lsp-zero-keybindings
-- 				-- to learn the available actions
-- 				lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
-- 			end)
--
--             require("mason").setup({})
-- 			require("mason-lspconfig").setup({
-- 				ensure_installed = {},
-- 				handlers = {
-- 					lsp_zero.default_setup,
-- 					lua_ls = function()
-- 						local lua_opts = lsp_zero.nvim_lua_ls()
-- 						require("lspconfig").lua_ls.setup(lua_opts)
-- 					end,
-- 				},
-- 			})
--
-- 			-- -- Swift sourcekit-lsp
-- 			-- require("lspconfig").sourcekit.setup({})
-- 			--
-- 			-- -- Go templ
-- 			-- require("lspconfig").templ.setup({})
--
-- 			-- Use LspAttach autocommand to only map the following keys
-- 			-- after the language server attaches to the current buffer
-- 			vim.api.nvim_create_autocmd("LspAttach", {
-- 				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- 				callback = function(ev)
-- 					-- Enable completion triggered by <c-x><c-o>
-- 					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
--
-- 					-- Buffer local mappings -- commented since lsp-zero should define them
-- 					local telescope = require("telescope.builtin")
-- 					local opts = { buffer = ev.buf }
-- 					vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
-- 					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
-- 					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
-- 					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
-- 					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- 					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
-- 					vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
-- 					vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
-- 					vim.keymap.set("n", "<space>wl", function()
-- 						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 					end, opts)
-- 					vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
-- 					vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
-- 					vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
-- 				end,
-- 			})
-- 		end,
-- 	},
-- }
