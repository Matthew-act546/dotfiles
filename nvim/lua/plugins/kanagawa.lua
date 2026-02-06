return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,  -- enable compiling for faster startup
        undercurl = true, -- enable undercurl
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = false },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        -- no custom palette; use standard Kanagawa wave colors
        colors = {},
        overrides = function(colors)
          local theme = colors.theme
          return {
            -- floating windows
            NormalFloat                = { bg = "none" },
            FloatBorder                = { bg = "none" },

            -- Neo-tree
            NeoTreeNormal              = { bg = theme.ui.bg },
            NeoTreeNormalNC            = { bg = theme.ui.bg_m1 },
            NeoTreeVertSplit           = { bg = theme.ui.bg, fg = theme.ui.bg_m1 },

            -- Telescope
            TelescopeTitle             = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal      = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder      = { bg = theme.ui.bg_p1, fg = theme.ui.bg_p1 },
            TelescopeResultsNormal     = { fg = theme.fg_dim, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal     = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder     = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

            -- Popup menu
            Pmenu                      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel                   = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar                  = { bg = theme.ui.bg_m1 },
            PmenuThumb                 = { bg = theme.ui.bg_p2 },

            -- LSP diagnostics
            DiagnosticVirtualTextHint  = { fg = theme.diag.hint, bg = theme.ui.bg_m3 },
            DiagnosticVirtualTextInfo  = { fg = theme.diag.info, bg = theme.ui.bg_m3 },
            DiagnosticVirtualTextWarn  = { fg = theme.diag.warning, bg = theme.ui.bg_m3 },
            DiagnosticVirtualTextError = { fg = theme.diag.error, bg = theme.ui.bg_m3 },

            -- Syntax
            String                     = { fg = theme.syn.string, italic = true },
            Function                   = { fg = theme.syn["function_"], bold = false },
            Keyword                    = { fg = theme.syn.keyword, italic = true },
            Statement                  = { fg = theme.syn.statement, bold = false },
            Type                       = { fg = theme.syn.type },
            Comment                    = { fg = theme.syn.comment, italic = true },
          }
        end,
        theme = "wave",
        background = { dark = "wave", light = "lotus" },
      })

      vim.cmd("colorscheme kanagawa")
    end,
  }
}
