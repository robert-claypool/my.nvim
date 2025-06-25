return {
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    priority = 1000,
    config = function()
      require("flexoki").setup({
        variant = "auto", -- auto, moon (dark), or dawn (light)
        dim_inactive = false,
        transparent = false,
        callbacks = {
          on_change = function(variant, colors)
            -- Update lualine theme when colorscheme changes
            local lualine_ok, lualine = pcall(require, "lualine")
            if lualine_ok then
              lualine.setup({
                options = {
                  theme = "flexoki"
                }
              })
            end
          end,
        },
      })
      
      -- Set the colorscheme
      vim.cmd("colorscheme flexoki")
    end,
  },
  
  -- Add keymaps for switching between light and dark
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local wk = require("which-key")
      wk.add({
        { "<leader>t", group = "[T]heme" },
        { "<leader>td", function() 
          require("flexoki").setup({ variant = "moon" })
          vim.cmd("colorscheme flexoki")
        end, desc = "Flexoki [D]ark" },
        { "<leader>tl", function() 
          require("flexoki").setup({ variant = "dawn" })
          vim.cmd("colorscheme flexoki")
        end, desc = "Flexoki [L]ight" },
        { "<leader>ta", function() 
          require("flexoki").setup({ variant = "auto" })
          vim.cmd("colorscheme flexoki")
        end, desc = "Flexoki [A]uto" },
      })
      return opts
    end,
  },
}