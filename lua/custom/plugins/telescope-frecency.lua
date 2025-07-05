return {
  "nvim-telescope/telescope-frecency.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope").load_extension("frecency")
    
    -- Configure frecency with your frequently used workspaces
    require("telescope").setup({
      extensions = {
        frecency = {
          default_workspace = "CWD",
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*.cache/*", "node_modules/*" },
          -- Define your 6 main workspaces
          workspaces = {
            ["nvim"] = vim.fn.expand("~/.config/nvim"),
            ["dotfiles"] = vim.fn.expand("~/dotfiles"),
            ["redacta"] = vim.fn.expand("~/git/redacta"),
            ["claude"] = vim.fn.expand("~/git/claude"),
            ["start"] = vim.fn.expand("~/git/start"),
            ["prompts"] = vim.fn.expand("~/git/prompts"),
            ["screenshots"] = vim.fn.expand("~/screenshots"),
          },
        },
      },
    })
  end,
  keys = {
    { "<leader>ff", "<cmd>Telescope frecency<cr>", desc = "Find files (frecency)" },
    { "<leader>fw", "<cmd>Telescope frecency workspace=CWD<cr>", desc = "Find files in CWD" },
    { "<leader>fn", "<cmd>Telescope frecency workspace=nvim<cr>", desc = "Find in nvim config" },
    { "<leader>fd", "<cmd>Telescope frecency workspace=dotfiles<cr>", desc = "Find in dotfiles" },
  },
}