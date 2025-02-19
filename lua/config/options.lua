-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

-- Indenting
opt.tabstop = 4 -- A TAB character looks like 4 spaces
opt.shiftwidth = 4 -- Number of spaces inserted when indenting
opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character

opt.relativenumber = true
opt.list = false
opt.termguicolors = true
-- vim.g.lazyvim_picker = "snacks"

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"
-- Python debugging
vim.g.python3_host_prog = "~/.virtualenvs/debugpy/bin/python"

-- vim.opt_local.conceallevel = 2
-- If set to 0 it shows all the symbols in a file, like bulletpoints and
-- codeblock languages, obsidian.nvim works better with 1 or 2
-- Set it to 2 if using kitty or codeblocks will look weird
vim.opt.conceallevel = 2
