local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      -- Neovim setup for init.lua & plugin development
      "folke/neodev.nvim"
    },
  },
}

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr}
  local keymap = vim.api.nvim_buf_set_keymap

  keymap(bufnr, "n", "gD", vim.lsp.buf.declaration, opts)
  keymap(bufnr, "n", "gd", vim.lsp.buf.definition, opts)
  keymap(bufnr, "n", "K", vim.lsp.buf.hover, opts)
  keymap(bufnr, "n", "gI", vim.lsp.buf.implementation, opts)
  keymap(bufnr, "n", "gr", vim.lsp.buf.references, opts)
  keymap(bufnr, "n", "gl", vim.diagnostic.open_float, opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  if client.supports_method "textDocument/inlayHint" then
    vim.lsp.inlay_hint.enable(bufnr, true)
  end
end


function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupoprt = true
  return capabilities
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
end

function M.config() 
  local wk = require "which-key"
  local mappings = {
    ["c"] = {
      name = "code",
      ["b"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "code action" },
    }
  }
  local opts = {
    mode = "n",
    prefix = "<leader>"
  }
  wk.register(mappings, opts)

  local lspconfig = require "lspconfig"
  local icons = require "user.icons"

  local servers = {
    "lua_ls",
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
      },
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    lspconfig[server].setup(opts)
  end
end

return M
