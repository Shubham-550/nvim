return {

    {
        "nvzone/minty",
        cmd = { "Shades", "Huefy" },
    },
    { "nvchad/volt", lazy = true },
    -- { "nvchad/minty", lazy = true },
    -- {
    --     "nvchad/ui",
    --     config = function()
    --         require("nvchad")
    --     end,
    -- },
    -- {
    --     "nvchad/base46",
    --     priority = 1000,
    --     lazy = false,
    --     build = function()
    --         require("base46").load_all_highlights()
    --     end,
    -- },
    { { "RishabhRD/nvim-cheat.sh", event = "VeryLazy" }, { "RishabhRD/popfix", event = "VeryLazy" } },
    {
        "nvzone/typr",
        cmd = "TyprStats",
        dependencies = "nvzone/volt",
        opts = {},
    },
}
