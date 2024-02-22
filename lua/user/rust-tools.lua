local M = {
  "simrat39/rust-tools.nvim",
}

function M.config()
  local rt = require('rust-tools')
  rt.setup({
    server = {
      on_attach = function(_, bufnr)
        local wk = require("which-key")

        local mappings = {
          ["c"] = {
            name = "code",
          }
        }
        local opts = {
          mode = "n",
          buffer = bufnr,
          prefix = "<leader>"
        }

        wk.register(mappings, opts)

      end
    }
  })
end


return M
