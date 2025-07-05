return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enhanced notifications that don't block your view
    notifier = { 
      enabled = true,
      timeout = 3000,
      style = "compact",
    },
    -- Smart buffer deletion that preserves window layouts
    bufdelete = { enabled = true },
    -- Never enable smooth scrolling - makes cursor movement very slow
    scroll = { 
      enabled = false,
    },
    -- Dashboard for quick project access on startup
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "p", desc = "Open Project", action = ":Oil ~/git" },
          { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope frecency" },
          { icon = " ", key = "h", desc = "Harpoon Files", action = ":Telescope harpoon marks" },
          { icon = " ", key = "n", desc = "New Buffer", action = ":enew" },
          { icon = "󰊢 ", key = "c", desc = "Config", action = ":e ~/.config/nvim/init.lua" },
          { icon = " ", key = "q", desc = "Close Dashboard", action = ":enew" },
        },
      },
    },
  },
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer (Smart)" },
    { "<leader>z", function() Snacks.zen() end, desc = "Zen Mode" },
    { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
    { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
  },
}