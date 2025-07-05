return {
  "jpalardy/vim-slime",
  config = function()
    -- Configure vim-slime to use Neovim's terminal
    vim.g.slime_target = "neovim"
    
    -- Don't ask for terminal job id every time
    vim.g.slime_dont_ask_default = 1
    
    -- Default to terminal in split window
    vim.g.slime_default_config = {
      socket_name = "default",
      target_pane = "{last}"
    }
    
    -- Use <C-c><C-c> to send current paragraph/selection
    -- Use <C-c>v to configure which terminal to send to
    
    -- Additional helpful mappings
    vim.keymap.set("n", "<leader>sl", "<Plug>SlimeParagraphSend", { desc = "Send paragraph to terminal" })
    vim.keymap.set("v", "<leader>sl", "<Plug>SlimeRegionSend", { desc = "Send selection to terminal" })
    vim.keymap.set("n", "<leader>sc", "<Plug>SlimeConfig", { desc = "Configure Slime target" })
    
    -- Send current line with <leader>ss (different from screenshot)
    vim.keymap.set("n", "<leader>sL", function()
      vim.cmd("normal V")
      vim.cmd("normal <Plug>SlimeRegionSend")
    end, { desc = "Send current line to terminal" })
  end,
}