local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	'rose-pine/neovim',
	{ 'nvim-treesitter/nvim-treesitter', branch = 'main', lazy = false, build = ':TSUpdate' },
	{ 'mbbill/undotree' },
	{ 'tpope/vim-fugitive' },
	{ 'tpope/vim-rhubarb' },
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				'phpactor',
			},
		},
	},
	{
		'hrsh7th/cmp-nvim-lsp',
		dependencies = {
			'hrsh7th/nvim-cmp',
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				yaml = { "yamllint" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},

	-- { 'folke/tokyonight.nvim' },
	{ 'edenEast/nightfox.nvim' },
	{ 'catppuccin/nvim', name = 'catppuccin' },
	{ 'echasnovski/mini.nvim' },
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy",
		opts = {},
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	-- {
	-- 	"robitx/gp.nvim",
	-- 	config = function()
	-- 		local conf = {
	-- 			-- For customization, refer to Install > Configuration in the Documentation/Readme
	-- 			providers = {
	-- 				ollama = {
	-- 					endpoint = "http://192.168.0.54:11434/v1/chat/completions",
	-- 					secret = "",
	-- 				},
	-- 			},
	-- 			agents = {
	-- 				{
	-- 					name = "default",
	-- 					provider = "ollama",
	-- 					chat = true,
	-- 					command = true,
	-- 					model = { model = "gemma3:12b" },
	-- 					system_prompt =
	-- 						"I am an AI meticulously crafted to provide programming guidance and code assistance. "
	-- 						.. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
	-- 						.. "and expect precise, technical responses tailored to your development needs.\n",
	-- 				},
	-- 				{
	-- 					name = "coder",
	-- 					provider = "ollama",
	-- 					chat = true,
	-- 					command = true,
	-- 					model = { model = "deepseek-coder-v2:16b" },
	-- 					system_prompt =
	-- 						"I am an AI meticulously crafted to provide programming guidance and code assistance. "
	-- 						.. "To best serve you as a computer programmer, please provide detailed inquiries and code snippets when necessary, "
	-- 						.. "and expect precise, technical responses tailored to your development needs.\n",
	-- 				}
	-- 			},
	-- 			default_command_agent = "default",
	-- 			default_chat_agent = "default"
	-- 		}
	-- 		require("gp").setup(conf)
	--
	-- 		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
	-- 	end,
	-- }
	{
		"yetone/avante.nvim",
		build = vim.fn.has("win32") ~= 0
			and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			provider = "ollama",
			-- provider = "claude",
			providers = {
				ollama = {
					endpoint = "http://192.168.0.54:11434",
					-- model = "qwen3:14b",
					model = "qwen2.5-coder:14b",
					-- model = "gemma3:1b",
					timeout = 30000,
					extra_request_body = {
						options = {
							temperature = 0.75,
							num_ctx = 20480,
							keep_alive = "20m"
						},
					},
				},
				-- openai = {
				-- 	endpoint = "https://api.openai.com/v1",
				-- 	model = "gpt-4o-mini",
				-- 	timeout = 30000,
				-- 	extra_request_body = {
				-- 		options = {
				-- 			temperature = 0.75,
				-- 			max_tokens = 20480,
				-- 		},
				-- 	},
				-- },
				-- claude = {
				-- 	endpoint = "https://api.anthropic.com",
				-- 	model = "claude-sonnet-4-20250514",
				-- 	timeout = 30000, -- Timeout in milliseconds
				-- 	extra_request_body = {
				-- 		temperature = 0.75,
				-- 		max_tokens = 20480,
				-- 	},
				-- },
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
			-- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			-- "hrsh7th/nvim-cmp",      -- autocompletion for avante commands and mentions
			-- "ibhagwan/fzf-lua",      -- for file_selector provider fzf
			-- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			-- "zbirenbaum/copilot.lua", -- for providers='copilot'
			-- {
			-- 	-- support for image pasting
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	opts = {
			-- 		-- recommended settings
			-- 		default = {
			-- 			embed_image_as_base64 = false,
			-- 			prompt_for_file_name = false,
			-- 			drag_and_drop = {
			-- 				insert_mode = true,
			-- 			},
			-- 			-- required for Windows users
			-- 			use_absolute_path = true,
			-- 		},
			-- 	},
			-- },
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
})
