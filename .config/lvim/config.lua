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
vim.opt.timeoutlen = 150


-- Status line config
local components = require("lvim.core.lualine.components")
local function deepcopy(orig, copies)
  copies = copies or {}
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    if copies[orig] then
      copy = copies[orig]
    else
      copy = {}
      copies[orig] = copy
      for orig_key, orig_value in next, orig, nil do
        copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
      end
      setmetatable(copy, deepcopy(getmetatable(orig), copies))
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

local filepath = deepcopy(components.progress);
filepath.fmt = function()
  return "%F"
end

local progress = components.progress;
progress.fmt = function()
  return "%l:%c/%L"
end

progress.color = { gui = "bold" }
lvim.builtin.lualine.sections.lualine_a = { components.branch, progress }
lvim.builtin.lualine.sections.lualine_b = { components.diff, filepath }
lvim.builtin.lualine.sections.lualine_c = {}
lvim.builtin.lualine.sections.lualine_y = {}
lvim.builtin.lualine.sections.lualine_z = {}

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")

-- override or add a default keymapping
lvim.keys.normal_mode = {
  -- quit editor
  ["<C-q>"] = ":q<cr>",

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
  ["<C-/>"] = ":lua require('Comment.api').toggle.linewise.current()<cr>",

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
local dap = require('dap')
local dapui = require("dapui")
dapui.setup()

dap.adapters.node2 = function(cb, config)
  if config.preLaunchTask then
    vim.fn.system(config.preLaunchTask)
  end
  local adapter = {
    type = "executable",
    command = "node",
    args = { os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js' },
  }
  cb(adapter)
end

local node = {
  name = 'Launch',
  type = 'node2',
  request = 'launch',
  program = '${file}',
  cwd = vim.fn.getcwd(),
  sourceMaps = true,
  protocol = 'inspector',
  console = 'integratedTerminal',
}

local node_attach = {
  -- For this to work you need to make sure the node process is started with the `--inspect` flag.
  name = 'Attach to process',
  type = 'node2',
  request = 'attach',
  processId = require 'dap.utils'.pick_process,
}

dap.configurations.typescript = { node, node_attach }
dap.configurations.javascript = { node, node_attach }

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


function MapKey(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Won't work with neovide
MapKey("n", "<C-S-l>", ":BufferLineMoveNext<cr>", { silent = true })
MapKey("n", "<C-S-h>", ":BufferLineMovePrev<cr>", { silent = true })

-- Visual block multiline comment
MapKey("v", "<C-/>", "<ESC>:lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { silent = true })

-- Scrolling function
MapKey("n", "<C-d>", "15j")
MapKey("n", "<C-u>", "15k")

-- Nvimtree config
if lvim.builtin.nvimtree.setup.view.mappings == nil then
  lvim.builtin.nvimtree.setup.view.mappings = {}
end
lvim.builtin.nvimtree.setup.view.mappings.list = {
  { key = { "l", "<CR>", "o" }, action = "edit",      mode = "n" },
  { key = "h",                  action = "close_node" },
  { key = "v",                  action = "vsplit" },
  { key = "C",                  action = "cd" },
  { ley = "<C-e>",              action = "" },
}
-- lvim.builtin.nvimtree.setup.open_on_setup = true
-- lvim.builtin.nvimtree.setup.open_on_setup_file = true
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
lvim.builtin.which_key.mappings["t"] = { "<cmd>TroubleToggle<CR>", "Toggle Trouble" }
lvim.builtin.which_key.mappings["r"] = {
  name = "Rust",
  r = { ":RustRun<CR>", "Run" },
  d = { "<cmd>:lua require('rust-tools.debuggables').debuggables()<CR>", "Debug" },
  c = { "<cmd>:lua require'rust-tools.open_cargo_toml'.open_cargo_toml()<CR>", "Open Cargo Toml" },
  g = { "<cmd>:lua require'rust-tools.crate_graph'.view_crate_graph(backend, output)<CR>", "View crate graph" }
}
lvim.builtin.which_key.mappings["m"] = {
  name = "Miscellaneous",
  t = {
    name = "TODO list",
    d = { ":TodoTelescope<CR>", "Telescope List" },
  },
  p = { ":Glow<CR>", "Preview Markdown" },
}
lvim.builtin.which_key.mappings["o"] = {
  name = "Obsidian",
  o = { ":ObsidianOpen<CR>", "Open Obsidian application" },
  n = { ":ObsidianNew<CR>", "New Note" },
  s = {
    name = "Search",
    f = { ":ObsidianQuickSwitch<CR>", "Search by note name" },
    t = { ":ObsidianSearch<CR>", "Search by note content" },
  },
  g = {
    name = "Go to",
    d = { ":ObsidianFollowLink<CR>", "Follow link" },
    r = { ":ObsidianBacklinks<CR>", "Get references" },
  },
  d = {
    name = "Daily",
    n = { ":ObsidianToday<CR>", "New daily note" },
    y = { ":ObsidianYesterday<CR>", "New yesterday's daily note" },
  },
  t = { ":ObsidianTemplate<CR>", "Insert template" },
  p = { ":ObsidianWorkspace<CR>", "Switch to another workplace" },
}
lvim.builtin.which_key.vmappings["o"] = {
  name = "Obsidian",
  l = {
    name = "Link",
    e = { ":ObsidianLink<CR>", "Link by note name" },
    r = { ":ObsidianLink ", "Link with note name" },
    n = { ":ObsidianLinkNew<CR>", "Link with new note" },
  },
}
lvim.builtin.which_key.mappings["g"]["l"] = { ":GitBlameToggle<CR>", "Blame" }


MapKey("n", "U", "<CMD>RustCodeAction<CR>", { silent = true, desc = "Code action" })


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"

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


vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer", "terraformls" })

-- Terraform configuration
require 'lspconfig'.terraformls.setup {}
require 'lspconfig'.tflint.setup {}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})


local extension_path = '/home/megahotel/codelldb/extension'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

lvim.builtin.nvimtree.setup["git"]["timeout"] = 60000

-- Additional Plugins
lvim.plugins = {
  {
    "luisiacc/gruvbox-baby",
    branch = "main",
  },
  { "rcarriga/nvim-dap-ui" },
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust", "rs" }, -- IMPORTANT: re-enabling this seems to break inlay-hints
    config = function()
      require("rust-tools").setup {
        tools = {
          executor = require("rust-tools/executors").termopen,
          reload_workspace_from_cargo_toml = true,
          inlay_hints = {
            auto = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
            max_len_align = false,
            max_len_align_padding = 1,
            right_align = false,
            right_align_padding = 7,
            highlight = "Comment",
          },
          hover_actions = {
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
            auto_focus = true,
          },
        },
        server = {
          on_init = require("lvim.lsp").common_on_init,
          on_attach = function(_, _)
            MapKey("n", "gd", "<CMD>lua vim.lsp.buf.definition()<CR>", { silent = true, desc = "Goto definition" })
            MapKey("n", "gD", "<CMD>lua vim.lsp.buf.declaration()<CR>", { silent = true, desc = "Goto declaration" })
            MapKey("n", "gr", "<CMD>lua vim.lsp.buf.references()<CR>", { silent = true, desc = "Goto references" })
            MapKey("n", "gI", "<CMD>lua vim.lsp.buf.implementation()<CR>",
              { silent = true, desc = "Goto implementation" })
            MapKey("n", "gs", "<CMD>lua vim.lsp.buf.signature_help()<CR>",
              { silent = true, desc = "Show signature help" })
            vim.keymap.set("n", "gp",
              function()
                require("lvim.lsp.peek").Peek "definition"
              end,
              { silent = true, desc = "Peek Definition" })
            vim.keymap.set("n", "gl",
              function()
                local config = lvim.lsp.diagnostics.float
                config.scope = "line"
                vim.diagnostic.open_float(0, config)
              end,
              { silent = true, desc = "Show line diagnostics" })
            MapKey("n", "K", "<CMD>RustHoverActions<CR>", { silent = true, desc = "Show hover" })
            MapKey("n", "U", "<CMD>RustCodeAction<CR>", { silent = true, desc = "Code action" })
          end,
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
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    init = function()
      vim.g.indent_blankline_char = "▏"
      vim.opt.list = true
    end,
    config = function()
      require("indent_blankline").setup {
        enabled = true,
        bufname_exclude = { "README.md" },
        buftype_exclude = { "terminal", "nofile" },
        filetype_exclude = {
          "alpha",
          "log",
          "gitcommit",
          "dapui_scopes",
          "dapui_stacks",
          "dapui_watches",
          "dapui_breakpoints",
          "dapui_hover",
          "LuaTree",
          "dbui",
          "UltestSummary",
          "UltestOutput",
          "vimwiki",
          "markdown",
          "json",
          "txt",
          "vista",
          "NvimTree",
          "git",
          "TelescopePrompt",
          "undotree",
          "flutterToolsOutline",
          "org",
          "orgagenda",
          "help",
          "startify",
          "dashboard",
          "packer",
          "neogitstatus",
          "NvimTree",
          "Outline",
          "Trouble",
          "lspinfo",
          "", -- for all buffers without a file type
        },
        space_char_blankline = " ",
        use_treesitter = true,
        show_foldtext = false,
        show_current_context = true,
        show_current_context_start = true,
      }
    end,
  },
  {
    'ethanholz/nvim-lastplace',
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "ellisonleao/glow.nvim"
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
  },
  {
    "itchyny/vim-cursorword",
    event = { "BufEnter", "BufNewFile" },
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  },
  {
    "ggandor/leap.nvim",
    name = "leap",
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterBlue',
          'RainbowDelimiterYellow',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
        },
      }
    end
  },
  {
    "epwalsh/obsidian.nvim",
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre " .. vim.fn.expand "~" .. "/obsidian/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/obsidian/**.md"
    },
    config = function()
      require("obsidian").setup {
        note_id_func = function()
          return "new_note.md"
        end,
        disable_frontmatter = true
      }
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    'cameron-wags/rainbow_csv.nvim',
    config = function()
      require 'rainbow_csv'.setup()
    end,
    lazy = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon'
    }
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = false }
    end,
  },
}

-- Leap
MapKey("n", "f", "<Plug>(leap-forward-to)", { silent = true })
MapKey("n", "F", "<Plug>(leap-backward-to)", { silent = true })

-- Enable treesitter-rainbow
lvim.builtin.treesitter.rainbow.enable = true

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
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


require('nvim-lastplace').setup {
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  lastplace_open_folds = true
}

-- For obsidian.nvim
require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline", ... },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
})


-- Guifont
vim.o.guifont = "Fira Code:h15"

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


-- Enable netrw for remote vim
lvim.builtin.nvimtree.setup.disable_netrw = false
lvim.builtin.nvimtree.setup.hijack_netrw = false



-- PATCH: in order to address the message:
-- vim.treesitter.query.get_query() is deprecated, use vim.treesitter.query.get() instead. :help deprecated
--   This feature will be removed in Nvim version 0.10
-- local orig_notify = vim.notify
-- local filter_notify = function(text, level, opts)
--   -- more specific to this case
--   if type(text) == "string" and (string.find(text, "get_query", 1, true) or string.find(text, "get_node_text", 1, true)) then
--     -- for all deprecated and stack trace warnings
--     -- if type(text) == "string" and (string.find(text, ":help deprecated", 1, true) or string.find(text, "stack trace", 1, true)) then
--     return
--   end
--   orig_notify(text, level, opts)
-- end
-- vim.notify = filter_notify
