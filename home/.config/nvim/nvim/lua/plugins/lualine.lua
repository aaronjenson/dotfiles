local function buf_count()
	local count = 0
	for i, b in pairs(vim.api.nvim_list_bufs()) do
    local safe, mod = pcall(vim.api.nvim_get_option_value, "modified", { buf = b })
		if safe and mod then
			count = count + 1
		end
	end
  return "b+" .. count
end

return {
	"nvim-lualine/lualine.nvim",
	requires = {
		"nvim-tree/nvim-web-devicons",
		opt = true,
	},
	config = function()
		require("lualine").setup({
			options = {
				theme = "dracula",
        globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					"filename",
					buf_count,
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "location" },
				lualine_z = { "%p%%/%L" },
			},
		})
	end,
}
