return {
    {
        "mfussenegger/nvim-dap",
        optional = true,
        dependencies = {
            -- Ensure C/C++ debugger is installed
            "williamboman/mason.nvim",
            optional = true,
            opts = { ensure_installed = { "codelldb" } },
        },
        opts = function()
            local dap = require("dap")
            if not dap.adapters["codelldb"] then
                require("dap").adapters["codelldb"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "codelldb",
                        args = {
                            "--port",
                            "${port}",
                        },
                    },
                }
            end
            for _, lang in ipairs({ "c", "cpp" }) do
                dap.configurations[lang] = {
                    {
                        type = "codelldb",
                        request = "launch",
                        name = "Launch file",
                        expressions = "native",
                        program = function() return vim.fn.input("Path to executable: ", vim.fn.expand("%:p:r")) end,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "codelldb",
                        request = "attach",
                        name = "Attach to process",
                        pid = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                }
            end
        end,
    },
}
