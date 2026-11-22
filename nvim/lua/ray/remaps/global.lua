-- Buffer navigation
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- TEMPORARY: finish statement keymap
vim.keymap.set("i", "<C-;>", "<End>;<CR>", { desc = "Finish statement" })

vim.keymap.set("n", "==", function()
    vim.lsp.buf.format({ async = false })
end, { desc = "Format whole file" })
