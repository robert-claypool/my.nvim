return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gdiffsplit", "Gwrite", "Gread", "GBrowse" },
  config = function()
    -- Set up some convenient keymaps for Git operations
    vim.keymap.set("n", "<leader>gg", "<cmd>G<cr>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<cr>", { desc = "Git diff split" })
    vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "Git write (stage)" })
    vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<cr>", { desc = "Git commit" })
    vim.keymap.set("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })
    vim.keymap.set("n", "<leader>gl", "<cmd>Git pull<cr>", { desc = "Git pull" })
    vim.keymap.set("n", "<leader>gb", "<cmd>GBrowse<cr>", { desc = "Git browse (open on GitHub)" })
    
    -- In visual mode, browse the selected lines
    vim.keymap.set("v", "<leader>gb", ":'<,'>GBrowse<cr>", { desc = "Git browse selection" })
  end,
}