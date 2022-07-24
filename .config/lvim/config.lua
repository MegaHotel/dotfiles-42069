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
