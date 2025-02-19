-- return {
--     "Bekaboo/dropbar.nvim",
--     -- optional, but required for fuzzy finder support
--     -- dependencies = {
--     --     "nvim-telescope/telescope-fzf-native.nvim",
--     --     build = "make",
--     -- },
--     config = function()
--         local dropbar_api = require("dropbar.api")
--         vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
--         vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
--         vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
--     end,
-- }

return {
    "Bekaboo/dropbar.nvim",
    dependencies = {
        -- "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- icons = {
        --     ui = {
        --         bar = {
        --             "",
        --             "…",
        --         },
        --         menu = {
        --             "",
        --             "…",
        --         },
        --     },
        -- },
        bar = {
            enable = function(buf, win, _)
                local ft = vim.bo[buf].ft

                if
                    not vim.api.nvim_buf_is_valid(buf)
                    or not vim.api.nvim_win_is_valid(win)
                    or vim.fn.win_gettype(win) ~= ""
                    or vim.wo[win].winbar ~= ""
                    or ft == "help"
                    or ft == "noice"
                    or ft == "dashboard"
                then
                    return false
                else
                    -- print("----------")
                    -- print("ft: " .. ft)
                    -- print("bt: " .. bt)
                    -- print("----------")
                    return true
                end
            end,
            truncate = true,
        },
        sources = {
            path = {
                max_depth = 1,
                oil = true,
            },
            treesitter = {
                max_depth = 0,
            },
            lsp = {
                max_depth = 5,
            },
            markdown = {
                max_depth = 0,
            },
            terminal = {
                show_current = false,
            },
        },
    },
}
