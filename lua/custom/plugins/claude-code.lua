return {
  "coder/claudecode.nvim",
  config = function()
    require("claudecode").setup({
      -- Port range for WebSocket server
      port_range = { min = 27000, max = 27100 },  -- Distinctive range for Claude Code
      auto_start = true,
      log_level = "info",
      
      -- Terminal settings (for Claude Code process)
      terminal = {
        split_side = "right",
        split_width_percentage = 0.5,  -- Match your current 50% split
        provider = "auto",
      },
      
      -- Diff view settings
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
      },
      
      -- Keymaps
      keymaps = {
        toggle = "<leader>cc",        -- Match your current toggle key
        send_selection = "<leader>cs", -- Send visual selection to Claude
        accept_diff = "y",            -- Accept diff changes
        reject_diff = "n",            -- Reject diff changes
      },
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>cs", mode = "v", "<cmd>ClaudeCodeSend<cr>", desc = "Send selection to Claude" },
    { "<leader>cC", "<cmd>ClaudeCodeContinue<cr>", desc = "Continue Claude conversation" },
  }
}