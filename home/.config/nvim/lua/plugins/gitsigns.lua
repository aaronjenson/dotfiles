return {
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup{
        on_attach = function(bufnr)
          local gitsigns = require('gitsigns')

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', '<leader>ga', gitsigns.stage_hunk)
          map('n', '<leader>gr', gitsigns.reset_hunk)
          -- map('v', '<leader>gs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('v', '<leader>gr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
          map('n', '<leader>gA', gitsigns.stage_buffer)
          -- map('n', '<leader>gu', gitsigns.undo_stage_hunk)
          -- map('n', '<leader>gR', gitsigns.reset_buffer)
          map('n', '<leader>gp', gitsigns.preview_hunk)
          -- map('n', '<leader>gb', function() gitsigns.blame_line{full=true} end)
          map('n', '<leader>gb', gitsigns.toggle_current_line_blame)
          map('n', '<leader>gd', gitsigns.diffthis)
          -- map('n', '<leader>gD', function() gitsigns.diffthis('~') end)
          -- map('n', '<leader>gd', gitsigns.toggle_deleted)
        end
      }
    end,
  }
}
