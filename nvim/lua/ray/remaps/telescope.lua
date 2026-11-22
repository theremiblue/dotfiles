local builtin = require("telescope.builtin")

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local git = require("ray.git")

-- Shorthand to map telescope remaps as <leader>f<KEY>
local function tmap(key, desc, callback)
    local options = {
        desc = "Find - " .. desc,
    }

    vim.keymap.set('n', '<leader>f' .. key, callback, options)
end

-- Simple remaps
tmap('f', "Files", builtin.find_files)
tmap('g', "Grep",  builtin.live_grep)

-- TODO: using it?
tmap('b', "Buffers", builtin.buffers)

tmap('h', "Help tags", builtin.help_tags)
tmap('k', "Keymaps",   builtin.keymaps)

tmap('s', "Document Symbols",  builtin.lsp_document_symbols)
tmap('S', "Workspace Symbols", builtin.lsp_workspace_symbols)
vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set('n', 'gS', builtin.lsp_workspace_symbols, { desc = "Workspace Symbols" })
tmap('d', "Diagnostics",       builtin.diagnostics)

-- Custom remaps
local function edit_neovim_config()
    builtin.live_grep {
        cwd = vim.fn.stdpath("config")
    }
end

local function commit_from_telescope_entry(entry)
  if not entry or type(entry.value) ~= "string" or entry.value == "" then
    return nil
  end

  return entry.value
end

local function open_selected_commit_diff_action(opts)
    opts = opts or {}

    return function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        local commit = commit_from_telescope_entry(entry)

        actions.close(prompt_bufnr)

        if not commit then
            vim.notify(
                "Could not determine commit from Telescope entry",
                vim.log.levels.ERROR
            )
            return
        end

        git.open_commit_diff_float(commit, opts.paths)
    end
end

local function git_bcommits_float(telescope_function)
    return function()
        telescope_function {
            attach_mappings = function()
                actions.select_default:replace(open_selected_commit_diff_action())
                return true
            end,
        }
    end
end

vim.keymap.set(
    'n', '<leader>ec', edit_neovim_config,
    { desc = "Grep nvim Config files" }
)

vim.keymap.set(
    "n", "<leader>/", builtin.current_buffer_fuzzy_find,
    { desc = "Fuzzy Find - Current buffer" }
)

vim.keymap.set(
    'n', '<leader>vb', builtin.git_branches,
    { desc = "Git - Branches" }
)

-- Shows commit diff in a temporary popup window
vim.keymap.set(
    "n", "<leader>vc", git_bcommits_float(builtin.git_bcommits),
    { desc = "Git - buffer commits history", }
)
vim.keymap.set(
    "x", "<leader>vc", git_bcommits_float(builtin.git_bcommits_range),
    { desc = "Git - selected-line commits history", }
)
