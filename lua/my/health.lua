local M = {}

function M.check()
  local tooling = require 'my.tooling'

  vim.health.start 'Required command-line tools'
  for _, executable in ipairs(tooling.required_executables) do
    if vim.fn.executable(executable) == 1 then
      vim.health.ok(('%s: %s'):format(executable, vim.fn.exepath(executable)))
    else
      vim.health.error(('%s is not executable'):format(executable))
    end
  end

  vim.health.start 'Managed language servers'
  local registry_ok, registry = pcall(require, 'mason-registry')
  local mappings_ok, mappings = pcall(require, 'mason-lspconfig.mappings')
  if not registry_ok or not mappings_ok then
    vim.health.error 'Mason registry or mason-lspconfig mappings are unavailable'
  else
    local server_names = vim.tbl_keys(tooling.lsp_servers)
    table.sort(server_names)
    local package_map = mappings.get_mason_map().lspconfig_to_package
    for _, server_name in ipairs(server_names) do
      local package_name = package_map[server_name]
      if package_name and registry.is_installed(package_name) then
        vim.health.ok(('%s: %s installed'):format(server_name, package_name))
      elseif package_name then
        vim.health.error(('%s: Mason package %s is missing'):format(server_name, package_name))
      else
        vim.health.error(('%s has no Mason package mapping'):format(server_name))
      end
    end
  end

  vim.health.start 'Configured Tree-sitter parsers'
  for _, language in ipairs(tooling.treesitter_parsers) do
    local ok = pcall(vim.treesitter.language.add, language)
    if ok then
      vim.health.ok(('%s parser loads'):format(language))
    else
      vim.health.error(('%s parser is missing or cannot load'):format(language))
    end
  end

  vim.health.start 'Intentional exclusions'
  local disabled_providers = {
    'loaded_node_provider',
    'loaded_perl_provider',
    'loaded_python3_provider',
    'loaded_ruby_provider',
  }
  for _, provider in ipairs(disabled_providers) do
    if vim.g[provider] == 0 then
      vim.health.ok(('%s is explicitly disabled'):format(provider))
    else
      vim.health.warn(('%s is not explicitly disabled'):format(provider))
    end
  end

  vim.health.start 'UI integrations'
  if vim.ui.select == Snacks.picker.select then
    vim.health.ok 'vim.ui.select uses Snacks.picker.select'
  elseif #vim.api.nvim_list_uis() == 0 then
    vim.health.info 'Snacks installs vim.ui.select on UIEnter; no UI is attached to this headless check.'
  else
    vim.health.error 'vim.ui.select does not use Snacks.picker.select in an attached UI'
  end
  vim.health.info 'Snacks image/PDF/LaTeX/Mermaid rendering dependencies are intentionally not part of this workstation baseline.'
end

return M
