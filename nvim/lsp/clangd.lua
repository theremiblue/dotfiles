local filetypes = require("ray.filetypes")

return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--enable-config",
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "--completion-style=detailed"
    },
    filetypes = filetypes.C_CPP_FILETYPES,
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
    },
}
