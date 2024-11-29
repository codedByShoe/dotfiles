return {
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "seblj/roslyn.nvim",
    ft = "cs",
    opts = {
      config = {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        compile = false, -- enable compiling the colorscheme
        undercurl = true, -- enable undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = true, -- do not set background color
        dimInactive = false, -- dim inactive window `:h hl-NormalNC`
        terminalColors = true, -- define vim.g.terminal_color_{0,17}
        colors = { -- add/modify theme and palette colors
          palette = {},
          theme = {
            wave = {},
            lotus = {},
            dragon = {},
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        theme = "dragon", -- Load "wave" theme when 'background' option is not set
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "lotus",
        },
      })
      -- setup must be called before loading
      -- vim.cmd("colorscheme kanagawa")
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  {
    "hrsh7th/cmp-cmdline",
    config = function()
      local cmp = require("cmp")
      -- `/` cmdline setup.
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            },
          },
        }),
      })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = function()
      return {}
    end,
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { "node_modules", "vendor", "__pycache__", "obj" },
      },
    },
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        bashls = {},
        -- omnisharp = {
        --   cmd = { "dotnet", "/home/codedbyshoe/.omnisharp/OmniSharp.dll" },
        --   settings = {
        --     FormattingOptions = {
        --       -- Enables support for reading code style, naming convention and analyzer
        --       -- settings from .editorconfig.
        --       EnableEditorConfigSupport = true,
        --       -- Specifies whether 'using' directives should be grouped and sorted during
        --       -- document formatting.
        --       OrganizeImports = true,
        --     },
        --     MsBuild = {
        --       -- If true, MSBuild project system will only load projects for files that
        --       -- were opened in the editor. This setting is useful for big C# codebases
        --       -- and allows for faster initialization of code navigation features only
        --       -- for projects that are relevant to code that is being edited. With this
        --       -- setting enabled OmniSharp may load fewer projects and may thus display
        --       -- incomplete reference lists for symbols.
        --       LoadProjectsOnDemand = nil,
        --     },
        --     RoslynExtensionsOptions = {
        --       inlayHintsOptions = {
        --         enableForParameters = true,
        --         forLiteralParameters = true,
        --         forIndexerParameters = true,
        --         forObjectCreationParameters = true,
        --         forOtherParameters = true,
        --         suppressForParametersThatDifferOnlyBySuffix = false,
        --         suppressForParametersThatMatchMethodIntent = false,
        --         suppressForParametersThatMatchArgumentName = false,
        --         enableForTypes = true,
        --         forImplicitVariableTypes = true,
        --         forLambdaParameterTypes = true,
        --         forImplicitObjectCreation = true,
        --       },
        --       -- Enables support for roslyn analyzers, code fixes and rulesets.
        --       EnableAnalyzersSupport = nil,
        --       -- Enables support for showing unimported types and unimported extension
        --       -- methods in completion lists. When committed, the appropriate using
        --       -- directive will be added at the top of the current file. This option can
        --       -- have a negative impact on initial completion responsiveness,
        --       -- particularly for the first few completion sessions after opening a
        --       -- solution.
        --       EnableImportCompletion = true,
        --       -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        --       -- true
        --       AnalyzeOpenDocumentsOnly = nil,
        --     },
        --     Sdk = {
        --       -- Specifies whether to include preview versions of the .NET SDK when
        --       -- determining which version to use for project loading.
        --       IncludePrereleases = true,
        --     },
        --   },
        -- },
        templ = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
        },
        cssls = {},
        sqlls = {
          cmd = { "sql-language-server", "up", "--method", "stdio" },
          filetypes = { "sql", "mysql" },
        },
        tsserver = {
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        },
        html = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
          settings = {
            format = {
              indentInnerHtml = true,
            },
          },
          filetypes = { "html", "tmpl", "hbs", "gohtml", "templ", "htmldjango", "phtml", "cshtml", "razor" },
        },
        jsonls = {},
        intelephense = {
          cmd = { "intelephense", "--stdio" },
          filetypes = { "php" },
        },
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            hint = {
              enable = true,
              arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
              await = true,
              paramName = "Disable", -- "All" | "Literal" | "Disable"
              paramType = false,
              semicolon = "Disable", -- "All" | "SameLine" | "Disable"
              setType = false,
            },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
        tailwindcss = {
          filetypes = {
            "astro",
            "astro-markdown",
            "blade",
            "tmpl",
            "gohtml",
            "html",
            "liquid",
            "markdown",
            "mdx",
            "phtml",
            "twig",
            "css",
            "ejs",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "templ",
            "cshtml",
            "razor",
          },
        },
        marksman = {
          filetypes = { "markdown", "markdown.mdx" },
        },
        emmet_ls = {
          filetypes = {
            "html",
            "htmldjango",
            "twig",
            "hbs",
            "gohtml",
            "templ",
            "typescriptreact",
            "blade",
            "phtml",
            "javascriptreact",
            "cshtml",
            "razor",
          },
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
              },
            },
          },
        },
      },
    },
  },

  -- for typescript, LazyVim also includes extra specs to properly setup lspconfig,
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.sql" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.vscode" },
  { import = "lazyvim.plugins.extras.util.rest" },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "go",
        "php",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "http",
        "graphql",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local theme = function()
        local colors = {
          darkgray = "#16161d",
          gray = "#727169",
          white = "#DCD7BA",
          innerbg = nil,
          outerbg = nil,
          normal = "#7E9CD8",
          insert = "#98bb6c",
          visual = "#FF9E3B",
          replace = "#e46876",
          command = "#e6c384",
        }
        return {
          inactive = {
            a = { fg = colors.white, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
          visual = {
            a = { fg = colors.visual, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
          replace = {
            a = { fg = colors.darkgray, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
          normal = {
            a = { fg = colors.normal, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
          insert = {
            a = { fg = colors.insert, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
          command = {
            a = { fg = colors.command, bg = colors.outerbg, gui = "bold" },
            b = { fg = colors.white, bg = colors.outerbg },
            c = { fg = colors.white, bg = colors.innerbg },
          },
        }
      end

      return {
        options = {
          component_separators = { left = " ", right = " " },
          section_separators = { left = " ", right = " " },
          theme = theme,
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
        },

        extensions = { "lazy", "toggleterm", "mason", "neo-tree", "trouble" },
      }
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    opts = function()
      require("transparent").setup({
        groups = {
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer",
        },
      })
    end,
  },
  {
    "d7omdev/nuget.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("nuget").setup()
    end,
  },

  -- add any tools you want to have installed below
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "prettier",
        "ruff",
      },
    },
  },
}
