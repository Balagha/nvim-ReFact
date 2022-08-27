local ts_utils = require("nvim-treesitter.ts_utils")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local function check_it_has_expression(node)
	local expr_container = {}
	local child_list = ts_utils.get_named_children(node)
	for key,val in pairs(child_list) do
		if(val ~= nil) then
		  local returned_arr = check_it_has_expression(val)
		  for _,v in ipairs(returned_arr) do 
    		table.insert(expr_container, v)
			end
		  if(val:type() == "jsx_expression") then
		  	local inner_child_list = ts_utils.get_named_children(val)
        local nodeText = vim.treesitter.get_node_text(val, vim.api.nvim_get_current_buf())
		    table.insert(expr_container, nodeText)
		  end
	  end
	end
	return expr_container
end

local get_input = function(fn)
	local input = Input({
		position = "50%",
		size = {
			width = 20,
		},
		border = {
			style = "single",
			text = {
				top = "[Component Name]",
				top_align = "center",
			},
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		prompt = "> ",
		default_value = "",
		on_close = function()
			print("Input Closed!")
		end,
		on_submit = fn,
	})

	input:mount()

	input:on(event.BufLeave, function()
		input:unmount()
	end)
end

local M = {}

-- function
local get_match_index = function(node)
	local nodeText = vim.treesitter.get_node_text(node, vim.api.nvim_get_current_buf())
	local matchIndexStart, matchIndexEnd = string.find(nodeText, "</")
	return matchIndexStart, matchIndexEnd
end

-- function
local get_main_node = function()
	local node = ts_utils.get_node_at_cursor()

	if node == nil then
		error("No Treesitter found.")
	end

	local root = ts_utils.get_root_for_node(node)
	local start_row = node:start()
	local parent = node:parent()

	matchIndexStart, matchIndexEnd = get_match_index(node)

	if matchIndexStart == 1 and matchIndexEnd == 2 then
		node = parent
		parent = node:parent()
	end

	while parent ~= nil and parent ~= root and parent:start() == start_row do
		node = parent
		parent = node:parent()
		matchIndexStart, matchIndexEnd = get_match_index(node)
		if matchIndexStart == 1 and matchIndexEnd == 2 then
			node = parent
			parent = node:parent()
		end
	end

	return node
end

-- function
local insert_code_into_new_file = function(file_name)
	local node = get_main_node()
	local bufnr = vim.api.nvim_get_current_buf()
	local start_row, start_col, end_row, end_col = node:range()
	local text = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})
	local text = vim.treesitter.get_node_text(node, bufnr)
	
	local replaced = "<" .. file_name .. " "
	local import_statement = "import " .. file_name .. ' from "' .. file_name .. '";'

	local arr = {}
	arr = check_it_has_expression(node)
	for k, v in pairs(arr) do
		local repl = v:gsub("%{", "")
		repl = repl:gsub("%}","")
		replaced = replaced .. repl .. "=" .. v
		repl = "{props." .. repl .. "}"
		text = text:gsub( v, repl)
	end
	replaced = replaced .. "/>"

	vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replaced })
	vim.api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { import_statement })

	local pre_code = "function " .. file_name .. "(props) {\n  return (\n"
	local post_code = "  );\n}\n\nexport default " .. file_name .. ";"

	local i = 1

	local f = io.open(file_name .. ".js", "w")

	if f == nil then
		error("Could not Open File")
	end

	f:write(pre_code)
	f:write(text)
	f:write(post_code)
	f:close()
end

M.select = function()
	local node = get_main_node()
	local bufnr = vim.api.nvim_get_current_buf()
	ts_utils.update_selection(bufnr, node)
end

M.change = function()
	get_input(function(file_name)
		local node = get_main_node()
		local bufnr = vim.api.nvim_get_current_buf()
		local start_row, start_col, end_row, end_col = node:range()

		insert_code_into_new_file(file_name)

		vim.api.nvim_command("write")
	end)
end

return M
