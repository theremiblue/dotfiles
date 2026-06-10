local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

local function gmap(key, desc, callback)
    vim.keymap.set("n", "<leader>v" .. key, callback, {
        desc = "Git - " .. desc,
        silent = true,
    })
end

vim.keymap.set("n", "]h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
    else
        gitsigns.nav_hunk("next")
    end
end, { desc = "Git - Next hunk", silent = true })

vim.keymap.set("n", "[h", function()
    if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
    else
        gitsigns.nav_hunk("prev")
    end
end, { desc = "Git - Previous hunk", silent = true })

gmap("h", "Preview hunk inline", gitsigns.preview_hunk_inline)

gmap("s", "Stage hunk", gitsigns.stage_hunk)
gmap("r", "Reset hunk", gitsigns.reset_hunk)

gmap("b", "Blame cursor", function()
    gitsigns.blame_line({ full = true })
end)

gmap("f", "Blame file", gitsigns.blame)

gmap("d", "Diff this", function()
    vim.cmd("tab split")
    gitsigns.diffthis(nil, { vertical = true })
end)

-- For diffs we're opening new tab
-- This way it's easy to exit diff mode by closing the tab
gmap("dp", "Diff this against previous commit", function()
    vim.cmd("tab split")
    gitsigns.diffthis("~", { vertical = true })
end)

gmap("dc", "Close diff", function()
    vim.cmd("tabclose")
end)

gmap("q", "Hunks to quickfix", gitsigns.setqflist)
gmap("Q", "All hunks to quickfix", function()
    gitsigns.setqflist("all")
end)

-- Toggles
vim.keymap.set(
    "n", "<leader>tb", gitsigns.toggle_current_line_blame,
    { desc = "Toggle: Git line blame", silent = true }
)
vim.keymap.set(
    "n", "<leader>tw", gitsigns.toggle_word_diff,
    { desc = "Toggle: Git word diff", silent = true }
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitsigns-blame",
    callback = function(event)
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
            buffer = event.buf,
            silent = true,
            desc = "Close blame",
        })

        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {
            buffer = event.buf,
            silent = true,
            desc = "Close blame",
        })
    end,
})

