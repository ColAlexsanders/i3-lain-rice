-- init.lua
require("options")
require("plugins")
require 'nvim-treesitter.install'.compilers = { "clang" }
require 'nvim-treesitter.install'.prefer_git = false
local async = require "plenary.async"
local builtin = require('telescope.builtin')
