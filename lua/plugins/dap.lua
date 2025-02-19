return {

    -- DAP
    {
        "mfussenegger/nvim-dap",
        opts = {
            -- Icons
            vim.fn.sign_define("DapBreakpoint", { text = "🔵", texthl = "", linehl = "", numhl = "" }),
            vim.fn.sign_define("DapBreakpointRejected", { text = "🔴", texthl = "", linehl = "", numhl = "" }),
            vim.fn.sign_define("DapConditionalBreakpoint", { text = "🟡", texthl = "", linehl = "", numhl = "" }),
            vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" }),
        },
    },

    -- DAP-ui
    {
        "rcarriga/nvim-dap-ui",
        opts = {
            layouts = {
                {
                    elements = {
                        { id = "console", size = 0.5 },
                        { id = "repl", size = 0.5 },
                    },
                    position = "bottom",
                    size = 20,
                },
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        { id = "breakpoints", size = 0.25 },
                        { id = "stacks", size = 0.25 },
                        { id = "watches", size = 0.25 },
                    },
                    position = "left",
                    size = 40,
                },
            },

            -- Resets the DAP UI
            function()
                -- Import the necessary modules
                local events = require("neo-tree.events")
                local noice = require("noice")

                noice.notify("Start...", "info")

                -- Subscribe to the 'window_after_close' event
                events.subscribe({
                    event = events.NEO_TREE_WINDOW_BEFORE_CLOSE,
                    handler = function()
                        local dap = require("dap")
                        local dapui = require("dapui")

                        -- Check if a DAP session exists
                        if dap.session() then
                            noice.notify("Reset dap ui Successful", "info")

                            -- Open DAP UI with the reset option
                            dapui.toggle({ reset = false })
                        end
                    end,
                })

                events.subscribe({
                    event = events.NEO_TREE_WINDOW_AFTER_OPEN,
                    handler = function()
                        local dap = require("dap")
                        local dapui = require("dapui")

                        -- Check if a DAP session exists
                        if dap.session() then
                            noice.notify("Reset dap ui Successful", "info")

                            -- Open DAP UI with the reset option
                            dapui.toggle({ reset = true })
                        end
                    end,
                })
            end,
        },

        config = function(_, opts)
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup(opts)
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open({ reset = true })
            end
            dap.listeners.before.attach.dapui_config = function()
                dapui.open({ reset = true })
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open({ reset = true })
            end
            -- Dont't close DAP UI
            dap.listeners.before.event_terminated.dapui_config = nil
            dap.listeners.before.event_exited.dapui_config = nil
        end,
    },

    {
        "Weissle/persistent-breakpoints.nvim",
        event = "BufReadPost",
        opts = function()
            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
            })
        end,
        keys = {
            {
                "<Leader>db",
                function()
                    require("persistent-breakpoints.api").toggle_breakpoint()
                end,
                { silent = true },
                desc = "Toggle Breakpoint",
            },
            {
                "<Leader>dx",
                function()
                    require("persistent-breakpoints.api").clear_all_breakpoints()
                end,
                { silent = true },
                desc = "Clear Breakpoints",
            },
            {
                "<Leader>dB",
                function()
                    require("persistent-breakpoints.api").set_conditional_breakpoint()
                end,
                { silent = true },
                desc = "Conditional Breakpoint",
            },
        },
    },
}
