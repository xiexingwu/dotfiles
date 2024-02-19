local on_attach = function(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	local function edit_or_open()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		else
			-- open file
			api.node.open.edit()
			-- Close the tree if file was opened
			api.tree.close()
		end
	end

	-- open folder only - not files
	local function open_folder()
		local node = api.tree.get_node_under_cursor()

		if node.nodes ~= nil then
			-- expand or collapse folder
			api.node.open.edit()
		end
	end

	-- open as vsplit on current node
	local function vsplit_preview()
		local node = api.tree.get_node_under_cursor()

		if node.nodes == nil then
			-- open file as vsplit
			api.node.open.vertical()
		end

		-- Finally refocus on tree if it was lost
		api.tree.focus()
	end
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
	vim.keymap.set("n", "<CR>", edit_or_open, opts("Edit Or Open")) -- better return
	vim.keymap.set("n", "l", open_folder, opts("Edit Or Open"))
	vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
	vim.keymap.set("n", "h", api.tree.close, opts("Close"))
	vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
end

local function natural_cmp(left, right)
	left = left.name:lower()
	right = right.name:lower()

	if left == right then
		return false
	end

	for i = 1, math.max(string.len(left), string.len(right)), 1 do
		local l = string.sub(left, i, -1)
		local r = string.sub(right, i, -1)

		if type(tonumber(string.sub(l, 1, 1))) == "number" and type(tonumber(string.sub(r, 1, 1))) == "number" then
			local l_number = tonumber(string.match(l, "^[0-9]+"))
			local r_number = tonumber(string.match(r, "^[0-9]+"))

			if l_number ~= r_number then
				return l_number < r_number
			end
		elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
			return l < r
		end
	end
end

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = true,
    event = "UIEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("nvim-tree").setup({
			sync_root_with_cwd = true,
			on_attach = on_attach,
			live_filter = {
				prefix = "[FILTER]: ",
				always_show_folders = false, -- Turn into false from true by default
			},
			sort = {
				--[[ sorter = function(nodes)
					table.sort(nodes, natural_cmp) -- overrides folders_first
				end, ]]
				folders_first = true,
			},
		})

		-- global mappings
		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<leader>e", function()
			api.tree.open({ current_window = false, find_file = false })
		end, {})
	end,
}
