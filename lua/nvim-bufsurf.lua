local M = {}
local function hello()
    vim.notify("HelloWorld")
end

local function setup_commands()
    local command = vim.api.nvim_create_user_command
    command("HelloWorld", hello)
end

function M.setup(conf)
    setup_commands()
end
return M
