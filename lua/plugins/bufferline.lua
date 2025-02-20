return {
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = {
            -- "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {

                separator_style = { "| ", "|" },
                indicator = { style = "underline" },
                always_show_bufferline = true,
                -- style_preset = bufferline.style_preset.no_italic,
                -- numbers = function(opts)
                --     return string.format("%s", opts.ordinal)
                -- end,
                -- custom_filter = function(buf_number)
                --     -- filter out filetypes you don't want to see
                --     if vim.bo[buf_number].filetype ~= "qf" then
                --         return true
                --     end
                -- end,
            },
        },

        keys = {
            -- Re-order to previous/next
            { "<A-[>", "<Cmd>BufferLineMovePrev<CR>" },
            { "<A-]>", "<Cmd>BufferLineMoveNext<CR>" },
            -- Goto buffer in position...
            { "<A-1>", "<cmd>BufferLineGoToBuffer 1<CR>" },
            { "<A-2>", "<cmd>BufferLineGoToBuffer 2<CR>" },
            { "<A-3>", "<cmd>BufferLineGoToBuffer 3<CR>" },
            { "<A-4>", "<cmd>BufferLineGoToBuffer 4<CR>" },
            { "<A-5>", "<cmd>BufferLineGoToBuffer 5<CR>" },
            { "<A-6>", "<cmd>BufferLineGoToBuffer 6<CR>" },
            { "<A-7>", "<cmd>BufferLineGoToBuffer 7<CR>" },
            { "<A-8>", "<cmd>BufferLineGoToBuffer 8<CR>" },
            { "<A-9>", "<cmd>BufferLineGoToBuffer 9<CR>" },
            { "<A-0>", "<cmd>BufferLineGoToBuffer 10<CR>" },
            -- Sort buffers
            { "<Leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by directory" },
            { "<Leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort by extension" },
            { "<Leader>bsr", "<cmd>BufferLineSortByRelativeDirectory<CR>", desc = "Sort by relative dir" },
            -- Delete buffers
            { "<Leader>bh", "<cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
            { "<Leader>bl", "<cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
        },
    },

    { "tiagovla/scope.nvim", config = true },
}
