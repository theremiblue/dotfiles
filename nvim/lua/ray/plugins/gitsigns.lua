local gitsigns = require("gitsigns")

gitsigns.setup({
    signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },

    signs_staged_enable = true,
    signcolumn = true,
    numhl = true,
    linehl = false,
    word_diff = false,

    watch_gitdir = {
        follow_files = true,
    },

    auto_attach = true,
    attach_to_untracked = false,

    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
    },

    current_line_blame_formatter = "<abbrev_sha> <author>, <author_time:%R> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    max_file_length = 40000,

    preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
        border = "rounded",
    },
})

-- Override colors, I don't need theme colors here
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        vim.api.nvim_set_hl(0, "GitSignsAdd",      { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "GitSignsChange",   { link = "DiffChange" })
        vim.api.nvim_set_hl(0, "GitSignsDelete",   { link = "DiffDelete" })
        vim.api.nvim_set_hl(0, "GitSignsAddLn",    { link = "DiffAdd" })
        vim.api.nvim_set_hl(0, "GitSignsChangeLn", { link = "DiffChange" })
        vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { link = "DiffDelete" })
    end,
})

