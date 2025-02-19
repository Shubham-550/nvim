return {
    "mikavilpas/yazi.nvim",
    lazy = true, -- use `event = "VeryLazy"` for netrw replacement
    keys = {
        {
            "<leader>fy",
            function()
                require("yazi").yazi(nil, vim.fn.getcwd())
            end,
            desc = "Open Yazi (file manager)",
        },
    },
    opts = {
        open_for_directories = true,
    },
}
