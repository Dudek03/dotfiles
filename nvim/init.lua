-- 1. GLOBALS & LEADER
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ========================================================================== --
--  2. OPTIONS
-- ========================================================================== --
vim.o.hlsearch = false
vim.wo.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.opt.termguicolors = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.scrolloff = 4
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- ========================================================================== --
--  3. LAZY.NVIM BOOTSTRAP
-- ========================================================================== --
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ========================================================================== --
--  4. PLUGINS
-- ========================================================================== --
require("lazy").setup({

	-- UI
	{
		"cyberdream.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("cyberdream")
		end,
	},

	-- WHICH-KEY
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>b", group = "Buffers" },
				{ "<leader>d", group = "Debug/Diagnostics" },
				{ "<leader>g", group = "Git" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Tabs" },
				{ "<leader>v", desc = "Split Vertical" },
				{ "<leader>h", desc = "Split Horizontal" },
				{ "<leader>.", desc = "Scratchpad" },
				{ "<leader>e", desc = "File Explorer" },
			})
		end,
	},

	-- indent
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)
			require("ibl").setup({
				indent = {
					highlight = {
						"RainbowRed",
						"RainbowYellow",
						"RainbowBlue",
						"RainbowOrange",
						"RainbowGreen",
						"RainbowViolet",
						"RainbowCyan",
					},
				},
			})
		end,
	},

	-- status bar & icons
	{ "nvim-lualine/lualine.nvim", opts = { options = { theme = "auto" } } },
	{ "nvim-tree/nvim-web-devicons" },

	-- SNACKS
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = { enabled = true },
			notifier = { enabled = true },
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			lazygit = { enabled = true },
		},
	},

	-- MINI
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.files").setup()
		end,
	},

	-- GIT & WAKATIME
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "wakatime/vim-wakatime" },
	{ "ellisonleao/carbon-now.nvim", cmd = "CarbonNow" },

	-- TELESCOPE
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- formatting (Conform)
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {
			notify_on_error = false,
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				python = { "isort", "black" },
			},
		},
	},

	-- TREESITTER
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python" },
				auto_install = true,
				highlight = { enable = true },
			})
		end,
	},

	-- MASON & LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local capabilities = require("cmp_nvim_lsp").default_capabilities()
						require("lspconfig")[server_name].setup({ capabilities = capabilities })
					end,
				},
			})
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" } },
			})
		end,
	},

	-- DEBUGOWANIE (DAP + UI )
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "codelldb", "netcoredbg", "js-debug-adapter" },
				automatic_installation = true,
				handlers = {},
			})

			local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/Scripts/python.exe"
			path = path:gsub("/", "\\")
			if vim.loop.fs_stat(path) then
				require("dap-python").setup(path)
			end

			dapui.setup()
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Stop Debugging" })
		end,
	},
})

-- ========================================================================== --
--  5. KEYMAPS
-- ========================================================================== --
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.keymap.set("i", "jj", "<Esc>", opts)
vim.keymap.set("i", "jk", "<ESC>", opts)
vim.keymap.set("i", "kj", "<ESC>", opts)

vim.keymap.set("n", "<C-q>", "<C-v>", { desc = "Visual Block Mode" })

vim.keymap.set("n", "<Esc>", ":noh<CR>", opts)
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- splits
vim.keymap.set("n", "<leader>v", "<C-w>v", { desc = "Split Vertical" })
vim.keymap.set("n", "<leader>h", "<C-w>s", { desc = "Split Horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make Splits Equal" })
vim.keymap.set("n", "<leader>xs", "<C-w>c", { desc = "Close Window" })

-- tools
vim.keymap.set("n", "<leader>e", function()
	require("mini.files").open()
end, opts)
vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, opts)
vim.keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, opts)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
vim.keymap.set("n", "<leader>sg", builtin.live_grep, {})
vim.keymap.set("n", "<leader><space>", builtin.buffers, {})
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })

-- errors
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Error Message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

local diagnostics_active = true
vim.keymap.set("n", "<leader>do", function()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.enable()
	else
		vim.diagnostic.disable()
	end
end, { desc = "Toggle Diagnostics" })

-- Transparency
vim.keymap.set("n", "<leader>bg", function()
	local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	if not hl.bg then
		vim.cmd("colorscheme cyberdream")
	else
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
	end
end, { desc = "Toggle Transparent Background" })
