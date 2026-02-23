# Neovim Config (Daily Driver)

This started as a Kickstart.nvim fork and is now a heavily customized Neovim setup focused on a fast, predictable workflow.

## Core behavior

- `nvim` opens an empty working buffer (no auto welcome/dashboard screen).
- `nvim <file>` opens the file directly.
- Dashboard is manual only: `<leader><leader>`.
- Leader key is `<Space>`.

## Stack (short version)

- Plugin manager: `lazy.nvim`
- Pickers/navigation: `snacks.nvim` (`Snacks.picker.*`)
- LSP/tooling: Mason + native Neovim LSP (`vim.lsp.config` / `vim.lsp.enable`)
- Completion: `blink.cmp` + optional Codeium
- Syntax/highlighting: Treesitter
- Comments: `Comment.nvim` (linewise `gc` / `gcc`, shell-safe)

## Requirements

- Neovim `0.11+`
- `git`
- `ripgrep` (`rg`)
- A C compiler is recommended for Treesitter parser builds

## Install

macOS / Linux:

```sh
git clone <repo-url> ~/.config/nvim
nvim
```

Windows (PowerShell):

```powershell
git clone <repo-url> $env:LOCALAPPDATA\nvim
nvim
```

## First run

On first launch, `lazy.nvim` bootstraps and installs plugins.

Useful checks:

```vim
:Lazy
:Mason
:checkhealth
```

## Daily keys (most useful)

Navigation and windows:

- `<C-h> <C-j> <C-k> <C-l>`: move between splits
- `-` or `<leader>e`: open file explorer (Oil)

Find and search (`Snacks`):

- `<leader>ff`: find files
- `<leader>sg`: grep project
- `<leader><space>`: buffers
- `<leader>?`: recent files
- `<leader>/`: search current buffer
- `<leader>fp`: projects

LSP:

- `gd` / `gr` / `gI`: definition, references, implementation
- `K` / `gK`: hover, signature help
- `<leader>rn`: rename
- `<leader>ca`: code action
- `<leader>cf`: format

Diagnostics:

- `[d` / `]d`: prev/next diagnostic
- `<leader>E`: diagnostic float
- `<leader>q`: diagnostics list

Editing and UI:

- `gc` / `gcc`: comment selection or line
- `<leader>nh`: notification history
- `<leader>nd`: dismiss notifications
- `<leader><leader>`: open dashboard (manual)

## Where to customize

- `init.lua`: core options, keymaps, LSP, Treesitter
- `lua/custom/plugins/*.lua`: plugin-specific config

## Update and rollback

- Update plugins: `:Lazy update`
- Update Treesitter parsers: `:TSUpdate`
- Update Mason packages: `:MasonUpdate`
- Roll back plugin versions via `lazy-lock.json` + `:Lazy restore`
