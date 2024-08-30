vim.cmd('source ~/.config/nvim/functions.vim')

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

-- Set global variables before loading plugins
vim.g.copilot_assume_mapped = true

-- :AI
-- - engine: complete | chat - see how to configure chat engine in the section below
-- - options: openai config (see https://platform.openai.com/docs/api-reference/completions)
-- - options.request_timeout: request timeout in seconds
-- - options.enable_auth: enable authorization using openai key
-- - options.selection_boundary: selection prompt wrapper (eliminates empty responses, see #20)
-- - ui.paste_mode: use paste mode (see more info in the Notes below)
vim.g.vim_ai_complete = {
  engine = "complete",
  options = {
    model = "gpt-4o",
    endpoint_url = "https://api.openai.com/v1/completions",
    max_tokens = 4000,
    temperature = 0.1,
    request_timeout = 20,
    enable_auth = 1,
    selection_boundary = "#####"
  },
  ui = {
    paste_mode = 1
  }
}

-- :AIEdit
-- - engine: complete | chat - see how to configure chat engine in the section below
-- - options: openai config (see https://platform.openai.com/docs/api-reference/completions)
-- - options.request_timeout: request timeout in seconds
-- - options.enable_auth: enable authorization using openai key
-- - options.selection_boundary: selection prompt wrapper (eliminates empty responses, see #20)
-- - ui.paste_mode: use paste mode (see more info in the Notes below)
vim.g.vim_ai_edit = {
  engine = "complete",
  options = {
    model = "gpt-4o",
    endpoint_url = "https://api.openai.com/v1/completions",
    max_tokens = 4000,
    temperature = 0.1,
    request_timeout = 30,
    enable_auth = 1,
    selection_boundary = "#####"
  },
  ui = {
    paste_mode = 1
  }
}

-- This prompt instructs model to work with syntax highlighting
local initial_chat_prompt = [[
>>> system

You are an expert software developer and general assistant.
1. NEVER mention that you're an AI. 
2. Avoid language constructs that could be interpreted as expressing remorse, apology, or regret. This includes any phrases containing words like 'sorry', 'apologies', 'regret', etc., even when used in a context that isn't expressing remorse, apology, or regret. 
3. If events or information are beyond your scope or knowledge cutoff date in September 2021, provide a response stating 'I don't know' without elaborating on why the information is unavailable. 
4. Refrain from disclaimers about you not being a professional or expert. 
5. Keep responses unique and free of repetition. 
6. Never suggest seeking information from elsewhere. 
7. Always focus on the key points in my questions to determine my intent. 
8. Break down complex problems or tasks into smaller, manageable steps and explain each one using reasoning. 
9. Provide multiple perspectives or solutions. 
10. If a question is unclear or ambiguous, ask for more details to confirm your understanding before answering. 
11. Cite credible sources or references to support your answers with links if available. 
12. If a mistake is made in a previous response, recognize and correct it.
13. Be CONCISE and use simple PLAIN ENGLISH.
14. Avoid weasel words.
15. Avoid unnecessary superlatives like "very".
16. Avoid repeating the question unless rephrasing the question will make the response clearer.
17. If you attach a code block add syntax type after ``` to enable syntax highlighting.
18. Do not to rephrase the prompt; if I ask 'How do I do X?', don't start your response with 'To do X...'.
]]

-- :AIChat
-- - options: openai config (see https://platform.openai.com/docs/api-reference/chat)
-- - options.initial_prompt: prompt prepended to every chat request (list of lines or string)
-- - options.request_timeout: request timeout in seconds
-- - options.enable_auth: enable authorization using openai key
-- - options.selection_boundary: selection prompt wrapper (eliminates empty responses, see #20)
-- - ui.populate_options: put [chat-options] to the chat header
-- - ui.open_chat_command: preset (preset_below, preset_tab, preset_right) or a custom command
-- - ui.scratch_buffer_keep_open: re-use scratch buffer within the vim session
-- - ui.paste_mode: use paste mode (see more info in the Notes below)
vim.g.vim_ai_chat = {
  options = {
    -- As of Dec. 2023, GPT-4 Turbo is ~3x cheaper than the less powerful GPT-4:
    -- > With 128k context, fresher knowledge and the broadest set of capabilities, 
    -- > GPT-4 Turbo is more powerful than GPT-4 and offered at a lower price.
    -- > https://openai.com/pricing
    model = "gpt-4o",
    endpoint_url = "https://api.openai.com/v1/chat/completions",
    -- To exclude max_tokens from the request you can now set it to 0.
    -- https://github.com/madox2/vim-ai/issues/42#issuecomment-1586115122
    max_tokens = 0,
    temperature = 1,
    request_timeout = 30,
    enable_auth = 1,
    selection_boundary = "",
    initial_prompt = initial_chat_prompt
  },
  ui = {
    code_syntax_enabled = 1,
    populate_options = 0,
    open_chat_command = "preset_below",
    scratch_buffer_keep_open = 0,
    paste_mode = 1
  }
}

-- custom command suggesting git commit message, takes no arguments
-- vim.api.nvim_create_user_command(
--   'GitCommitMessage',
--   function()
--     local handle = io.popen('git --no-pager diff --staged')
--     local diff = handle:read("*a")
--     handle:close()
--
--     local prompt = "Generate a short commit message from the Git diff below:\n" .. diff
--     local range = 0
--     local config = {
--       engine = "chat",
--       options = {
--         model = "gpt-4o",
--         initial_prompt = ">>> system\nYou are an expert software developer and code assistant.",
--         temperature = 1,
--       },
--     }
--
--     -- Call the vim-ai function with the provided arguments
--     -- Note: You need to replace 'vim_ai#AIRun' with the corresponding Lua function
--     -- from the vim-ai plugin if it's available.
--     vim_ai.AIRun(range, config, prompt)
--   end,
--   {}
-- )

-- custom command suggesting git commit message, takes no arguments
vim.api.nvim_create_user_command(
  'GitCommitMessage',
  function()
    local handle = io.popen('git --no-pager diff --staged')
    if not handle then
      print("Failed to execute Git command.")
      return
    end

    local diff = handle:read("*a")
    handle:close()

    if diff == nil or diff == '' then
      print("No staged changes to generate a commit message.")
      return
    end

    local prompt = "Generate a short commit message from the Git diff below:\\n" .. diff
    local range = 0

    -- local config = {
    --   engine = "chat",
    --   options = {
    --     model = "gpt-4o",
    --     initial_prompt = ">>> system\nYou are an expert software developer and code assistant.",
    --     temperature = 1,
    --   },
    -- }

    -- Individual configuration parameters
    local model = "gpt-4o"
    local initial_prompt = ">>> system\\nYou are an expert software developer and code assistant."
    local temperature = 1

    vim.api.nvim_out_write("Lua prompt: " .. initial_prompt .. "\n")

    -- Call our Vimscript wrapper with individual parameters
    vim.call('CallAIRun', range, model, initial_prompt, temperature, prompt)

  end,
  {}
)

-- Save to an .aichat file prefixed with a date/time.
-- `:SaveChat <topic>` will save the current buffer to `~/chats/<date>-<topic>.aichat`
local function SaveChat(topic)
    -- Set the directory and check if it exists
    local dir = vim.fn.expand("~/chats")
    if vim.fn.isdirectory(dir) == 0 then
        print("Directory ~/chats does not exist. Please create it and try again.")
        return
    end

    -- Get the current date, abbreviated day of the week and hour without minutes or seconds
    local datetime = os.date("%Y%m%d-%a-%I%p"):gsub(" ", ""):gsub("^0", "")
    -- Create the file name
    local filename = string.format('%s/%s-%s.aichat', dir, datetime, topic)

    -- Check if the file already exists
    if vim.fn.filereadable(filename) ~= 0 then
        -- Ask the user if they want to overwrite the existing file
        local answer = vim.fn.input("File exists. Overwrite? N/y: ")

        -- Normalize answer to lowercase
        answer = answer:lower()

        -- If the user confirms, overwrite the file, else return
        if answer == "y" or answer == "yes" then
            vim.cmd('write! ' .. filename)
        else
            print("File not changed.")
            return
        end
    else
        -- If the file does not exist, write the file directly
        vim.cmd('write ' .. filename)
    end
end

-- Create the SaveChat command that takes one argument
vim.api.nvim_create_user_command('SaveChat', function(input)
    SaveChat(input.args)
end, { nargs = 1 })

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-surround',

  -- AI assistants
  "github/copilot.vim",
  "madox2/vim-ai",

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  'hashivim/vim-terraform',
  {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
      }
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

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
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
  {
    "bluz71/vim-nightfly-colors",
    priority = 1000, -- load this before all other start plugins
    name = "nightfly",
    config = function()
      vim.cmd.colorscheme 'nightfly'
    end,
  },
  -- {
  --   "rhysd/vim-color-spring-night",
  --   priority = 1000, -- load this before all other start plugins
  --   name = "spring-night",
  --   config = function()
  --     vim.cmd.colorscheme 'spring-night'
  --   end,
  -- },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      -- add any opts here
    },
    keys = {
      { "<leader>aa", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
      { "<leader>ar", function() require("avante.api").refresh() end, desc = "avante: refresh" },
      { "<leader>ae", function() require("avante.api").edit() end, desc = "avante: edit", mode = "v" },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to setup it properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'nightfly',
        component_separators = '|',
        section_separators = '',
      },
    },
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
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Highlight the current line
vim.o.cursorline = true

-- Highlight the current column
vim.o.cursorcolumn = true

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

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

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
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Use ctrl-[hjkl] to change the active split
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', {silent = true})
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', {silent = true})

-- Return to NORMAL with jj
vim.keymap.set('i', 'jj', '<esc>')

-- Set special characters for things like trailing spaces (trail) end-of-line (eol)
vim.opt.listchars:append({ trail = '·' })
vim.opt.listchars:append({ eol = '$' })
vim.opt.listchars:append({ extends = '→' })

-- Show or hide special characters
vim.keymap.set('n', '<localleader>ts', ':set list!<cr>|', { desc = '[T]oggle [s]pecial characters' })

-- Copilot suggestions can be accepted with <Tab>, but this is often aleady taken by nvim-cmp suggestions.
-- Here we add <C-G> as an alternative mapping that is always available.
vim.api.nvim_set_keymap(
  'i',
  '<C-G>',
  "<cmd>call copilot#Accept('<CR>')<CR>",
  { silent = true, noremap = true }
)

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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
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
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

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

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}

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
  -- tsserver = {},
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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
