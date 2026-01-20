-- options.lua
vim.opt.number = true
vim.opt.relativenumber = false

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4 

-- unnamedplus is a register for the clipboard, synchronizing the system's clipboard with neovim's
vim.opt.clipboard = "unnamedplus"

vim.opt.scrolloff = 999

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.g.mapleader = " "

vim.keymap.set("n", "<down>", "gj")
vim.keymap.set("n", "<up>", "gk")

vim.opt.shellslash = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

-- Set up diagnostics
vim.diagnostic.config({
    virtual_lines = true,
})
