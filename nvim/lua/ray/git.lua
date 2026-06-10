local M = {}

local function normalize_paths(paths)
    if paths == nil then
        return nil
    end

    if type(paths) == "string" then
        return { paths }
    end

    if vim.tbl_isempty(paths) then
        return nil
    end

    return paths
end

function M.open_commit_diff_float(commit, paths)
    paths = normalize_paths(paths)

    local cmd = {
        "git",
        "--no-pager",
        "show",
        "--patch",
        "--stat",
        "--decorate",
        "--no-ext-diff",
        "--no-color",
        commit,
    }

    if paths then
        table.insert(cmd, "--")
        vim.list_extend(cmd, paths)
    end

    local diff = vim.fn.systemlist(cmd)
    local ok = vim.v.shell_error == 0

    if not ok then
        vim.notify(
            table.concat(diff, "\n"),
            vim.log.levels.ERROR, {
                title = "git show failed",
            }
        )
        return
    end

    if vim.tbl_isempty(diff) then
        diff = { "No diff for " .. commit }
    end

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_name(buf, "git-show://" .. commit)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, diff)

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "diff"

    local padding_percent = 0.15
    local width  = math.floor(vim.o.columns * (1 - padding_percent))
    local height = math.floor(vim.o.lines * (1 - padding_percent))
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " git show " .. commit .. " ",
        title_pos = "center",
    })

    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].signcolumn = "no"

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.keymap.set("n", "q", close, { buffer = buf, silent = true, desc = "Close diff" })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true, desc = "Close diff" })
end

return M

