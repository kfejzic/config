local M = {}

local function single_nodes(match)
	local result = {}
	for id, nodes in pairs(match) do
		result[id] = type(nodes) == "table" and nodes[1] or nodes
	end
	return result
end

function M.setup()
	if vim.fn.has("nvim-0.12") == 0 then
		return
	end

	local query = require("vim.treesitter.query")
	if M.loaded then
		return
	end
	M.loaded = true

	-- Neovim 0.12 removed all=false. The legacy Tree-sitter modules
	-- still explicitly request single nodes rather than capture lists.
	for _, method in ipairs({ "add_predicate", "add_directive" }) do
		local register = query[method]
		query[method] = function(name, handler, opts)
			if type(opts) == "table" and opts.all == false then
				local legacy_handler = handler
				handler = function(match, ...)
					return legacy_handler(single_nodes(match), ...)
				end
			end
			return register(name, handler, opts)
		end
	end

	local function wrap_query(value)
		if not value or rawget(value, "iter_matches") then
			return value
		end
		local iter_matches = value.iter_matches
		value.iter_matches = function(self, node, source, start, stop, opts)
			local iter = iter_matches(self, node, source, start, stop, opts)
			if not opts or opts.all ~= false then
				return iter
			end
			return function(...)
				local pattern, match, metadata, tree = iter(...)
				if match then
					match = single_nodes(match)
				end
				return pattern, match, metadata, tree
			end
		end
		return value
	end
	for _, method in ipairs({ "get", "parse" }) do
		local get_query = query[method]
		query[method] = function(...)
			return wrap_query(get_query(...))
		end
	end
end

return M
