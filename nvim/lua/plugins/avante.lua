return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"stevearc/dressing.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		provider = "codex",
		mode = "agentic",
		acp_providers = {
			["codex"] = {
				command = "/opt/homebrew/bin/codex-acp",
				args = {},
			},
			["claude-code"] = {
				command = "/opt/homebrew/bin/claude-code-acp",
				args = {},
			},
		},
		behaviour = {
			acp_follow_agent_locations = true,
		},
		-- Avante auto-sets <leader>a* keymaps by default:
		--   <leader>aa  Ask (codex, default)
		--   <leader>ae  Edit
		--   <leader>ar  Refresh
		--   <leader>af  Focus
		--   <leader>an  New ask
		--   <leader>az  Zen mode
		--   <leader>aS  Stop
		--   <leader>at  Toggle
		--   <leader>ad  Debug
	},
	config = function(_, opts)
		require("avante").setup(opts)

		-- Override default <leader>aa to clarify it uses Codex
		vim.keymap.set({ "n", "v" }, "<leader>aa", function()
			require("avante.api").ask()
		end, { desc = "Avante Ask (Codex)" })

		vim.keymap.set({ "n", "v" }, "<leader>aA", function()
			require("avante.api").switch_provider("claude-code")
			require("avante.api").ask()
		end, { desc = "Avante Ask (Claude Code)" })
	end,
}
