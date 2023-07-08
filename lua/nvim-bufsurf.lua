local M = {}

local ll = require("nvim_bufsurf.linkedlist")
local buf_list = ll:new()
local dir_list = ll:new()

local config = {
    buf_enable = true,
    dir_enable = true,
}

local function change_buffer(buf)
    if buf then
        config.buf_enable = false
        vim.cmd("silent b " .. buf)
        config.buf_enable = true
    end
end

local function is_buffer_not_exists(buf)
    return vim.fn.bufexists(buf) == 0
end

local function forward_skip_unshow()
    local buf = buf_list:forward()
    while buf and is_buffer_not_exists(buf) do
        buf = buf_list:delete_cur(true)
    end
    return buf
end

local function buffer_forward()
    -- change_buffer(buf_list:forward())
    change_buffer(forward_skip_unshow())
end

local function backward_skip_unshow()
    local buf = buf_list:backward()
    while buf and is_buffer_not_exists(buf) do
        buf = buf_list:delete_cur(false)
    end
    return buf
end

local function buffer_backward()
    -- change_buffer(buf_list:backward())
    change_buffer(backward_skip_unshow())
end

local function buffer_include(buf)
    local name = vim.fn.bufname(buf)
    if not name then
        return false
    end
    -- exclude names like ['.*neo-tree filesystem.*', 'term://.*']
    local exclusion_patterns = {
        ".*neo%-tree filesystem.*",
        "term://.*",
    }
    for _, pattern in ipairs(exclusion_patterns) do
        if string.match(name, pattern) then
            return false
        end
    end
    return true
end

local function buffer_focus(event)
    if not config.buf_enable then
        return
    end
    if #event["file"] == 0 then
        return
    end
    local buf = event["buf"]
    if not buffer_include(buf) then
        return
    end
    buf_list:insert(buf)
end

local function cd(path)
    config.dir_enable = false
    if path then
        vim.cmd("cd " .. path)
    end
    config.dir_enable = true
end

local function dir_forward()
    cd(dir_list:forward())
end

local function dir_backward()
    cd(dir_list:backward())
end

local function dirchanged()
    if not config.dir_enable then
        return
    end
    dir_list:insert(vim.api.nvim_call_function("getcwd", {}))
end

local function setup_callback()
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = buffer_focus,
    })
    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        callback = dirchanged,
    })
end

local function setup_commands()
    local command = vim.api.nvim_create_user_command
    command("BufsurfBackward", buffer_backward, {})
    command("BufsurfForward", buffer_forward, {})
    command("DirsurfBackward", dir_backward, {})
    command("DirsurfForward", dir_forward, {})
end

function M.setup()
    setup_callback()
    setup_commands()
end
return M
