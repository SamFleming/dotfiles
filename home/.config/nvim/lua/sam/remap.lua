vim.g.mapleader = "\\"
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Q", "<nop>")

-- Navigate quickfix items
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix list item"})
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix list item"})

