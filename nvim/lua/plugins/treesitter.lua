return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    branch = "main",
    config = function()
      -- local config = require("nvim-treesitter.configs")
      -- config.setup({
      --   auto_install = true,
      --   highlight = { enable = true },
      --   indent = { enable = true },
      --   context_commentstring = {
      --     enabled = true,
      --     enable_autocmd = false,
      --   },
      --   refactor = {
      --     smart_rename = {
      --       enable = true,
      --       keymaps = {
      --         smart_rename = "grr",
      --       },
      --     },
      --     -- highlight_current_scope = { enable = true },
      --   },
      -- })
    end,
  },
  -- {
  -- 	"folke/twilight.nvim",
  -- },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    lazy = true,
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
        },
      })
    end,
  },
}
