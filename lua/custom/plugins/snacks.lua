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
    -- Dashboard for quick project access (manually triggered only)
    dashboard = {
      enabled = false, -- Disabled on startup, use <leader><leader> to open
      preset = {
        keys = {
          { key = "g", desc = "Grep", action = ":Telescope live_grep" },
          { key = "q", desc = "Quit", action = ":enew" },
        },
      },
      sections = {
        { section = "header" },
        { 
          section = "projects", 
          title = "Recent Projects",
          limit = 8,
          indent = 2,
        },
        { section = "keys" },
        { 
          section = "recent_files", 
          title = "Recent Files", 
          limit = 45,
          indent = 2,
          keys = false,  -- Disable automatic keybindings
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