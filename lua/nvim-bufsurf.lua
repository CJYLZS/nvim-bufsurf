local M = {}

local buf_list = require("nvim_bufsurf.linkedlist")
local config = {
    enable = true,
}

local function buffer_forward()
    local buf = buf_list:forward()
    if buf then
        config.enable = false
        vim.cmd("silent b " .. buf)
        config.enable = true
    end
end

local function buffer_backward()
    local buf = buf_list:backward()
    if buf then
        config.enable = false
        vim.cmd("silent b " .. buf)
        config.enable = true
    end
end

local function buffer_focus(event)
    if not config.enable then
        return
    end
    if #event["file"] == 0 then
        return
    end
    buf_list:insert(event["buf"])
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
