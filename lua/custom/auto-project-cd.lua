-- Automatically change to project directory when opening files
-- This ensures telescope buffer search works correctly

local M = {}

function M.setup()
  -- Create autocommand that triggers when we open a file
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*",
    callback = function(args)
      -- Skip special buffers
      local buftype = vim.bo[args.buf].buftype
      if buftype ~= "" then
        return
      end
      
      -- Skip if we're already in a project directory
      local current_dir = vim.fn.getcwd()
      local file_dir = vim.fn.fnamemodify(args.file, ":p:h")
      
      -- Use project.nvim to find the project root
      local ok, project = pcall(require, "project_nvim.project")
      if ok then
        -- Get the project root for this file
        local root = project.get_project_root(args.file)
        if root and root ~= current_dir then
          -- Change to the project root
          vim.schedule(function()
            vim.cmd.cd(root)
            -- Silent notification so it doesn't spam
            vim.notify("Changed to project: " .. vim.fn.fnamemodify(root, ":t"), vim.log.levels.INFO, { timeout = 1000 })
          end)
        end
      end
    end,
    desc = "Auto-change to project directory"
  })
end

return M