---
schema: v1
id: 3wc0k2
title: Neovim UX Upgrade Blueprint
status: open
type: task
priority: p1
deps: []
tags: [config, lsp, neovim, performance, roadmap, treesitter, ux]
created_at: "2026-02-22T21:34:04Z"
---
<!-- ksmem:managed: direct edits bypass validation; use ksmem commands -->
Blueprint for modernizing this Neovim setup to improve day-to-day UX while minimizing breakage. This stone is the locked implementation blueprint.

## Context

### Objective
Deliver a modern, predictable Neovim UX on `v0.11.6` for this config while preserving strong startup performance and low learning overhead.

### Baseline
1. Installed Neovim: `v0.11.6` (stable).
2. Current startup samples (headless):
   - Empty: ~`96.8ms`
   - Open file (`README.md`): ~`113.4ms`
3. Current stack includes `lazy.nvim`, Telescope, Snacks, project auto-cd logic, Codeium, Treesitter, and Mason/LSP.

### Target architecture
1. LSP on Neovim 0.11 native model (`vim.lsp.config` + `vim.lsp.enable`) with Mason installation flows.
2. Deterministic completion via `blink.cmp`, with AI completion preserved on non-Tab acceptance keys.
3. Root-aware operations with no global auto-`cd`.
4. Telescope-first picker UX (Snacks kept for utility modules, not primary pickers).
5. Stable keymap taxonomy by namespace (`<leader>f`, `<leader>q`, `<leader>a`, `<C-k>`).
6. Theme-coherent UI with no hardcoded structural hex colors.
7. Startup UX policy: launching `nvim` shows an empty working buffer (not a welcome/dashboard buffer); launching `nvim <file>` opens the requested file directly.

### Constraints
1. Keep startup responsiveness in current envelope.
2. Ship in small, reversible commits.
3. Validate behavior after each phase with repeatable smoke tests and startup checks.

## Plan

### Phase 0: Implementation snapshot and rollback anchor
1. Record baseline startup procedure (5 runs each, compare medians):
   - `nvim --headless --startuptime /tmp/nvim-startup-empty.log +qa`
   - `nvim --headless --startuptime /tmp/nvim-startup-file.log README.md +qa`
2. Record interactive sanity checks:
   - launch `nvim` and verify empty working buffer (no welcome/dashboard)
   - launch `nvim README.md` and verify direct file-open
   - run primary file and grep picker flows
3. Create rollback anchor tag before code changes:
   - `ux-blueprint-pre-impl-2026-02-22`

### Phase 1: Conflict and debt removal
1. Resolve keymap conflicts explicitly:
   - `<C-k>` remains window navigation in normal mode; move normal-mode signature help to `gK`.
   - move Treesitter parameter swap from `<leader>a` / `<leader>A` to `[a` / `]a`.
   - move LSP format from `<leader>f` to `<leader>cf`.
   - keep `<leader>q` for diagnostics/quickfix; move quote/ascii tools to `<leader>tq*`.
2. Remove TreeSitter extmark monkey patch from `init.lua`.
3. Remove hardcoded structural pane-color Vimscript/highlight block.
4. Remove duplicate root/cwd mutation logic:
   - remove `lua/custom/auto-project-cd.lua`
   - remove `project.nvim` global auto-cd behavior.
5. Replace `neodev` with `lazydev`.
6. Remove low-risk hazards (unused vars, trailing command artifacts, accidental pasted junk).
7. If TS errors recur after patch removal, debug root cause (parser/filetype/config); do not reintroduce a global API shim.

### Phase 2: LSP and completion foundation
1. Migrate LSP setup to 0.11-native model.
2. Install/configure `blink.cmp` as deterministic completion engine.
3. Keep AI completion on dedicated non-Tab acceptance key.
4. Verify hover/rename/code-action/format and completion trigger/accept behavior.

### Phase 3: Root and picker simplification
1. Finalize root-aware/no-global-cd behavior.
2. Keep Telescope as primary picker system.
3. Remove overlapping root-management and picker complexity that is no longer needed after Phase 1/2.
4. Keep Snacks utility modules only; avoid dual primary picker paradigms.

### Phase 4: UX polish and stabilization
1. Align theme behavior across dark/light variants with policy-compliant highlights.
2. Normalize keymap descriptions and group names.
3. Re-run end-to-end smoke tests and startup measurements.

### Verification gates (every phase)
1. Startup checks against baseline medians.
2. No startup errors in headless launch.
3. Smoke test checklist passes:
   - plain `nvim` startup opens empty working buffer without welcome/dashboard
   - `nvim <file>` opens target file directly
   - split + terminal navigation
   - picker files/grep workflows
   - root behavior across multi-repo contexts
   - LSP hover/rename/code-action/format
   - completion trigger/accept behavior
   - no TreeSitter error spam
4. Each change set remains small and revertable.

### Completion criteria
1. All phase goals implemented.
2. Key workflows remain stable.
3. Startup envelope remains acceptable versus baseline.
4. Final keymap and workflow changes are documented.

## Decisions

### Locked decisions

1. LSP migration policy
   - Use Neovim 0.11 native LSP model now.
   - Implement with `vim.lsp.config(...)` and `vim.lsp.enable(...)`.
   - Keep Mason for server installation and enable flows.

2. Completion policy
   - Adopt `blink.cmp` as deterministic completion layer.
   - Keep AI completion, but remove unconditional AI accept on `<Tab>`.

3. Root model policy
   - Use root-aware operations.
   - Do not use global automatic `cd` as steady-state behavior.
   - Remove competing root authorities (`project.nvim` auto-cd + custom auto-project-cd).

4. Picker architecture policy
   - Use Telescope-first picker architecture for a simpler learning path from current baseline.
   - Keep Snacks for utility modules only (notifier, bufdelete, zen, etc.).
   - Defer any Snacks-picker migration to a separate future blueprint.

5. Keymap taxonomy policy
   - `<leader>f` = find/pickers only.
   - `<leader>q` = diagnostics/quickfix only.
   - `<leader>a` = AI-only namespace.
   - `<C-k>` (normal mode) = window navigation only.
   - Required remaps:
     - LSP format: `<leader>f` -> `<leader>cf`
     - quote/ascii tools: move off `<leader>q` to `<leader>tq*`
     - Treesitter swap: `<leader>a` / `<leader>A` -> `[a` / `]a`
     - normal-mode signature help: `<C-k>` -> `gK`

6. Theme coherence policy
   - No hardcoded structural UI hex colors in `init.lua`.
   - Narrow exceptions allowed for transient functional overlays, or highlights recalculated per colorscheme/background.

7. Startup UX policy
   - `nvim` with no file argument must open a plain empty working buffer (no welcome screen/dashboard buffer).
   - `nvim <file>` must open the requested file directly.
   - Dashboard-style screens must remain manually-invoked only.

## Evidence

### Baseline measurements
1. Neovim version: `NVIM v0.11.6`.
2. Headless startup samples:
   - Empty: ~`96.8ms`
   - Open `README.md`: ~`113.4ms`

### Primary conflict inventory
1. Keymap collisions and namespace drift:
   - `<C-k>` split navigation vs LSP signature help
   - `<leader>a` AI namespace vs Treesitter swap mapping
   - `<leader>f` picker namespace vs LSP format mapping
   - `<leader>q` diagnostics/quickfix vs quote/ascii tooling
2. Root/cwd conflicts:
   - `project.nvim` global auto-cd
   - custom `auto-project-cd.lua` global `cd`
3. Structural rendering and theming risks:
   - TreeSitter extmark monkey patch
   - hardcoded structural pane colors incompatible with theme variants

### Files of interest
1. `init.lua`
2. `lua/custom/plugins/project.lua`
3. `lua/custom/auto-project-cd.lua`
4. `lua/custom/plugins/claude-code.lua`
5. `lua/custom/plugins/asciiify.lua`
6. `lua/custom/plugins/snacks.lua`
7. `lazy-lock.json`

### Validation strategy
1. Use phase-by-phase startup measurements with median comparison.
2. Run workflow smoke checks after each phase.
3. Keep each phase independently revertable.

## Journal


- 2026-02-22T21:34:32Z | rewrote section context (old_lines=0 new_lines=31): Populate review context and baseline for Neovim UX blueprint.

- 2026-02-22T21:34:44Z | rewrote section plan (old_lines=0 new_lines=42): Add phased execution plan with consensus gates and acceptance criteria.

- 2026-02-22T21:34:54Z | rewrote section decisions (old_lines=0 new_lines=30): Record decision points for reviewer consensus before implementation.

- 2026-02-22T21:35:01Z | rewrote section evidence (old_lines=0 new_lines=18): Attach baseline measurements and config references used to derive blueprint.

- 2026-02-22T22:06:35Z | rewrote section decisions (old_lines=30 new_lines=40): Replace decisions section with 3-reviewer synthesis and explicit consensus gates.

- 2026-02-22T22:06:46Z | rewrote section plan (old_lines=42 new_lines=53): Replace plan with consensus-driven phased plan including mandatory gates from all three reviews.

- 2026-02-22T22:41:06Z | rewrote section decisions (old_lines=40 new_lines=40): Apply merged re-approval lockset and remove unresolved-options state.

- 2026-02-22T22:41:19Z | rewrote section plan (old_lines=53 new_lines=65): Apply concrete start-gate procedures and explicit Phase 1/3 actions requested by re-approvals.

- 2026-02-22T22:43:31Z | rewrote section context (old_lines=31 new_lines=22): Remove review-process framing and keep only final implementation context.

- 2026-02-22T22:43:46Z | rewrote section plan (old_lines=65 new_lines=63): Replace plan with clean ready-to-implement phased blueprint.

- 2026-02-22T22:43:53Z | rewrote section decisions (old_lines=40 new_lines=34): Keep only final locked implementation decisions.

- 2026-02-22T22:43:59Z | rewrote section evidence (old_lines=176 new_lines=32): Remove reviewer-history content; keep only implementation-relevant technical evidence.

- 2026-02-22T22:45:15Z | rewrote section context (old_lines=22 new_lines=23): Align context with simpler Telescope-first UX and explicit no-welcome startup requirement.

- 2026-02-22T22:45:24Z | rewrote section decisions (old_lines=34 new_lines=40): Lock picker strategy to Telescope-first and add startup UX policy.

- 2026-02-22T22:45:36Z | rewrote section plan (old_lines=63 new_lines=62): Update implementation plan to Telescope-first and explicit startup behavior checks.

## Lessons

