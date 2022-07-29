--[[
lvim is the global options object



Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "gruvbox-baby"
vim.opt.relativenumber = true
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")

-- override or add a default keymapping
lvim.keys.normal_mode = {
  -- quit editor
  ["<C-q>"] = ":lua require('lvim.utils.functions').smart_quit()<CR>",

  -- save buffer
  ["<C-s>"] = ":w<cr>",

  -- close buffer
  ["<C-w>"] = ":BufferKill<cr>",

  -- Tab switch buffer
  ["<C-l>"] = ":BufferLineCycleNext<cr>",
  ["<C-h>"] = ":BufferLineCyclePrev<cr>",

  -- Tab move buffer
  ["<C-k>"] = ":BufferLineMoveNext<cr>",
  ["<C-j>"] = ":BufferLineMovePrev<cr>",

  -- Comment line
  ["<C-/>"] = ":lua require('Comment.api').toggle_current_linewise()<cr>",

  -- File explorer
  ["<C-e>"] = ":NvimTreeFocus<cr>",

  -- Copy/Paste with system
  ["<y>"] = '"*y',
  ["<p>"] = '"*p',
}

-- unmap default leader key maps
lvim.builtin.which_key.mappings["e"] = {}
lvim.builtin.which_key.mappings["c"] = {}
lvim.builtin.which_key.mappings["/"] = {}

-- dap
lvim.builtin.dap.active = true

-- rust debug
-- local dap_install = require "dap-install"
-- dap_install.config("codelldb", {})
local dap = require('dap')
local dapui = require("dapui")
dapui.setup()

-- dap.adapters.lldb = {
--   type = 'executable',
--   command = '/usr/bin/lldb-vscode',
--   name = 'lldb'
-- }

-- dap.configurations.rust = {
--   {
--     name = 'Launch',
--     type = 'lldb',
--     request = 'launch',
--     -- program = '${relativeFileDirname}',
--     program = function()
--       os.execute('make test > test.txt')
--       os.execute('make debug > test.txt')
--       os.execute('sleep 2')
--       -- local file = assert(io.popen('echo $(cargo build)'))
--       local file = assert(io.popen('pwd && echo $(cargo build)'))
--       local output = file:read('*all')
--       file:close()
--       print(123123)
--       print(output)
--       print(321312)
--       local handle = io.popen('echo "${PWD##*/}"')
--       local result = handle:read("*a")
--       handle:close()
--       return vim.fn.getcwd() .. '/target/debug/' .. result:sub(1, -2)
--     end,
--     cwd = '${workspaceFolder}',
--     -- stopOnEntry = false,
--     stopOnEntry = true,
--     args = {},
--     options = {
--       initialize_timeout_sec = 100;
--     }
--   },
-- }
-- open dapui automatically when runnign debug
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Visual block multiline comment
vim.api.nvim_set_keymap("v", "<C-/>", "<ESC>:lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<cr>", { noremap = true, silent = true })

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Won't work with neovide
map("n", "<C-S-l>", ":BufferLineMoveNext<cr>", { silent = true })
map("n", "<C-S-h>", ":BufferLineMovePrev<cr>", { silent = true })

-- Nvimtree config

lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
  { key = "h", action = "close_node" },
  { key = "v", action = "vsplit" },
  { key = "C", action = "cd" },
  { ley = "<C-e>", action = "" },
}
lvim.builtin.nvimtree.setup.open_on_setup = true
lvim.builtin.nvimtree.setup.open_on_setup_file = true
lvim.builtin.nvimtree.setup.open_on_tab = true

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  --   -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  --   -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }



lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["q"] = { "<cmd>call QuickFixToggle()<CR>", "Toggle Quick Fix List" }
lvim.builtin.which_key.mappings["r"] = {
  name = "Rust",
  r = { ":RustRun<CR>", "Run" },
  d = { "<cmd>:lua require('rust-tools.debuggables').debuggables()<CR>", "Debug" },
  c = { "<cmd>:lua require'rust-tools.open_cargo_toml'.open_cargo_toml()<CR>", "Open Cargo Toml" },
  g = { "<cmd>:lua require'rust-tools.crate_graph'.view_crate_graph(backend, output)<CR>", "View crate graph" }
}


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettier",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--print-with=100", "--line-width=80" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact" },
  },
}

-- -- set additional linters
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  {
    --     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",
    --     ---@usage arguments to pass to the formatter
    --     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
  {
    command = "codespell",
    --     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}


vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

local extension_path = '/home/megahotel/codelldb/extension'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'


-- Additional Plugins
lvim.plugins = {
  {
    "luisiacc/gruvbox-baby",
    branch = "main",
  },
  { "rcarriga/nvim-dap-ui" },
  {
    "simrat39/rust-tools.nvim",
    branch = "modularize_and_inlay_rewrite",
    config = function()
      local lsp_installer_servers = require "nvim-lsp-installer.servers"
      local _, requested_server = lsp_installer_servers.get_server "rust_analyzer"
      require("rust-tools").setup({
        tools = {
          autoSetHints = true,
          hover_with_actions = true,
          hover_actions = {
            auto_focus = true,
          },
          runnables = {
            use_telescope = true,
          },
        },
        server = {
          cmd_env = requested_server._default_options.cmd_env,
          on_attach = require("lvim.lsp").common_on_attach,
          on_init = require("lvim.lsp").common_on_init,
          dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(
              codelldb_path, liblldb_path)
          },
          settings = {
            ["rust-analyzer"] = {
              lens = {
                enable = true,
              },
              checkOnSave = {
                allFeatures = true,
                overrideCommand = {
                  'cargo', 'clippy', '--workspace', '--message-format=json',
                  '--all-targets', '--all-features'
                }
              }
            }
          }
        },
      })
    end,
    ft = { "rust", "rs" },
  },
} -- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

-- Guifont
vim.o.guifont = "Fira Code:h11"


-- Neovide config
vim.cmd([[
if exists("g:neovide")
    let g:neovide_refresh_rate=180
    let g:neovide_floating_blur_amount_x = 2.0
    let g:neovide_floating_blur_amount_y = 2.0
    let g:neovide_cursor_antialiasing=v:true
    colorscheme gruvbox-baby

    " Gruvbox colorscheme
    " setup palette dictionary
    let s:gb = {}

    " fill it with absolute colors
    let s:gb.dark0_hard  = ['#1d2021', 234]     " 29-32-33
    let s:gb.dark0       = ['#282828', 235]     " 40-40-40
    let s:gb.dark0_soft  = ['#32302f', 236]     " 50-48-47
    let s:gb.dark1       = ['#3c3836', 237]     " 60-56-54
    let s:gb.dark2       = ['#504945', 239]     " 80-73-69
    let s:gb.dark3       = ['#665c54', 241]     " 102-92-84
    let s:gb.dark4       = ['#7c6f64', 243]     " 124-111-100
    let s:gb.dark4_256   = ['#7c6f64', 243]     " 124-111-100

    let s:gb.gray_245    = ['#928374', 245]     " 146-131-116
    let s:gb.gray_244    = ['#928374', 244]     " 146-131-116

    let s:gb.light0_hard = ['#f9f5d7', 230]     " 249-245-215
    let s:gb.light0      = ['#fbf1c7', 229]     " 253-244-193
    let s:gb.light0_soft = ['#f2e5bc', 228]     " 242-229-188
    let s:gb.light1      = ['#ebdbb2', 223]     " 235-219-178
    let s:gb.light2      = ['#d5c4a1', 250]     " 213-196-161
    let s:gb.light3      = ['#bdae93', 248]     " 189-174-147
    let s:gb.light4      = ['#a89984', 246]     " 168-153-132
    let s:gb.light4_256  = ['#a89984', 246]     " 168-153-132

    let s:gb.bright_red     = ['#fb4934', 167]     " 251-73-52
    let s:gb.bright_green   = ['#b8bb26', 142]     " 184-187-38
    let s:gb.bright_yellow  = ['#fabd2f', 214]     " 250-189-47
    let s:gb.bright_blue    = ['#83a598', 109]     " 131-165-152
    let s:gb.bright_purple  = ['#d3869b', 175]     " 211-134-155
    let s:gb.bright_aqua    = ['#8ec07c', 108]     " 142-192-124
    let s:gb.bright_orange  = ['#fe8019', 208]     " 254-128-25

    let s:gb.neutral_red    = ['#cc241d', 124]     " 204-36-29
    let s:gb.neutral_green  = ['#98971a', 106]     " 152-151-26
    let s:gb.neutral_yellow = ['#d79921', 172]     " 215-153-33
    let s:gb.neutral_blue   = ['#458588', 66]      " 69-133-136
    let s:gb.neutral_purple = ['#b16286', 132]     " 177-98-134
    let s:gb.neutral_aqua   = ['#689d6a', 72]      " 104-157-106
    let s:gb.neutral_orange = ['#d65d0e', 166]     " 214-93-14

    let s:gb.faded_red      = ['#9d0006', 88]      " 157-0-6
    let s:gb.faded_green    = ['#79740e', 100]     " 121-116-14
    let s:gb.faded_yellow   = ['#b57614', 136]     " 181-118-20
    let s:gb.faded_blue     = ['#076678', 24]      " 7-102-120
    let s:gb.faded_purple   = ['#8f3f71', 96]      " 143-63-113
    let s:gb.faded_aqua     = ['#427b58', 66]      " 66-123-88
    let s:gb.faded_orange   = ['#af3a03', 130]     " 175-58-3


    let s:bg0  = s:gb.dark0
    let s:bg0  = s:gb.dark0_soft

    let s:bg1  = s:gb.dark1
    let s:bg2  = s:gb.dark2
    let s:bg3  = s:gb.dark3
    let s:bg4  = s:gb.dark4

    let s:gray = s:gb.gray_245

    let s:fg0 = s:gb.light0
    let s:fg1 = s:gb.light1
    let s:fg2 = s:gb.light2
    let s:fg3 = s:gb.light3
    let s:fg4 = s:gb.light4

    let s:fg4_256 = s:gb.light4_256

    let s:red    = s:gb.bright_red
    let s:green  = s:gb.bright_green
    let s:yellow = s:gb.bright_yellow
    let s:blue   = s:gb.bright_blue
    let s:purple = s:gb.bright_purple
    let s:aqua   = s:gb.bright_aqua
    let s:orange = s:gb.bright_orange
    let s:bg0[1]    = 0
    let s:fg4[1]    = 7
    let s:gray[1]   = 8
    let s:red[1]    = 9
    let s:green[1]  = 10
    let s:yellow[1] = 11
    let s:blue[1]   = 12
    let s:purple[1] = 13
    let s:aqua[1]   = 14
    let s:fg1[1]    = 15

    let g:terminal_color_0 = s:bg0[0]
    let g:terminal_color_8 = s:gray[0]

    let g:terminal_color_1 = s:gb.neutral_red[0]
    let g:terminal_color_9 = s:red[0]

    let g:terminal_color_2 = s:gb.neutral_green[0]
    let g:terminal_color_10 = s:green[0]

    let g:terminal_color_3 = s:gb.neutral_yellow[0]
    let g:terminal_color_11 = s:yellow[0]

    let g:terminal_color_4 = s:gb.neutral_blue[0]
    let g:terminal_color_12 = s:blue[0]

    let g:terminal_color_5 = s:gb.neutral_purple[0]
    let g:terminal_color_13 = s:purple[0]

    let g:terminal_color_6 = s:gb.neutral_aqua[0]
    let g:terminal_color_14 = s:aqua[0]

    let g:terminal_color_7 = s:fg4[0]
    let g:terminal_color_15 = s:fg1[0]

endif
]])
