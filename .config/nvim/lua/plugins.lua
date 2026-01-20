-- plugins.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local yaml_template_path

if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
	yaml_template_path = "C:/Users/Alex/Documents/NvimPluginStuff/Md2Pdf-alexxGmZ/BasicTemplate.yml"
elseif vim.fn.has("unix") == 1 then
	yaml_template_path = "/home/alex/NvimPluginStuff/Md2Pdf-alexxGmZ/BasicTemplate.yml"
else
	error("Unsupported operating system: " .. os.name)
end

require("lazy").setup({	
    {
        "RedsXDD/neopywal.nvim",
        name = "neopywal",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            local neopywal = require("neopywal")
            neopywal.setup({
                use_wallust = true,
            })
            vim.cmd([[colorscheme neopywal]])
        end
    },

    {
        "baliestri/aura-theme",
        lazy = false,
--        priority = 1000,
        config = function(plugin)
            vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
--            vim.cmd([[colorscheme aura-dark]])
        end
    },


    {
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.10.0",
        lazy = false,
        build = ":TSUpdate",
	    config = function()
            require'nvim-treesitter'.setup({
                ensure_installed = { },

                auto_install = true,

                highlight = {
                    enable = true,
                },
        
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader>ss",
                        node_incremental = "<Leader>si",
                        scope_incremental = "<Leader>sc",
                        node_decremental= "<Leader>sd",
                    },
                },
                indent = { enable = true },
                modules = {},
                sync_install = true,
                textobjects = {
                    select = {
                        enable = true,

                        lookahead = true,

                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'v', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                },
            })
      end,
    },
        
    {
        "nvim-lua/plenary.nvim",
    },

    {
        "nvim-telescope/telescope.nvim", 
        tag = '0.1.8',
        dependencies = { 
			"nvim-lua/plenary.nvim",
		},
        config = function()
        require'telescope'.setup{
            extensions = {
                zoxide = {
                  mappings = {
                    ["<return>"] = {
                      keepinsert = true,
                      action = function(selection)
                        require("telescope").extensions.file_browser.file_browser({ cwd = selection.path })
                      end
                    },
                    default = {
                      after_action = function(selection)
                        print("Update to (" .. selection.z_score .. ") " .. selection.path)
                      end
                    },
                    ["<C-s>"] = {
                      before_action = function(selection) print("before C-s") end,
                      action = function(selection)
                        vim.cmd.edit(selection.path)
                      end
                    },
                  },
                }
            },
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
				find_files = {
					hidden = true,
					find_command = {
						"rg",
						"--files",
						"--glob",
						"!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
						"--path-separator",
						"/",
					},
				},
			},
		}
		require("telescope").load_extension("zoxide")
		-- Keybindings for Telescope
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
		vim.keymap.set('n', '<leader>fd', builtin.buffers, { desc = 'Buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
		vim.keymap.set("n", "<leader>fz", ":Telescope zoxide list<CR>", {})
        vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", {})
        vim.keymap.set("n", "<leader>fc", builtin.colorscheme, { desc = 'Change colorscheme' })
      end
    },

	{
		"jvgrootveld/telescope-zoxide",
		config = function() end,
	},

	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { 
            "nvim-telescope/telescope.nvim", 
            "nvim-lua/plenary.nvim", 
        },
        config = function()
            require("telescope").setup {
              extensions = {
                file_browser = {
                  theme = "ivy",
                  -- disables netrw and use telescope-file-browser in its place
                  hijack_netrw = true,
                },
              },
            }
            -- To get telescope-file-browser loaded and working with telescope,
            -- you need to call load_extension, somewhere after setup function:
            require("telescope").load_extension "file_browser"
            vim.keymap.set("n", "<space>fb", function()
                require("telescope").extensions.file_browser.file_browser()
            end)
        end
    },

   {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        diagnostics = { globals = { 'vim', 'require' } },
                    }
                }
            })
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "vimls"}
            })
        end,
    },
	
    {
        "neovim/nvim-lspconfig",
        dependencies = { "williamboman/mason-lspconfig.nvim" }, 
    },

    {
       "nvim-tree/nvim-tree.lua",
       config = function()
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive",
            },
            view = {
                width = 30,
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
            on_attach = my_on_attach,
	    vim.keymap.set('n', '<leader>ft', '<Cmd>:NvimTreeToggle<CR>', { desc = 'Open NvimTree' })
        })

	local function my_on_attach(bufnr)
         local api = require "nvim-tree.api"

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)
      end
    end,
   },
		
   {
		"bullets-vim/bullets.vim",
		config = function()
			vim.g.bullets_enabled_file_types = {
				'markdown',
				'text',
				'gitcommit',
				'scratch',
			}
		end,
   },
	
   {
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
				{ desc = "Toggle Outline" })

			require("outline").setup {
				-- Your setup opts here (leave empty to use defaults)
			}
		end,
	},
 
    {
       'alexxGmZ/Md2Pdf',
       config = function()
           require('Md2Pdf').setup({
               cmd = "Md2Pdf",
               pdf_engine = "xelatex", 
               yaml_template_path = yaml_template_path,
            })
        end,
    },

	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup {
			  -- Manual mode doesn't automatically change your root directory, so you have
			  -- the option to manually do so using `:ProjectRoot` command.
			  manual_mode = false,

			  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
			  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
			  -- order matters: if one is not detected, the other is used as fallback. You
			  -- can also delete or rearangne the detection methods.
			  detection_methods = { "lsp", "pattern" },

			  -- All the patterns used to detect root dir, when **"pattern"** is in
			  -- detection_methods
			  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

			  -- Table of lsp clients to ignore by name
			  -- eg: { "efm", ... }
			  ignore_lsp = {},

			  -- Don't calculate root dir on specific directories
			  -- Ex: { "~/.cargo/*", ... }
			  exclude_dirs = {},

			  -- Show hidden files in telescope
			  show_hidden = false,

			  -- When set to false, you will get a message when project.nvim changes your
			  -- directory.
			  silent_chdir = true,

			  -- What scope to change the directory, valid options are
			  -- * global (default)
			  -- * tab
			  -- * win
			  scope_chdir = 'global',

			  -- Path where project.nvim will store the project history for use in
			  -- telescope
			  datapath = vim.fn.stdpath("data"),
			}
		end
	},

    {
        'stevearc/oil.nvim',
		opts = {},
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			config = function()
				require("oil").setup({
					default_file_explorer = true,
					view_options = {
						show_hidden = true,
					},
					keymaps = {
						["g?"] = "actions.show_help",
						["<CR>"] = "actions.select",
						["<C-s>"] = {
							"actions.select",
							opts = { vertical = true },
							desc = "Open the entry in a vertical split",
						},
						["<C-h>"] = {
							"actions.select",
							opts = { horizontal = true },
							desc = "Open the entry in a horizontal split",
						},
						["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
						["<C-p>"] = "actions.preview",
						["q"] = "actions.close",
						["<C-l>"] = "actions.refresh",
						["-"] = "actions.parent",
						["_"] = "actions.open_cwd",
						["`"] = "actions.cd",
						["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
						["gs"] = "actions.change_sort",
						["gx"] = "actions.open_external",
						["g."] = "actions.toggle_hidden",
						["g\\"] = "actions.toggle_trash",
					},
					float = {
						padding = 3,
						max_width = 64,
						border = "single",
					},
				})
				vim.keymap.set("n", "fo", "<CMD>Oil<CR>", { desc = "Open parent directory" })
			end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
          {
            "<leader>?",
            function()
              require("which-key").show({ global = true })
            end,
            desc = "keymaps (which-key)",
          },
        },
      },
	  
	  {
		"goolord/alpha-nvim",
		dependencies = {
			"echasnovski/mini.icons",
	    },

		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
	
			dashboard.section.header.val = {
				[[         ⠄⣀⠢⢀⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⡔⢀⠂⡜⢭⢻⣍⢯⡻⣝⣿⣿⡿⣟⠂ ]],
				[[         ⠄⠀⣦⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡔⡀⢂⠜⣪⢗⡾⣶⡽⣾⣟⣯⠛ ]],
				[[       ⠄⠀⠠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣔⠨⡸⡝⣯⣳⢏⣿⠳⠉⠀⢠⣬⡶ ]],
				[[ ⠠⣓⢤⣂⣄⣀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠁⣞⡱⣝⠎⠀⢀⠠⣥⠳⡞⡹ ]],
				[[ ⡄⢉⠲⢿⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡔⣧⡽⠋⠀⣰⣶⣻⣶⣿⢾⣷ ]],
				[[ ⢤⡈⠉⠲⢤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢀⡴⢏⡳⢮⡿⣽⣞⠻⡜ ]],
				[[ ⠒⣭⠳⢶⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡙⠮⣜⣯⡽⣳⢌⡓⠈ ]],
				[[ ⡸⣰⢋⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣻⢿⣻⣿⡽⣗⠋⠄ ]],
				[[ ⠣⢇⢟⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢟⡿⢣⣟⡻⠘ ]],
				[[ ⠱⡊⠤⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠨⠗⠋⣁⣤⠖⠊⢁⣀⠀ ]],
				[[ ⠁⠂⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⣿⡂⠹⣿⣿⣿⣿⣿⠙⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠄⠒⢋⣉⡤⣔⣮⣽⣾ ]],
				[[ ⢢⠣⣌⢼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⢰⣿⡅⠀⣿⣿⣿⣿⣿⠀⠸⢿⣹⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣻⣿⣿⣿⣿⣿⣿⣿ ]],
				[[ ⢃⡉⠠⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣼⢹⠀⠀⠀⠀⣾⠿⡇⠀⣿⣿⣿⣿⡏⠀⠀⣞⣧⣻⠟⢿⣿⣿⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣧⠱⣌⣳⣽⣻⣿⣿⣻ ]],
				[[ ⢒⡕⣺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⡇⠈⣇⠀⠀⠀⠈⡆⢳⠀⠇⡟⠋⠉⠀⠀⠀⠃⢙⣠⣤⣤⣼⣯⣚⣟⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠌⠑⠌⢳⠛⡛⠏⠛⠉ ]],
				[[ ⡘⢷⣌⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⢻⣀⣧⣤⣽⣦⣤⣄⠀⠰⡀⠃⠀⠀⠀⠀⠀⠀⡴⠟⠛⣉⣉⡉⠉⠈⠉⠉⠉⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢈⠈⠈⠁⠛⠀⠀⠀⣒ ]],
				[[ ⠉⢣⡛⣿⣿⣿⣿⣿⣿⣿⣿⣿⡧⠖⠛⠉⠉⠉⠀⠀⠐⠒⢢⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⣠⣲⣾⣿⢿⣷⢶⡄⠀⠀⣽⣿⣿⣿⣿⡿⠟⣿⣿⣿⣿⣿⠛⢁⣤⡶⠿⠛⠋ ]],
				[[ ⠌⢽⣿⣿⣿⣿⣿⣿⣿⣿⡷⠀⠀⠀⣠⣶⣶⣿⣟⣿⣶⡅⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⢿⣿⣿⣿⣿⠀⣿⡀⠀ ⢻⣬⣙⡻⡿⣡⣾⣿⣿⡍⠈⣀⣤⣬⣤⣶⣲⣶⣿ ]],
			    [[ ⢈⠐⡀⢻⣫⢿⣿⣿⣿⣿⠘⢧⠁⠀⣻⡏⠸⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑⢄⣉⣛⣋⣡⡴⠃⠀⣿⣿⣿⠟⣠⡛⢿⣿⣿⣷⣲⣽⣿⣿⣷⣾⣷⣿⣿ ]],
				[[ ⢀⠐⡀⢃⡈⣿⢿⣿⣿⣟⡆⠀⠀⠉⠿⣦⣈⣉⣉⠤⠚⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡟⣡⣶⣿⣿⣾⣿⣿⣿⢿⡿⣿⣿⡿⠿⠛⣋⣡ ]],
		        [[ ⠠⠐⡀⢢⣶⣿⢧⠻⣯⣿⣯⡛ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⠐⠂⡁⠤⠔⢂⣉⣤⡴ ]],
		        [[ ⣀⠥⠌⣳⢯⣟⣮⣗⣾⣟⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⠂⣈⠥⡔⡤⣍⠣⣝⢾⡹ ]],
				[[ ⠠⠈⠉⠈⠉⠉⠉⣨⣿⣿⣿⣯⣭⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⡟⠻⢞⣿⣝⣳⢎⢳⢻⡮⣕ ]],
				[[ ⢀⠀⡀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⡗⢠⠘⡼⣽⣛⡞⠦⣧⢻⣽ ]],
			  [[ ⢈⠀⡀⡀⢤⠞⡉⢭⣹⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣍⣣⢾⣵⣯⣷⣽⣦⣑⣯⢿ ]],
			[[  ⠂⣴⣾⡟⣧⠊⡔⢢⠛⣿⣿⣿⣿⣿⣿⣿⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠒⠂⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⠉⣯⢹⣽⢻⣿⣿⣿⣿⣿⣿⣿⣿ ]],
			[[ ⣶⣟⠳⣏⡿⣎⠳⣈⡜⣺⣿⠿⢿⣝⡿⣫⢟⣽⣿⣿⠻⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠔⠛⣿⠿⣟⢩⢾⣿⣿⣿⣿⣇⠾⣜⡧⣯⣟⣿⣿⣿⣿⣿⣿⣿⣿ ]],
			[[ ⠋⢀⢱⣫⣟⢾⡹⢴⡸⣵⡏⣂⢾⡿⣽⣹⣟⣾⣿⡟⢠⡇⠀⣹⠂⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⣣⢟⡿⣾⣿⣿⣿⣿⢌⠫⢝⡻⣵⢻⡟⣿⢿⣿⢿⡿⣿⠿ ]],
			[[ ⢢⠞⣴⢯⢯⣝⣦⢳⡝⡶⣭⣿⣽⣳⣟⡾⣽⡟⢀⡟⠀⢀⡿⠀⠀⠀⠁⠠⠤⠀⠀⠀⠤⠐⠀⠀⠀⠀⠀⠀⢸⡗⠈⠭⣿⣿⣿⣿⡿⢌⠣⡀⡐⢈⠃⠚⠦⣉⠂⠣⠜⡄⢋ ]],
			[[ ⣜⣷⢻⡜⣯⣾⡞⣥⣓⢾⡽⢎⡷⢯⡷⣯⢟⣽⠃⣸⠁⠀⡼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡄⢹⣿⣿⣿⣿⢃⡮⡑⢰⢠⣂⡜⣦⡴⣱⣎⣴⣩⡜⣦ ]],
			[[ ⣿⣯⢷⡻⣏⣷⣟⠶⣙⠮⡙⢪⠜⣯⢽⣯⣿⠃⠄⢃⣠⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣾⣿⣿⣿⡇⠢⢡⡙⢦⡓⡼⣽⣾⣿⣿⣿⣿⣷⣿⣿ ]],
			[[ ⣿⡹⢇⡳⡹⣞⠘⡈⢅⠢⢁⠂⡘⠤⣋⣶⣡⠴⠚⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠰⡁⢆⠘⣡⠻⣽⣳⣿⣿⣿⣿⢿⣿⣿⣿ ]],
		    [[ ⢣⠝⡢⢍⠱⢈⣂⣌⡤⠦⠶⠶⠞⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⠛⠷⣭⣂⠌⢠⠓⡴⣻⣿⣿⣿⣿⣿⣿⣯⣿ ]],
			 [[ ⣇⢾⡱⠞⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⡇⠀⠀⠀⠉⠛⠳⠿⣶⣽⣿⣿⣿⣿⣿⣿⣿⣿ ]],
			}
		
			
			dashboard.section.buttons.val = {
				-- dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("space + fb", "  > Browse files", ":Telescope file_browser<CR>"),
				dashboard.button("space + fz", "  > Browse Directories", ":Telescope zoxide list<CR>"),
				-- dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
				dashboard.button("space + fr", "  > Recent", ":Telescope oldfiles<CR>"),
			}

			local function footer()
				return "Become Undeniable"
			end
			
			dashboard.section.footer.opts.hl = "Type"
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#FF5733"})
			
			dashboard.section.footer.val = footer()
			alpha.setup(dashboard.opts)
		end,
	  },
	  
	  {
		"Wansmer/treesj",
		keys = { "<space>m", "<space>j", "<space>s" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesj").setup({})
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({})
		end,
		opts = {},
	},
	
	{
		"echasnovski/mini.surround",
		opts = {
			custom_surroundings = nil,
			highlight_duration = 500,
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "sd", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			n_lines = 20,
			respect_selection_type = false,
			search_method = "cover",
			silent = false,
		},
	},
	
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	
	{
		-- adds function arg help while typing out functions!!!
		"hrsh7th/cmp-nvim-lsp-signature-help",
	},
	
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
    },

	{
		"hrsh7th/nvim-cmp",
        opts = function(_, opts)
              opts.sources = opts.sources or {}
              table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
              })
           end,
    	config = function()
			local luasnip = require("luasnip")

			luasnip.add_snippets("markdown", require("snippets.notes"))
			luasnip.add_snippets("text", require("snippets.notes"))
			luasnip.add_snippets("tex", require("snippets.latex"))
			-- Set up nvim-cmp.
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = false }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
					{ name = "nvim_lsp_signature_help" }, -- function arg popups while typing
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function() 
            require('lualine').setup {
              options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                  statusline = {},
                  winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                  statusline = 1000,
                  tabline = 1000,
                  winbar = 1000,
                  refresh_time = 16,
                  events = {
                    'WinEnter',
                    'BufEnter',
                    'BufWritePost',
                    'SessionLoadPost',
                    'FileChangedShellPost',
                    'VimResized',
                    'Filetype',
                    'CursorMoved',
                    'CursorMovedI',
                    'ModeChanged',
                  },
                }
              },
              sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype', getWords},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },              
              inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
              },
              tabline = {},
              winbar = {},
              inactive_winbar = {},
              extensions = {}
            }
        end,
    },
})
