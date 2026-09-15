return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  opts = {
    open_files_do_not_replace_types = { "terminal" },
    filesystem = {
      filtered_items = {
        hide_gitignored = false,
      },
    },
  },
  init = function()
    vim.keymap.set('n', '<leader>fs', ':Neotree filesystem reveal toggle left<CR>', { desc = "Toggle [F]ile[S]ystem visibility" })
    vim.keymap.set('n', '<leader>gs', ':Neotree focus git_status float<CR>', { desc = "Show [G]it [S]tatus" })
  end
}
