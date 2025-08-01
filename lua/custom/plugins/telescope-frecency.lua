return {
  "nvim-telescope/telescope-frecency.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope").load_extension("frecency")
  end,
  keys = {
    { "<leader>ff", "<cmd>Telescope frecency<cr>", desc = "Find files (frecency)" },
  },
}