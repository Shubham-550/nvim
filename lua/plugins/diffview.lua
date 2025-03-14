return {
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        config = function()
            local actions = require("diffview.actions")

            require("diffview").setup({
                keymaps = {
                    view = {
                        { "n", "q", actions.close, { desc = "DiffviewClose" } },
                    },
                    file_panel = {
                        -- actions.close closes only the file_panel window
                        { "n", "q", "<CMD>DiffviewClose<CR>", { desc = "DiffviewClose" } },
                    },
                    file_history_panel = {
                        -- similarly, actions.close closes only the file_history_panel window
                        { "n", "q", "<CMD>DiffviewClose<CR>", { desc = "DiffviewClose" } },
                    },
                },
            })
        end,
    },
}
