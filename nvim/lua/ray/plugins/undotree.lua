vim.opt.undofile = true

-- Keep existing undodir from vimrc.
-- Only create the first configured undo dir if it is a real path.
local undodir = vim.opt.undodir:get()[1]

if undodir and undodir ~= "." then
  vim.fn.mkdir(vim.fn.expand(undodir), "p")
end

vim.g.undotree_WindowLayout = 2
vim.g.undotree_SplitWidth = 35
vim.g.undotree_SetFocusWhenToggle = 1

local group = vim.api.nvim_create_augroup("ray_undotree", {
    clear = true,
})

local function is_normal_file_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
        return false
    end

    return vim.bo[buf].buftype == ""
       and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function has_normal_file_window()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if is_normal_file_buffer(buf) then
            return true
        end
    end

    return false
end

local function close_undotree_if_orphaned()
    vim.schedule(function()
        if has_normal_file_window() then
            return
        end

        pcall(vim.cmd.UndotreeHide)
    end)
end

vim.api.nvim_create_autocmd({ "BufWinLeave", "BufDelete", "BufWipeout" }, {
    group = group,
    callback = close_undotree_if_orphaned,
})

vim.api.nvim_create_autocmd("QuitPre", {
    group = group,
    callback = function()
        pcall(vim.cmd.UndotreeHide)
    end,
})
