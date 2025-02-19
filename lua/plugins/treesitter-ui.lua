return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "LazyFile",
        opts = function()
            Snacks.toggle({
                name = "Indention Guides",
                get = function()
                    return require("ibl.config").get_config(0).enabled
                end,
                set = function(state)
                    require("ibl").setup_buffer(0, { enabled = state })
                end,
            }):map("<leader>ug")

            return {
                indent = {
                    char = "│",
                    tab_char = "│",
                    highlight = {
                        "RainbowRed",
                        "RainbowYellow",
                        "RainbowBlue",
                        "RainbowOrange",
                        "RainbowGreen",
                        "RainbowViolet",
                        "RainbowCyan",
                    },
                },
                scope = {
                    enabled = false,
                    show_start = false,
                    show_end = false,
                    highlight = {
                        "RainbowRed",
                        "RainbowYellow",
                        "RainbowBlue",
                        "RainbowOrange",
                        "RainbowGreen",
                        "RainbowViolet",
                        "RainbowCyan",
                    },
                },
                exclude = {
                    filetypes = {
                        "Trouble",
                        "alpha",
                        "dashboard",
                        "help",
                        "lazy",
                        "mason",
                        "neo-tree",
                        "notify",
                        "snacks_dashboard",
                        "snacks_notif",
                        "snacks_terminal",
                        "snacks_win",
                        "toggleterm",
                        "trouble",
                    },
                },
            }
        end,
        main = "ibl",
    },

    {
        "HiPhish/rainbow-delimiters.nvim",
        lazy = false,
        main = "rainbow-delimiters.setup",
        opts = {},
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- for comment sections
            keywords = { HH = { icon = "󰚟 ", color = "#cba6f7" } },
        },
    },
}
