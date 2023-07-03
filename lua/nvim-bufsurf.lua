local M = {}

local buf_list = require("nvim_bufsurf.linkedlist")
local config = {
    enable = true,
}

local function change_buffer(buf)
    if buf then
        config.enable = false
        vim.cmd("silent b " .. buf)
        config.enable = true
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

local function buffer_focus(event)
    if not config.enable then
        return
    end
    if #event["file"] == 0 then
        return
    end
    local buf = event["buf"]
    local name = vim.fn.bufname(buf)
    if string.sub(name, 1, 1) ~= "/" then
        return
    end
    buf_list:insert(buf)
end

local function setup_callback()
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = buffer_focus,
    })
end

local function setup_commands()
    local command = vim.api.nvim_create_user_command
    command("BufsurfBackward", buffer_backward, {})
    command("BufsurfForward", buffer_forward, {})
end

function M.setup()
    setup_callback()
    setup_commands()
end
return M
