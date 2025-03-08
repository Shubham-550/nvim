return {
    "CRAG666/code_runner.nvim",
    config = true,
    event = "LspAttach",
    opts = {
        -- mode = "float",
        filetype = {
            java = {
                "cd $dir &&",
                "javac $fileName &&",
                "java $fileNameWithoutExt",
            },
            lua = "nvim -l",
            python = "python3 -u",
            typescript = "deno run",
            sh = "bash",
            rust = {
                "cd $dir &&",
                "rustc $fileName &&",
                "$dir/$fileNameWithoutExt",
            },

            c = function()
                local c_base = {
                    "cd $dir &&",
                    "clang++ -std=c++23",
                    "-Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion -Wshadow -Wold-style-cast -Woverloaded-virtual -Wnon-virtual-dtor -Werror",
                    "$fileName -o $dir/$fileNameWithoutExt",
                }
                local c_exec = {
                    "&& $dir/$fileNameWithoutExt",
                    "&& rm $dir/$fileNameWithoutExt",
                }
                local final_command = table.concat(vim.list_extend(c_base, c_exec), " ")
                require("code_runner.commands").run_from_fn(final_command)
                -- vim.ui.input({ prompt = "Add more args:" }, function(input)
                --     table.insert(c_base, input)
                --     local final_command = table.concat(vim.list_extend(c_base, c_exec), " ")
                --     vim.print(final_command)
                --     require("code_runner.commands").run_from_fn(final_command)
                -- end)
            end,

            cpp = function()
                local cpp_base = {
                    "cd $dir &&",
                    "clang++ -std=c++23",
                    "-Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion -Wshadow -Wold-style-cast -Woverloaded-virtual -Wnon-virtual-dtor -Werror",
                    "$fileName -o $dir/$fileNameWithoutExt",
                }
                local cpp_exec = {
                    "&& $dir/$fileNameWithoutExt",
                    "&& rm $dir/$fileNameWithoutExt",
                }

                local final_command = table.concat(vim.list_extend(cpp_base, cpp_exec), " ")
                require("code_runner.commands").run_from_fn(final_command)
                -- vim.ui.input({ prompt = "Add more args:" }, function(input)
                --     table.insert(cpp_base, input)
                --     local final_command = table.concat(vim.list_extend(cpp_base, cpp_exec), " ")
                --     vim.print(final_command)
                --     require("code_runner.commands").run_from_fn(final_command)
                -- end)
            end,
        },
    },
}
