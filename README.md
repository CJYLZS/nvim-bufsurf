<p align='center'>Move through the neovim history buffer as you would in the browser</p>

- move around buffers

![](./pics/example.gif)

- move around work dirs
L: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

![][./pics/dirsurf.gif]

## Installation

Using lazy.nvim in lua

```lua
return {
    "CJYLZS/nvim-bufsurf",
    event = { "BufEnter" },
    config = function()
        require("nvim-bufsurf").setup()
        vim.api.nvim_set_keymap("n", "<C-P>", "<CMD>BufsurfBackward<CR>", { silent = true })
        vim.api.nvim_set_keymap("i", "<C-P>", "<CMD>BufsurfBackward<CR>", { silent = true })
        vim.api.nvim_set_keymap("n", "<C-N>", "<CMD>BufsurfForward<CR>", { silent = true })
        vim.api.nvim_set_keymap("i", "<C-N>", "<CMD>BufsurfForward<CR>", { silent = true })
        vim.api.nvim_set_keymap("n", "<leader>P", "<CMD>DirsurfBackward<CR>", { silent = true })
        vim.api.nvim_set_keymap("n", "<leader>N", "<CMD>DirsurfForward<CR>", { silent = true })
    end,
}
```

