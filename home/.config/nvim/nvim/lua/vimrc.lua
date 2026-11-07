vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.showmode = false

vim.opt.splitright = true

vim.opt.cursorline = true

vim.opt.scrolloff = 5

vim.opt.mousescroll = "ver:2,hor:2"


vim.o.foldmethod = 'expr'
-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
-- Don't fold everything when opening a file
vim.opt.foldlevel = 99

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local state = {
	term = {
		buf = -1,
		win = -1,
	},
  claude = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
    zindex = 40,
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local function toggle_term()
	if not vim.api.nvim_win_is_valid(state.term.win) then
		state.term = create_floating_window({ buf = state.term.buf })
		if vim.bo[state.term.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
			vim.keymap.set("n", "<ESC>", toggle_term, { buffer = state.term.buf })
		end
	else
		vim.api.nvim_win_hide(state.term.win)
	end
end

vim.keymap.set("n", "<leader>tt", toggle_term, { desc = "[T]oggle floating [T]erminal" })

local function toggle_claude()
	if not vim.api.nvim_win_is_valid(state.claude.win) then
		state.claude = create_floating_window({ buf = state.claude.buf })
		if vim.bo[state.claude.buf].buftype ~= "terminal" then
			vim.cmd.terminal("claude")
		end
    vim.cmd.startinsert()
	else
		vim.api.nvim_win_hide(state.claude.win)
	end
end

vim.keymap.set("n", "<leader>cc", toggle_claude, { desc = "[T]oggle floating [C]laude" })

vim.api.nvim_create_autocmd("TermClose", {
  desc = "Auto-close Claude terminals on exit",
  pattern = {"term://*claude"},
  callback = function(ev)
    vim.api.nvim_input("<CR>")
  end
})

-- Avoiding this keymap because Esc gets used a lot for lazygit, claude, etc.
-- vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  init_options = {
    provideFormatter = true
  }
})
vim.lsp.enable('jsonls')
