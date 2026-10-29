return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		{ "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
		"nvim-tree/nvim-web-devicons",
		-- dressing.nvim and nvim-treesitter are standalone specs in this config;
		-- current avante no longer requires them.
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
				command = "/opt/homebrew/bin/claude-agent-acp",
				args = {},
			},
			["kimi"] = {
				command = "/opt/homebrew/bin/kimi",
				args = { "acp" },
			},
		},
		behaviour = {
			acp_follow_agent_locations = true,
		},
		-- Avante auto-sets <leader>a* keymaps by default:
		--   <leader>aa  Ask
		--   <leader>ae  Edit
		--   <leader>ar  Refresh
		--   <leader>af  Focus
		--   <leader>an  New ask
		--   <leader>az  Zen mode
		--   <leader>aS  Stop
		--   <leader>at  Toggle
		--   <leader>aM  Select ACP model
		--   <leader>am  Select ACP mode
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

		vim.keymap.set({ "n", "v" }, "<leader>ak", function()
			require("avante.api").switch_provider("kimi")
			require("avante.api").ask()
		end, { desc = "Avante Ask (Kimi)" })
	end,
}
