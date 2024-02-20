local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
    },
  }
}

function M.config()
  require("telescope").load_extension("harpoon")
  local wk = require "which-key"

  local mappings = {
    ["m"] = {
      name = "mark",
      ["m"] = { "<cmd>lua require('user.harpoon').mark_file()<cr>", "mark file"},
      ["<tab>"] = { "<cmd>Telescope harpoon marks<cr>", "view marks"},
      ["d"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "delete marks"}
    }
  }

  local opts = {
    mode = "n",
    prefix = "<leader>"
  }

  wk.register(mappings, opts)
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end
return M
