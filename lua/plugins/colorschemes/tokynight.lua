return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        -- use the night style
        style = "moon",
        -- disable italic for functions
        styles = {
            functions = {},
        },
        -- Change the "hint" color to the "orange" color, and make the "error" color bright red
        on_colors = function(colors)
            colors.bg = "#000000"
            colors.bg_dark = colors.black --"#1e2030"
            colors.bg_dark1 = "#191B29" --"#191B29"
            colors.bg_float = "#000000"
            -- colors.bg_highlight = "#2f334d"
            colors.bg_popup = "#ff0000"
            -- colors.bg_search = "#3e68d7"
            colors.bg_sidebar = "#000000"
            colors.bg_statusline = "#000000"
            -- colors.bg_visual = "#2d3f76"
        end,
    },
}
