local keymap = vim.keymap.set
local opts =  { noremap = true, silent = true }

keymap("n", "<SPACE>", "", opts)
vim.g.mapleader = " "
vim.g.maplocaleader = " "

keymap("i", "jk", "<Esc>", opts)

-- Go back & forward with C-o and C-i
keymap("n", "<C-i>", "<C-i>", opts)
keymap("n", "<C-o>", "<C-o>", opts)


-- Window movement using Alt/Option + hjkl
keymap("n", "<m-h>", "<C-w>h", opts)
keymap("n", "<m-j>", "<C-w>j", opts)
keymap("n", "<m-k>", "<C-w>k", opts)
keymap("n", "<m-l>", "<C-w>l", opts)



-- remaps next (ex. when searching) to next + bring to middle of screen
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- TODO: what does this do?
keymap("x", "p", [["_dP]])

keymap("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- Goto beginning & end of line with S-h & S-l
keymap({ "n", "o", "x" }, "<S-h>", "^", opts)
keymap({ "n", "o", "x" }, "<S-l>", "$", opts)

-- Move by visual lines to deal with soft-wrapping text
keymap({ "n", "x" }, "j", "gj", opts)
keymap({ "n", "x" }, "k", "gk", opts)

keymap("n", "<leader>w", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", opts)
