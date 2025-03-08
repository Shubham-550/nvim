local prefix = "<Leader>cp"
return {
    {
        "mfussenegger/nvim-dap-python",
        -- stylua: ignore
        keys = {
            { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
            { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
        },
        config = function()
            require("dap-python").setup(vim.g.python3_host_prog)
            require("dap-python").test_runner = "pytest"
            -- if vim.fn.has("win32") == 1 then
            --     require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
            -- else
            --     require("dap-python").setup("/media/data1/projects/Python/.venv/bin/python")
            -- end
        end,
    },

    {
        "geg2102/nvim-python-repl",
        lazy = true,
        dependencies = {
            "nvim-treesitter",
        },
        keys = {
            -- Normal mode keymaps
            {
                prefix,
                "",
                desc = "iPython Terminal",
            },
            {
                prefix .. "r",
                function()
                    require("nvim-python-repl").send_statement_definition()
                end,
                desc = "Send to ipython terminal",
                mode = "n",
            },
            -- {
            --     "<Leader>r",
            --     function()
            --         require("nvim-python-repl").send_statement_definition()
            --     end,
            --     desc = "Send to ipython terminal",
            --     mode = "n",
            -- },
            {
                prefix .. "b",
                function()
                    require("nvim-python-repl").send_buffer_to_repl()
                end,
                desc = "Send entire buffer to REPL",
                mode = "n",
            },
            {
                prefix .. "e",
                function()
                    require("nvim-python-repl").toggle_execute()
                    vim.notify(
                        "Automatic REPL execution "
                            .. (
                                require("nvim-python-repl.config").defaults["execute_on_send"] and "Enabled"
                                or "Disabled"
                            )
                    )
                end,
                desc = "Toggle automatic execution",
                mode = "n",
            },
            {
                prefix .. "v",
                function()
                    require("nvim-python-repl").toggle_vertical()
                    vim.notify(
                        "REPL split set to "
                            .. (require("nvim-python-repl.config").defaults["vsplit"] and "Vertical" or "Horizontal")
                    )
                end,
                desc = "Toggle vertical/horizontal split",
                mode = "n",
            },
            -- Visual mode keymaps
            -- {
            --     "<Leader>r",
            --     function()
            --         require("nvim-python-repl").send_visual_to_repl()
            --     end,
            --     desc = "Send to ipython terminal",
            --     mode = "v",
            -- },
        },
        ft = { "python", "lua", "scala" },
        config = function()
            require("nvim-python-repl").setup({
                execute_on_send = true,
                vsplit = true,
                spawn_command = {
                    python = "ipython",
                    scala = "sbt console",
                    lua = "ilua",
                },
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
            servers = {
                pyright = {
                    enabled = false, -- disable server
                    mason = false, -- don't install with mason
                    autostart = false,
                },

                ruff = {
                    mason = false,
                    init_options = {
                        settings = {
                            lint = {
                                enable = false,
                            },
                        },
                    },
                },

                basedpyright = {
                    mason = false, -- don't install with mason
                    settings = {
                        basedpyright = {
                            -- reportImplicitOverride = false,
                            -- reportMissingSuperCall = "none",
                            -- reportUnusedImport = false,
                            -- works, if pyproject.toml is used
                            -- reportAttributeAccessIssue = false,
                            -- doesn't work, even if pyproject.toml is used
                            analysis = {
                                -- basedpyright very intrusive with errors, this calms it down
                                typeCheckingMode = "standard",

                                -- diagnosticSeverityOverrides = {
                                --   reportUnknownParameterType = "none",
                                --   reportMissingParameterType = "none",
                                --   reportUnknownVariableType = "none",
                                -- },

                                -- Using Ruff's import organizer
                                disableOrganizeImports = true,

                                diagnosticSeverityOverrides = {
                                    reportUnusedVariable = "none",
                                },

                                inlayHints = {
                                    callArgumentNames = true, -- = basedpyright.analysis.inlayHints.callArgumentNames
                                    variableTypes = true,
                                    functionReturnTypes = true,
                                    genericTypes = false,
                                },
                            },
                        },
                        -- Ignore all files for analysis to exclusively use Ruff for linting
                        python = {
                            analysis = {
                                ignore = { "*" },
                            },
                        },
                    },
                },
            },
        },
    },

    {
        "stefanboca/venv-selector.nvim",
        branch = "sb/push-rlpxsqmllxtz",
        cmd = "VenvSelect",
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        --  Call config for python files and load the cached venv automatically
        ft = "python",
        keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" } },
    },
}
