return {
  dir = "~/git/claude-code.nvim", -- Use local directory instead of GitHub
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      -- Terminal window settings
      window = {
        split_ratio = 0.5,           -- 60% of screen for the terminal window
        position = "vsplit",         -- Position of the window: "botright", "topleft", "vertical", "vsplit", etc.
        enter_insert = false,        -- Don't automatically enter INSERT mode
        start_in_normal_mode = true, -- Start in NORMAL mode (not INSERT)
        hide_numbers = true,         -- Hide line numbers in terminal
        hide_signcolumn = true,      -- Hide sign column in terminal
      },
      -- File refresh settings
      refresh = {
        enable = true,             -- Enable file change detection
        updatetime = 100,          -- updatetime when Claude Code is active
        timer_interval = 500,      -- Check for file changes every half-second
        show_notifications = true, -- Show notification when files are reloaded
      },
      -- Git project settings
      git = {
        use_git_root = true,     -- Set CWD to git root when opening Claude Code
      },
      -- Command settings
      command = "claude",        -- Command to launch Claude Code
      -- Command variants
      command_variants = {
        continue = "--continue", -- Resume most recent conversation
        resume = "--resume",     -- Display conversation picker
        verbose = "--verbose",   -- Enable verbose logging
      },
      -- Keymaps
      keymaps = {
        toggle = {
          normal = "<leader>cc",     -- Space+cc to toggle Claude Code
          terminal = "<C-,>",        -- Ctrl+, in terminal mode
          variants = {
            continue = "<leader>cC", -- Continue conversation
            verbose = "<leader>cV",  -- Verbose mode
          },
        },
        window_navigation = true, -- Enable C-h/j/k/l for window navigation
        scrolling = true,         -- Enable C-f/b for scrolling
      }
    })
  end
}
