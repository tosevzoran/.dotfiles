return {
  "neovim/nvim-lspconfig",

  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    { "j-hui/fidget.nvim", opts = {} },
  },

  config = function()
    ---------------------------------------------------------------------------
    -- LSP attach
    ---------------------------------------------------------------------------

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),

      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

        map("K", vim.lsp.buf.hover, "Hover Documentation")

        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        map("<leader>[", vim.diagnostic.open_float, "Open diagnostics")

        map("[d", vim.diagnostic.goto_prev, "Diagnostics prev")

        map("]d", vim.diagnostic.goto_next, "Diagnostics next")

        -----------------------------------------------------------------------
        -- Highlight references under cursor
        -----------------------------------------------------------------------

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight-" .. event.buf, { clear = true })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = highlight_group,
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    ---------------------------------------------------------------------------
    -- Capabilities
    ---------------------------------------------------------------------------

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    ---------------------------------------------------------------------------
    -- LSP servers
    ---------------------------------------------------------------------------

    local servers = {
      html = {},

      gopls = {},

      ts_ls = {},

      cssls = {},

      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },

            workspace = {
              checkThirdParty = false,

              library = {
                "${3rd}/luv/library",
                unpack(vim.api.nvim_get_runtime_file("", true)),
              },
            },

            completion = {
              callSnippet = "Replace",
            },

            diagnostics = {
              globals = {
                "vim",
              },
            },
          },
        },
      },
    }

    ---------------------------------------------------------------------------
    -- Mason
    ---------------------------------------------------------------------------

    require("mason").setup()

    ---------------------------------------------------------------------------
    -- Non-LSP tools
    ---------------------------------------------------------------------------

    require("mason-tool-installer").setup({
      ensure_installed = {
        "stylua",
      },
    })

    ---------------------------------------------------------------------------
    -- Configure LSPs using Neovim 0.11+ API
    ---------------------------------------------------------------------------

    for server_name, server in pairs(servers) do
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

      vim.lsp.config(server_name, server)
    end

    ---------------------------------------------------------------------------
    -- Install + automatically enable LSPs
    ---------------------------------------------------------------------------

    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = true,
    })
  end,
}
