local ts_utils = require("nvim-treesitter.ts_utils")
local M = {}

local get_main_node = function()

  local node = ts_utils.get_node_at_cursor()

  if node == nil then
    error("No Treesitter found.")
  end

  local root = ts_utils.get_root_for_node(node)

  local start_row = node:start()
  local parent = node:parent()

  while(parent ~= nil and parent ~= root and parent:start() == start_row) do
    node = parent
    parent = node:parent()
  end

  return node

end

M.select = function()

  local node = get_main_node()
  local bufnr = vim.api.nvim_get_current_buf()
  ts_utils.update_selection(bufnr, node)

end


M.change = function()

  local node = get_main_node()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col, end_row, end_col = node:range()
  local replaced = 'abraka dabra'
  local text = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
  
  local i=1
  local f = io.open("abrakadabra.js", "a")
  while(text[i]~=nil) do
    f:write(tostring(text[i]).."\n")
    i = i + 1
  end
  f:close()

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replaced })

end

return M
