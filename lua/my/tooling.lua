local M = {}

M.required_executables = {
  'fd',
  'git',
  'node',
  'rg',
  'shfmt',
  'tree-sitter',
}

M.lsp_servers = {
  bashls = {},
  gopls = {},
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  marksman = {},
  rust_analyzer = {},
  ts_ls = {},
  yamlls = {},
}

M.treesitter_parsers = {
  -- Programming languages
  'c', 'cpp', 'c_sharp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript',
  'typescript', 'php', 'perl', 'zig', 'svelte',

  -- Documentation and config
  'vimdoc', 'vim', 'markdown', 'markdown_inline', 'latex', 'mermaid',

  -- Shell and system
  'bash', 'awk', 'powershell', 'ssh_config', 'passwd',

  -- Git
  'diff', 'git_rebase', 'gitcommit', 'gitignore', 'gitattributes', 'git_config',

  -- Data formats
  'json', 'json5', 'yaml', 'toml', 'xml', 'csv', 'graphql', 'jq',

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
  'sql', 'regex', 'printf', 'gpg',
}

return M
