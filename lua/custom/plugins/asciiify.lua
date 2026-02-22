-- asciiify.lua ---------------------------------------------------------------
-- Convert "smart" typography to plain ASCII.
--
--  • " " → "
--  • ‘ ’ → '
--  • – — → -
--  • …   → ...
--
-- Key-maps
--   <leader>tqi – interactive (y/n/a/q per class)
--   <leader>tqa – ask once, then replace all silently
--
-- Commands
--   :Asciiify        – interactive
--   :Asciiify!       – replace all silently
-------------------------------------------------------------------------------

---@alias SubPair { [1]:string, [2]:string }

local subs ---@type SubPair[]
subs = {
  { '[""]', '"'  },   -- curly double quotes (U+201C / U+201D)
  { '[‘’]', "'"  },   -- curly single quotes (U+2018 / U+2019)
  { '[–—]', '-'  },   -- en / em dash      (U+2013 / U+2014)
  { '…',    '...' },  -- ellipsis          (U+2026)
}

---Run the substitutions on the current buffer.
---@param confirm boolean  if true, use |c| flag for per-match prompts
local function asciiify(confirm)
  -- g = global, c = confirm, e = do not error when pattern not found
  local flag = confirm and 'gce' or 'ge'
  for _, pair in ipairs(subs) do
    vim.cmd(('keepjumps keeppatterns silent %%s/%s/%s/%s'):format(pair[1], pair[2], flag))
  end
end

-- :Asciiify[!]
vim.api.nvim_create_user_command('Asciiify', function(opts)
  asciiify(not opts.bang)   -- bang (!) disables confirmation
end, { bang = true, desc = 'Convert smart quotes / dashes to ASCII' })

-- Key-mappings ---------------------------------------------------------------
vim.keymap.set('n', '<leader>tqi', function() asciiify(true) end,
  { desc = '[T]ext [Q]uotes: [I]nteractive asciiify' })

vim.keymap.set('n', '<leader>tqa', function()
  local ok = vim.fn.confirm('Convert smart typography to ASCII?', '&Yes\n&No', 2)
  if ok == 1 then asciiify(false) end
end, { desc = '[T]ext [Q]uotes: [A]ll asciiify' })

-- which-key label for the "tq" group (safe if which-key not installed)
pcall(function()
  require('which-key').add({
    { "<leader>tq", group = "[T]ext [Q]uote fixes" },
  })
end)

-- Return an empty table so Lazy gets *no* plugin spec from this file.
return {}