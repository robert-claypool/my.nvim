local M = {}

local lsp_kinds = {
  'Array',
  'Boolean',
  'Class',
  'Color',
  'Constant',
  'Constructor',
  'Control',
  'Enum',
  'EnumMember',
  'Event',
  'Field',
  'File',
  'Folder',
  'Function',
  'Interface',
  'Key',
  'Keyword',
  'Method',
  'Module',
  'Namespace',
  'Null',
  'Number',
  'Object',
  'Operator',
  'Package',
  'Property',
  'Reference',
  'Snippet',
  'String',
  'Struct',
  'Text',
  'TypeParameter',
  'Unit',
  'Unknown',
  'Value',
  'Variable',
}

M.kinds = {}
for _, kind in ipairs(lsp_kinds) do
  M.kinds[kind] = kind:sub(1, 1)
end

return M
