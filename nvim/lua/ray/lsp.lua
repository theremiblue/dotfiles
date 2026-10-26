vim.lsp.enable({
    'clangd',
    'lua_ls',
    'rust_analyzer',
    'cmake',
    'pyright',
    'ts_ls',
    'elixirls',
    'jdtls',
    'kotlin_lsp',
    'zls',
})

vim.diagnostic.config({
    underline = true,
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ray.lsp", { clear = true }),
    callback = function(ev)
        local bufnr = ev.buf
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
                buffer = bufnr,
                silent = true,
                desc = "LSP: " .. desc,
            })
        end

        -- Keep Neovim 0.11+ defaults for:
        -- gra, gri, grn, grr, grt, grx, gO, <C-s>, K

        -- Add only muscle-memory aliases.
        map("n", "gd", vim.lsp.buf.definition, "go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "go to declaration")

        map("n", "dl", vim.diagnostic.open_float, "line diagnostic")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "next diagnostic")

        map("n", "<leader>dq", vim.diagnostic.setqflist, "diagnostics to quickfix")
    end,
})
