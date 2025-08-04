-- This is a fork of Kickstart.nvim

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: You should make sure your terminal supports this
-- Setting this early for plugins that need it (like colorizer)
vim.o.termguicolors = true

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Tim Pope essentials
  'tpope/vim-surround',
  'tpope/vim-repeat',  -- Enable repeating supported plugin maps with "."

  -- AI assistant - Codeium (better than Copilot, free)
  {
    "Exafunction/codeium.vim",
    event = 'BufEnter',
    config = function ()
      -- Disable default bindings
      vim.g.codeium_disable_bindings = 1
      
      -- Set up our own keybindings
      vim.keymap.set('i', '<Tab>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-]>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<M-[>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
      vim.keymap.set('i', '<C-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
    end
  },

  -- Navigation within files - Hop (the community favorite EasyMotion replacement)
  {
    "phaazon/hop.nvim",
    branch = 'v2',
    config = function()
      local hop = require('hop')
      hop.setup { keys = 'etovxqpdygfblzhckisuran' }
      
      -- Custom highlights with cyan background
      vim.api.nvim_set_hl(0, 'HopNextKey', { bg = '#00dfff', fg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'HopNextKey1', { bg = '#00dfff', fg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'HopNextKey2', { bg = '#ff007c', fg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'HopUnmatched', { fg = '#666666' })
      
      -- Hop to any character (most used)
      vim.keymap.set('n', 's', function() hop.hint_char1() end, {desc = "Hop to character"})
      
      -- Hop to any word beginning
      vim.keymap.set('n', 'gw', function() hop.hint_words() end, {desc = "Hop to word"})
      
      -- Hop with 2 characters for precision (shift-s)
      vim.keymap.set('n', 'S', function() hop.hint_char2() end, {desc = "Hop to 2 characters"})
    end,
  },

  -- Better search highlighting and preview
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require('hlslens').setup()
      -- Show search count in virtual text
      local kopts = {noremap = true, silent = true}
      vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    end,
  },

  -- Quick file switching
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      
      -- Set up keybindings after harpoon is loaded
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end,
  },

  -- Tree view for file structure

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Visual undo history
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle [U]ndo tree' })
    end
  },

  'hashivim/vim-terraform',

  -- "Just works" IDE features
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
      user_default_options = {
        mode = "background",
        tailwind = true,
      },
    }
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- No config needed, just works!
    }
  },

  {
    "RRethy/vim-illuminate",
    config = function()
      -- Automatically highlights other uses of word under cursor
      require('illuminate').configure({
        delay = 100,
        large_file_cutoff = 2000,
      })
    end
  },

  {
    "hedyhli/outline.nvim",
    config = function()
      require("outline").setup({
        -- Ensure j/k work normally
        outline_window = {
          wrap = false,
          show_cursorline = true,
          hide_cursor = false,
        },
      })
      vim.keymap.set('n', '<leader>o', ':Outline<CR>', { desc = 'Toggle symbols [o]utline' })
    end
  },
  {
    'stevearc/oil.nvim',
    opts = {
      -- Skip confirmation for simple edits
      skip_confirm_for_simple_edits = true,
      
      -- Delete to trash instead of permanently
      delete_to_trash = true,
      
      -- Show more file information
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      
      -- Watch for external file changes
      watch_for_changes = true,
      
      -- View options
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },


  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },
  -- {
  --   "bluz71/vim-nightfly-colors",
  --   priority = 1000, -- load this before all other start plugins
  --   name = "nightfly",
  --   config = function()
  --     vim.cmd.colorscheme 'nightfly'
  --   end,
  -- },
  -- {
  --   "rhysd/vim-color-spring-night",
  --   priority = 1000, -- load this before all other start plugins
  --   name = "spring-night",
  --   config = function()
  --     vim.cmd.colorscheme 'spring-night'
  --   end,
  -- },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = false,
          theme = 'flexoki',
          component_separators = '|',
          section_separators = '',
          globalstatus = true, -- Single status line for all windows
          always_divide_middle = false,
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {
            {
              'filename',
              path = 1, -- relative path
              symbols = {
                modified = ' [+]',
                readonly = ' [RO]',
                unnamed = '[No Name]',
              },
            }
          },
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {{'filename', path = 1}},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        winbar = {},
        inactive_winbar = {},
        tabline = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              function()
                local filepath = vim.fn.expand('%:p')
                if filepath == '' then
                  return '[No Name]'
                end
                return filepath
              end,
              color = { fg = '#ffffff', bg = '#1a1a1a', gui = 'bold' },
            }
          },
          lualine_x = {
            {
              function()
                return 'CWD: ' .. vim.fn.getcwd()
              end,
              color = { fg = '#00a0ff', bg = '#1a1a1a', gui = 'bold' },
            }
          },
          lualine_y = {},
          lualine_z = {}
        },
      })
    end,
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!


-- Highlight the current line
vim.o.cursorline = true

-- Highlight the current column
vim.o.cursorcolumn = true

-- Always show tabline for full file path display
vim.o.showtabline = 2

-- Highlight all search matches
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent, make long lines wrap with indentation
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Muchos level of undo
vim.o.undolevels = 500

-- Keep a long history of commands
vim.o.history = 5000

-- Limit syntax highlighting on very long lines
vim.o.synmaxcol = 5000

-- Start scrolling a few lines before the border (more context around the cursor)
vim.o.scrolloff = 4

-- Start horz scrolling a few columns before the border 098 098 098 098 09809 234203498 092384 00980234 09 23409 230498 234098 234098809 234098 er908
vim.o.sidescrolloff = 4

-- Hide mode (e.g. '-- INSERT ----') in the command line because it's in the status line
vim.o.showmode = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Wrapping is ugly, off by default
vim.o.wrap = false

-- But if you switch from nowrap to wrap, try not to wrap in the middle of words
vim.o.linebreak = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Show vertical lines at common line-length max values
vim.o.colorcolumn = '80,100,120'

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Use ctrl-[hjkl] to change the active split
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {silent = true})

-- Return to NORMAL with jj
vim.keymap.set('i', 'jj', '<esc>')

-- Exit Terminal mode with Ctrl-Space (easy to press)
vim.keymap.set('t', '<C-Space>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Set terminal scrollback buffer to 100,000 lines (for Claude Code and other terminals)
-- Safe on modern systems, uses ~100-200MB RAM at full capacity
vim.opt.scrollback = 100000

-- Set special characters for things like trailing spaces (trail) end-of-line (eol)
vim.opt.listchars:append({ trail = '·' })
vim.opt.listchars:append({ eol = '$' })
vim.opt.listchars:append({ extends = '→' })

-- Show or hide special characters
vim.keymap.set('n', '<localleader>ts', ':set list!<cr>|', { desc = '[T]oggle [s]pecial characters' })


-- Oil.nvim (same key binding as neo-tree)
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer (Oil)" })

-- Screenshot workflow
vim.keymap.set("n", "<leader>ss", "<CMD>Oil ~/screenshots<CR>", { desc = "Open screenshots directory" })

-- Command to insert the latest screenshot path
vim.api.nvim_create_user_command('LatestScreenshot', function()
  local handle = io.popen("ls -t ~/screenshots/*.png 2>/dev/null | head -1")
  local result = handle:read("*a")
  handle:close()
  local screenshot = result:gsub("\n", "")
  if screenshot ~= "" then
    vim.api.nvim_put({screenshot}, "", true, true)
  else
    vim.notify("No screenshots found", vim.log.levels.WARN)
  end
end, { desc = "Insert path of latest screenshot" })

-- Command to copy latest screenshot path to clipboard
vim.api.nvim_create_user_command('CopyLatestScreenshot', function()
  local handle = io.popen("ls -t ~/screenshots/*.png 2>/dev/null | head -1")
  local result = handle:read("*a")
  handle:close()
  local screenshot = result:gsub("\n", "")
  if screenshot ~= "" then
    vim.fn.setreg("+", screenshot)
    vim.notify("Copied: " .. screenshot)
  else
    vim.notify("No screenshots found", vim.log.levels.WARN)
  end
end, { desc = "Copy latest screenshot path to clipboard" })


-- Add confirmation for window quit to prevent accidental closing
vim.keymap.set('n', '<C-w>q', function()
  local choice = vim.fn.confirm("Close this window?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd('quit')
  end
end, { desc = 'Quit window with confirmation' })

-- Also protect C-w C-q (holding Ctrl while pressing q)
vim.keymap.set('n', '<C-w><C-q>', function()
  local choice = vim.fn.confirm("Close this window?", "&Yes\n&No", 2)
  if choice == 1 then
    vim.cmd('quit')
  end
end, { desc = 'Quit window with confirmation' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Set defaults for new empty buffers ]]
local empty_buffer_group = vim.api.nvim_create_augroup('EmptyBufferDefaults', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    -- Check if this is a new empty buffer
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local is_empty = #lines == 1 and lines[1] == ''
    local has_name = vim.api.nvim_buf_get_name(buf) ~= ''
    
    -- Only apply to unnamed empty buffers
    if is_empty and not has_name then
      vim.bo.filetype = 'markdown'
      vim.wo.wrap = true
      vim.wo.spell = true
    end
  end,
  group = empty_buffer_group,
  pattern = '*',
})

-- [[ Set .mdx files as markdown ]]
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  pattern = '*.mdx',
  command = 'set filetype=markdown',
})

-- [[ Set large scrollback for terminal buffers ]]
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    -- 100k lines uses ~100-200MB RAM when full
    vim.opt_local.scrollback = 100000
  end,
  desc = 'Set large scrollback buffer for terminals',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    -- Use ripgrep with smart settings
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
      '--glob=!.git/*',
      '--glob=!node_modules/*'
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['jj'] = { '<Esc>', type = 'command' },
      },
    },
    file_ignore_patterns = { 'node_modules', '.git/', '.cache' },
    layout_strategy = 'flex',
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    frecency = {
      default_workspace = "CWD",
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = { "*.git/*", "*.cache/*", "node_modules/*" },
    },
  }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == "" then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ":h")
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    print("Not a git repository. Searching on current working directory")
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep({
      search_dirs = {git_root},
    })
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader><leader>', function() require('snacks').dashboard() end, { desc = 'Dashboard' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  -- HACK: Workaround for TreeSitter highlighter 'Invalid end_col' errors
  -- 
  -- This is a known issue in Neovim since 2020 where TreeSitter's highlighter
  -- miscalculates column positions in certain edge cases:
  -- - When tab characters are used (byte offset vs display column mismatch)
  -- - During line deletion/editing (stale position references)
  -- - When nodes end at column 0 (range calculation edge case)
  --
  -- The error manifests as a popup loop that can cause data loss by preventing
  -- normal editor operations. This wrapper catches and suppresses these specific
  -- errors while allowing other errors to propagate normally.
  --
  -- This is a temporary fix until the upstream issue is resolved in Neovim core.
  -- Track progress at: https://github.com/neovim/neovim/issues/29550
  --
  -- To remove this hack: Delete this entire block when the issue is fixed upstream
  local ok, ts_highlight = pcall(require, 'vim.treesitter.highlighter')
  if ok and ts_highlight.new then
    local old_new = ts_highlight.new
    ts_highlight.new = function(...)
      local highlighter = old_new(...)
      local old_on_line = highlighter.on_line
      highlighter.on_line = function(self, ...)
        local ok, err = pcall(old_on_line, self, ...)
        if not ok and err:match("Invalid 'end_col'") then
          -- Silently ignore the error
          return
        elseif not ok then
          error(err)
        end
      end
      return highlighter
    end
  end

  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 
      -- Programming languages
      'c', 'cpp', 'c_sharp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 
      'typescript', 'php', 'perl', 'zig', 'svelte',
      
      -- Documentation and config
      'vimdoc', 'vim', 'markdown', 'markdown_inline', 'latex', 'mermaid',
      
      -- Shell and system
      'bash', 'awk', 'powershell', 'tmux', 'ssh_config', 'passwd',
      
      -- Git
      'diff', 'git_rebase', 'gitcommit', 'gitignore', 'gitattributes', 'git_config',
      
      -- Data formats
      'json', 'jsonc', 'json5', 'yaml', 'toml', 'xml', 'csv', 'graphql', 'jq',
      
      -- Web
      'html', 'css', 'scss', 'http', 'nginx', 'caddy',
      
      -- DevOps and cloud
      'dockerfile', 'terraform', 'helm', 'bicep',
      
      -- Build tools and package managers
      'make', 'cmake', 'requirements', 'pymanifest', 'editorconfig',
      
      -- Go ecosystem
      'gomod', 'gosum', 'gowork', 'gotmpl', 'goctl',
      
      -- Documentation
      'jsdoc', 'luadoc', 'godot_resource',
      
      -- Other
      'sql', 'regex', 'printf', 'gpg'
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Add format keymap
  nmap('<leader>f', vim.lsp.buf.format, '[F]ormat code')
  
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').add({
  { "<leader>c", group = "Code" },
  { "<leader>c_", hidden = true },
  { "<leader>d", group = "Document" },
  { "<leader>d_", hidden = true },
  { "<leader>f", group = "Find Files" },
  { "<leader>f_", hidden = true },
  { "<leader>g", group = "Git" },
  { "<leader>g_", hidden = true },
  { "<leader>r", group = "Rename" },
  { "<leader>r_", hidden = true },
  { "<leader>s", group = "Search" },
  { "<leader>s_", hidden = true },
  { "<leader>w", group = "Workspace" },
  { "<leader>w_", hidden = true },
  { "<leader>h", group = "Harpoon" },
  { "<leader>h_", hidden = true },
  { "<leader>b", group = "Buffer" },
  { "<leader>b_", hidden = true },
  { "<leader>n", group = "Notes/Snippets" },
  { "<leader>n_", hidden = true },
  { "<leader>t", group = "Theme" },
  { "<leader>t_", hidden = true },
  { "<leader>a", group = "AI/Claude Code" },
  { "<leader>a_", hidden = true },
  { "<leader>A", hidden = true }, -- Hide swap previous parameter
  { "<leader>1", hidden = true }, -- Hide harpoon file 1
  { "<leader>2", hidden = true }, -- Hide harpoon file 2
  { "<leader>3", hidden = true }, -- Hide harpoon file 3
  { "<leader>4", hidden = true }, -- Hide harpoon file 4
  { "-", desc = "Oil - File Manager" },
  { "<leader>e", desc = "Oil File Explorer" },
  { "<leader>u", desc = "Toggle Gundo Tree" },
  { "<leader>o", desc = "Toggle Outline" },
  { "<leader>z", desc = "Zen Mode" },
  { "<leader>?", desc = "Recent Files" },
  { "<leader><space>", desc = "Open Buffers" },
  { "<leader>/", desc = "Search Current Buffer" }
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- ts_ls = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Setup basic LSP capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
        filetypes = (servers[server_name] or {}).filetypes,
      }
    end,
  }
}


-- Define the function that will change the background for the
-- active and inactive panes using Vimscript
local set_background = function ()
  vim.cmd [[
    augroup ChangeActivePaneBackground
      autocmd!
      " For active pane
      autocmd WinEnter,BufEnter * setlocal winhighlight=Normal:ActivePane,NormalNC:InactivePane
      " For inactive pane
      autocmd WinLeave,BufLeave * setlocal winhighlight=Normal:InactivePane,NormalNC:InactivePane
    augroup END
  ]]
end

-- Call the function to set up the commands
set_background()

-- Highlight group for active pane background
vim.cmd 'highlight ActivePane guibg=#010f1b'
-- Highlight group for inactive pane background
vim.cmd 'highlight InactivePane guibg=#011627'

-- Create a namespace for extmarks
local ns_id = vim.api.nvim_create_namespace('blingWordHighlights')

_G.blingWord = function(n)
    -- Yank the current word into the z register and retrieve it
    vim.cmd('normal! "zyiw')
    local word = vim.fn.getreg('z')

    -- Escape the word for use in a Lua pattern
    local escaped_word = vim.fn.escape(word, '\\')

    -- Function to apply highlighting in a buffer
    local function applyHighlight(buf)
        -- Clear existing extmarks in this namespace
        vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

        -- Search for the word in the buffer and apply extmarks
        local line_count = vim.api.nvim_buf_line_count(buf)
        for line = 0, line_count - 1 do
            local text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1]
            for index in string.gmatch(text, '()' .. escaped_word .. '()') do
                -- -1 because Lua indexing is 1-based and Neovim API expects 0-based indexing
                vim.api.nvim_buf_set_extmark(buf, ns_id, line, index - 1, {
                    end_line = line,
                    end_col = index - 1 + #word,
                    hl_group = 'BlingWord' .. n
                })
            end
        end
    end

    -- Iterate over all windows in the current tab
    for _, win_id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        -- Check if the buffer is loaded to avoid processing unloaded buffers
        if vim.api.nvim_buf_is_loaded(buf_id) then
            applyHighlight(buf_id)
        end
    end
end

-- Key mappings
vim.api.nvim_set_keymap('n', '<localleader>h0', ':lua vim.fn.clearmatches()<CR>:noh<CR>', { noremap = true, silent = true })
for i = 1, 6 do
    vim.api.nvim_set_keymap('n', '<localleader>h' .. i, ':lua blingWord(' .. i .. ')<CR>', { noremap = true, silent = true })
end

-- Claude Code Editor keymaps
-- TODO: Move these to claude-code.nvim plugin when implementing PR
-- vim.keymap.set('n', '<leader>ce', function() 
--   require('custom.claude-code-editor').edit_for_claude() 
-- end, { desc = 'Claude Code [e]ditor' })
-- 
-- vim.keymap.set('v', '<leader>cs', function() 
--   require('custom.claude-code-editor').send_visual_to_claude() 
-- end, { desc = 'Claude Code [s]end selection' })

-- Highlight definitions
local colors = {
    '#6eff81', -- Neon Lime Green
    '#ff75ba', -- Hot Pink
    '#70f8ff', -- Electric Blue
    '#ffff73', -- Bright Yellow
    '#f7554f', -- Vivid Orange
    '#cf65fc'  -- Radiant Purple
}
for i, color in ipairs(colors) do
    vim.api.nvim_command('highlight def BlingWord' .. i .. ' guifg=#000000 ctermfg=16 guibg=' .. color .. ' ctermbg=' .. i + 213)
end

-- Setup automatic project directory switching
require('custom.auto-project-cd').setup()


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
