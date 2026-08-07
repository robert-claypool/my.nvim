local kind_icons = require('my.icons').kinds

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enhanced notifications that don't block your view
    notifier = { 
      enabled = true,
      timeout = 12000,
      style = "compact",
      icons = {
        error = 'E ',
        warn = 'W ',
        info = 'I ',
        debug = 'D ',
        trace = 'T ',
      },
    },
    -- Smart buffer deletion that preserves window layouts
    bufdelete = { enabled = true },
    -- Primary picker layer for files/grep/help/LSP navigation
    picker = {
      enabled = true,
      ui_select = true,
      formatters = {
        severity = { icons = false, level = true },
      },
      icons = {
        files = { enabled = false },
        git = { enabled = false, commit = '@ ' },
        keymaps = { nowait = '! ' },
        undo = { saved = 'S ' },
        ui = { live = 'L ', selected = '* ', unselected = '  ' },
        diagnostics = { Error = 'E ', Warn = 'W ', Hint = 'H ', Info = 'I ' },
        lsp = { unavailable = 'x ', enabled = '+ ', disabled = '- ', attached = '* ' },
        kinds = kind_icons,
      },
    },
    -- Never enable smooth scrolling - makes cursor movement very slow
    scroll = { 
      enabled = false,
    },
    -- Dashboard for quick project access (manually triggered only)
    dashboard = {
      enabled = false, -- Disabled on startup, use <leader><leader> to open
      preset = {
        keys = {
          { key = "g", desc = "Grep", action = function() Snacks.picker.grep() end },
          { key = "q", desc = "Close Dashboard", action = function() vim.cmd('bdelete') end },
          { key = "<Esc>", desc = "Close Dashboard", action = function() vim.cmd('bdelete') end },
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
