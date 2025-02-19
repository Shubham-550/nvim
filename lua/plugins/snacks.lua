return {
    {
        -- https://github.com/folke/snacks.nvim
        "folke/snacks.nvim",

        opts = {
            picker = {
                formatters = {
                    file = {
                        filename_first = true, -- display filename before the file path
                    },
                },

                matcher = {
                    frecency = true,
                },

                win = {
                    input = {
                        keys = {
                            -- to close the picker on ESC instead of going to normal mode,
                            -- add the following keymap to your config
                            ["<Esc>"] = { "close", mode = { "n", "i" } },
                            -- I'm used to scrolling like this in LazyGit
                            ["J"] = { "preview_scroll_down", mode = { "i", "n" } },
                            ["K"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["H"] = { "preview_scroll_left", mode = { "i", "n" } },
                            ["L"] = { "preview_scroll_right", mode = { "i", "n" } },
                        },
                    },
                },
            },

            terminal = {
                win = {
                    wo = {
                        winbar = "",
                    },
                },
            },

            lazygit = {
                win = {
                    -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
                    style = "dashboard",
                },
            },

            image = {
                enabled = true,
                doc = {
                    -- Personally I set this to false, I don't want to render all the
                    -- images in the file, only when I hover over them
                    -- render the image inline in the buffer
                    -- if your env doesn't support unicode placeholders, this will be disabled
                    -- takes precedence over `opts.float` on supported terminals
                    inline = vim.g.neovim_mode == "skitty" and true or false,
                    -- only_render_image_at_cursor = vim.g.neovim_mode == "skitty" and false or true,
                    -- render the image in a floating window
                    -- only used if `opts.inline` is disabled
                    float = true,
                    -- Sets the size of the image
                    -- max_width = 60,
                    max_width = vim.g.neovim_mode == "skitty" and 20 or 60,
                    max_height = vim.g.neovim_mode == "skitty" and 10 or 30,
                    -- max_height = 30,
                    -- Apparently, all the images that you preview in neovim are converted
                    -- to .png and they're cached, original image remains the same, but
                    -- the preview you see is a png converted version of that image
                    --
                    -- Where are the cached images stored?
                    -- This path is found in the docs
                    -- :lua print(vim.fn.stdpath("cache") .. "/snacks/image")
                    -- For me returns `~/.cache/neobean/snacks/image`
                    -- Go 1 dir above and check `sudo du -sh ./* | sort -hr | head -n 5`
                },
            },

            dashboard = {
                sections = {
                    { section = "header" },
                    {
                        pane = 2,
                        section = "terminal",
                        cmd = "colorscript -e square",
                        height = 5,
                        padding = 4,
                    },
                    { section = "keys", gap = 1, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1,
                    },
                    { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                },
            },
        },

        keys = {
            {
                "<leader>fs",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Find Files (Smart Picker)",
            },

            -- -- List git branches with Snacks_picker to quickly switch to a new branch
            {
                "<leader>gb",
                function()
                    Snacks.picker.git_branches({
                        layout = "select",
                    })
                end,
                desc = "Git branches",
            },

            -- Navigate my buffers
            {
                "<leader>,",
                function()
                    Snacks.picker.buffers({
                        -- I always want my buffers picker to start in normal mode
                        on_show = function()
                            vim.cmd.stopinsert()
                        end,
                        finder = "buffers",
                        format = "buffer",
                        hidden = false,
                        unloaded = true,
                        current = true,
                        sort_lastused = true,
                        win = {},
                        -- In case you want to override the layout for this keymap
                        -- layout = "ivy",
                    })
                end,
                desc = "Buffers",
            },
        },
    },
}
