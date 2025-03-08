-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local utils = require("utils")
local filter_windows = utils.filter_windows

local function opts(desc, extra)
    local default = { noremap = true, silent = true, desc = desc }
    return extra and vim.tbl_extend("force", default, extra) or default
end

-- Map Alt+V to Visual Block mode
map("n", "<A-v>", "<C-v>", { noremap = true, silent = true, desc = "Visual Block Mode" })
map("n", "<Space>v", "ggVG", { desc = "Select all" })

-- Duplicate lines or selections
map("n", "<C-A-k>", "yy[P", opts("Duplicate line up"))
map("n", "<C-A-j>", "yy]p", opts("Duplicate line down"))
map("v", "<C-A-k>", "yP", opts("Duplicate selection up"))
map("v", "<C-A-j>", "y]p", opts("Duplicate selection down"))

-- -- Don't copy when pasting over selection
-- map("v", "p", '"_dP', { noremap = true, silent = true })
-- map("v", "P", '"_dp', { noremap = true, silent = true })

-- Delete without copying to register
map("v", "<Del>", '"_d', opts("Delete without yanking"))

-- Window navigation
map({ "i" }, "<C-k>", "<Up>", { desc = "Move up" })
map({ "i" }, "<C-j>", "<Down>", { desc = "Move down" })
map({ "i" }, "<C-h>", "<Left>", { desc = "Move left" })
map({ "i" }, "<C-l>", "<Right>", { desc = "Move right" })

-- Window resize
map({ "n" }, "<A-S-k>", "<c-w>-", { desc = "Decrease height" })
map({ "n" }, "<A-S-j>", "<C-w>+", { desc = "Increase height" })
map({ "n" }, "<A-S-h>", "<c-w>5<", { desc = "Decrese width" })
map({ "n" }, "<A-S-l>", "<c-w>5>", { desc = "Increase width" })

-- Exit modes
map({ "i" }, "jk", "<ESC>", { desc = "Escape insert mode" })
map({ "i" }, "kj", "<ESC>", { desc = "Escape insert mode" })

map("i", "jj", "<Esc>", opts("Exit insert mode"))
map({ "n", "i" }, "qq", "<cmd>q<CR>", opts("Quick quit"))
map("n", "QQ", "<cmd>bufdo bd<CR>", opts("Quit all buffers"))

map({ "t" }, "kj", "<C-\\><C-n>", { desc = "Escape insert mode" })

-- Enter creates new line
map({ "n" }, "<CR>", "o<Esc>", { noremap = true, silent = true })
map({ "n" }, "<S-CR>", "O<Esc>", { noremap = true, silent = true })

-- Add some DAP mappings
map("n", "<F5>", function() require("dap").continue() end, { desc = "Debugger: Start" })
map("n", "<F6>", function() require("dap").pause() end, { desc = "Debugger: Pause" })
map("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "Debugger: Toggle Breakpoint" })
map("n", "<F10>", function() require("dap").step_over() end, { desc = "Debugger: Step Over" })
map("n", "<F11>", function() require("dap").step_into() end, { desc = "Debugger: Step Into" })
map("n", "<F17>", function() require("dap").terminate() end, { desc = "Debugger: Terminate" }) -- Shift+F5
map("n", "<F23>", function() require("dap").step_out() end, { desc = "Debugger: Step Out" }) -- Shift+F11

-- When you do joins with J it will keep your cursor at the beginning instead of at the end
map({ "n", "v" }, "J", "mzJ`z", { desc = "Keep cursor in the same position while joining lines" })

-- Toggle executable permission on current file, previously I had 2 keymaps, to
-- add or remove exec permissions, now it's a toggle using the same keymap
map("n", "<leader>fx", function()
    local file = vim.fn.expand("%")
    local perms = vim.fn.getfperm(file)
    local is_executable = string.match(perms, "x", -1) ~= nil
    local escaped_file = vim.fn.shellescape(file)
    if is_executable then
        vim.cmd("silent !chmod -x " .. escaped_file)
        vim.notify("Removed executable permission", vim.log.levels.INFO)
    else
        vim.cmd("silent !chmod +x " .. escaped_file)
        vim.notify("Added executable permission", vim.log.levels.INFO)
    end
end, { desc = "Toggle executable permission" })

-- -- CMake group
-- -- map({ "n", "v" }, "<leader>c", group = "CMake")
-- local M = {}
-- function M.setup()
--     require("which-key").setup({})
--     require("which-key").add({
--         { "<leader>c", group = "CMake", cond = not vim.g.vscode },
--     })
-- end
-- map({ "n", "v" }, "<leader>ccc", "<cmd>CMakeSelectConfigurePreset<cr>", { desc = "Select configure preset" })
-- map({ "n", "v" }, "<leader>ccg", "<cmd>CMakeGenerate<cr>", { desc = "Generate" })
-- map({ "n", "v" }, "<leader>cct", "<cmd>CMakeSelectBuildTarget<cr>", { desc = "Select build target" })
-- map({ "n", "v" }, "<leader>ccb", "<cmd>wa<cr><cmd>CMakeBuild<cr>", { desc = "Build" })
-- map({ "n", "v" }, "<leader>ccT", "<cmd>CMakeSelectLaunchTarget<cr>", { desc = "Select launch target" })
-- map({ "n", "v" }, "<leader>ccr", "<cmd>wa<cr><cmd>CMakeRun<cr>", { desc = "Run" })
-- map({ "n", "v" }, "<leader>ccd", "<cmd>wa<cr><cmd>CMakeDebug<cr>", { desc = "Debug" })
-- map({ "n", "v" }, "<leader>ccs", "<cmd>CMakeStopExecutor<cr>", { desc = "Stop Executor" })
-- map({ "n", "v" }, "<leader>ccS", "<cmd>CMakeStopRunner<cr>", { desc = "Stop Runner" })
--
-- return M

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "c", "cpp" },
--     callback = function()
--         local filetype = vim.bo.filetype
--         local compile_flags =
--             " -Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion -Wshadow -Wold-style-cast -Woverloaded-virtual -Wnon-virtual-dtor -Werror"
--
--         local compiler = ""
--         if filetype == "cpp" then
--             compiler = "clang++ -std=c++23"
--         elseif filetype == "c" then
--             compiler = "clang -std=c23"
--         end
--
--         -- Determine the project root (current working directory)
--         local project_root = vim.print(require("lazyvim.util").root())
--         local build_dir = project_root .. "/build"
--         local debug_dir = build_dir .. "/Debug"
--
--         -- Create directories if they don't exist
--         vim.fn.mkdir(build_dir, "p")
--         vim.fn.mkdir(debug_dir, "p")
--
--         -- Get file paths
--         local filepath = '"' .. vim.fn.expand("%:p") .. '"' -- Full path to current file
--         local filename = vim.fn.expand("%:t:r") -- File name without extension
--
--         -- Define output paths for run and debug builds (wrapped in quotes)
--         local run_output = '"' .. build_dir .. "/" .. filename .. '"'
--         local debug_output = '"' .. debug_dir .. "/" .. filename .. '"'
--
--         -- Build the compile & run command (normal run)
--         local run_cmd = compiler
--             .. " "
--             .. compile_flags
--             .. " "
--             .. filepath
--             .. " -o "
--             .. run_output
--             .. " && "
--             .. run_output
--         local full_run_cmd = ":w<CR>:split | term bash -c '" .. run_cmd .. "'<CR>"
--         map(
--             "n",
--             "<leader>cbr",
--             full_run_cmd,
--             { noremap = true, silent = true, desc = "Compile & Run C/C++ in Terminal" }
--         )
--
--         -- Build the compile-only command (normal run)
--         local compile_only_cmd = ":w<CR>:!"
--             .. compiler
--             .. " "
--             .. compile_flags
--             .. " "
--             .. filepath
--             .. " -o "
--             .. run_output
--             .. "<CR>"
--         map("n", "<leader>cbc", compile_only_cmd, { noremap = true, silent = true, desc = "Compile C/C++ Code" })
--
--         -- Build the compile & debug command (launches lldb on the Debug build)
--         local debug_cmd = compiler
--             .. " "
--             .. compile_flags
--             .. " "
--             .. filepath
--             .. " -o "
--             .. debug_output
--             .. " && codelldb "
--             .. debug_output
--         local full_debug_cmd = ":w<CR>:split | term bash -c '" .. debug_cmd .. "'<CR>"
--         map(
--             "n",
--             "<leader>cbd",
--             full_debug_cmd,
--             { noremap = true, silent = true, desc = "Compile & Debug C/C++ in Terminal" }
--         )
--     end,
-- })

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = { "c", "cpp" },
--     callback = function()
--         local filetype = vim.bo.filetype
--         local compile_flags =
--             " -Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion -Wshadow -Wold-style-cast -Woverloaded-virtual -Wnon-virtual-dtor -Werror"
--
--         local compiler = ""
--         if filetype == "cpp" then
--             compiler = "clang++ -std=c++23"
--         elseif filetype == "c" then
--             compiler = "clang -std=c23"
--         end
--
--         -- Get file paths
--         local filepath = vim.fn.expand("%:p")
--         local filepathWithoutExt = vim.fn.expand("%:p:r")
--
--         -- Define output paths for run and debug builds (wrapped in quotes)
--         -- local run_output = '"' .. build_dir .. "/" .. filename .. '"'
--         -- local debug_output = '"' .. debug_dir .. "/" .. filename .. '"'
--
--         -- Build the compile & run command (normal run)
--         local run_cmd = compiler
--             .. " "
--             .. compile_flags
--             .. " "
--             .. filepath
--             .. " -o "
--             .. '"'
--             .. filepathWithoutExt
--             .. '"'
--             .. " && "
--             .. '"'
--             .. filepathWithoutExt
--             .. '"'
--             .. " && rm "
--             .. '"'
--             .. filepathWithoutExt
--             .. '"'
--         local full_run_cmd = ":w<CR>:split | term bash -c '" .. run_cmd .. "'<CR>"
--         map(
--             "n",
--             "<leader>rr",
--             full_run_cmd,
--             { noremap = true, silent = true, desc = "Compile & Run C/C++ in Terminal" }
--         )
--
--         -- Build the compile-only command (normal run)
--         local compile_only_cmd = ":w<CR>:!"
--             .. compiler
--             .. " "
--             .. compile_flags
--             .. " "
--             .. filepath
--             .. " -o "
--             .. '"'
--             .. filepathWithoutExt
--             .. '"'
--         map("n", "<leader>rc", compile_only_cmd, { noremap = true, silent = true, desc = "Compile C/C++ Code" })
--
--         -- -- Build the compile & debug command (launches lldb on the Debug build)
--         -- local debug_cmd = compiler
--         --     .. " "
--         --     .. compile_flags
--         --     .. " "
--         --     .. filepath
--         --     .. " -o "
--         --     .. debug_output
--         --     .. " && codelldb "
--         --     .. debug_output
--         -- local full_debug_cmd = ":w<CR>:split | term bash -c '" .. debug_cmd .. "'<CR>"
--         -- map(
--         --     "n",
--         --     "<leader>cbd",
--         --     full_debug_cmd,
--         --     { noremap = true, silent = true, desc = "Compile & Debug C/C++ in Terminal" }
--         -- )
--     end,
-- })

-- More convenient horizontal scrolling
vim.api.nvim_set_keymap(
    "n",
    "zh",
    "<cmd>call HorizontalScrollMode('h')<cr>",
    { noremap = true, silent = true, desc = "Left scroll" }
)
vim.api.nvim_set_keymap(
    "n",
    "zl",
    "<cmd>call HorizontalScrollMode('l')<cr>",
    { noremap = true, silent = true, desc = "Right scroll" }
)
vim.api.nvim_set_keymap(
    "n",
    "zH",
    "<cmd>call HorizontalScrollMode('H')<cr>",
    { noremap = true, silent = true, desc = "Left half-screen scroll" }
)
vim.api.nvim_set_keymap(
    "n",
    "zL",
    "<cmd>call HorizontalScrollMode('L')<cr>",
    { noremap = true, silent = true, desc = "Right half-screen scroll" }
)

--  Centering cursor
vim.api.nvim_set_keymap(
    "n",
    "<C-d>",
    "<C-d>zz",
    { noremap = true, silent = true, desc = "Scroll half down with cursor centered" }
)
vim.api.nvim_set_keymap(
    "n",
    "<C-u>",
    "<C-u>zz",
    { noremap = true, silent = true, desc = "Scroll half up with cursor centered" }
)
vim.api.nvim_set_keymap(
    "n",
    "<C-f>",
    "<C-f>zz",
    { noremap = true, silent = true, desc = "Scroll down with cursor centered" }
)
vim.api.nvim_set_keymap(
    "n",
    "<C-b>",
    "<C-b>zz",
    { noremap = true, silent = true, desc = "Scroll up with cursor centered" }
)
vim.api.nvim_set_keymap("n", "n", "nzzzv", { noremap = true, silent = true, desc = "Next match centered" })
vim.api.nvim_set_keymap("n", "N", "Nzzzv", { noremap = true, silent = true, desc = "Previous match centered" })

-- Operataion without yanking
map({ "n", "x" }, "c", '"_c', { desc = "c without yank" })
map({ "n", "x" }, "C", '"_C', { desc = "C without yank" })
map({ "n", "x" }, "x", '"_x', { desc = "x without yank" })
map({ "n", "x" }, "X", '"_X', { desc = "X without yank" })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
map("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

--- Get list of active buffeers from current list of windows
---@param windows number[]
---@return number[]
local function get_shown_buffers(windows)
    local buf_numbers = {}
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufinfo = vim.fn.getbufinfo(buf)[1]
        if bufinfo.hidden == 0 and bufinfo.listed == 1 then
            buf_numbers[#buf_numbers + 1] = buf
        end
    end
    return buf_numbers
end

-- Diffs between current windows
map("n", "<localleader>md", function()
    local windows = vim.api.nvim_list_wins()
    local buf_numbers = get_shown_buffers(windows)
    if #buf_numbers == 2 then
        vim.cmd.tabnew(vim.fn.getbufinfo(buf_numbers[1])[1].name)
        vim.cmd("vertical diffsplit " .. vim.fn.getbufinfo(buf_numbers[2])[1].name)
        vim.cmd.normal({ args = { "gg" }, bang = true })
    else
        local first_win = require("snacks").picker.util.pick_win({ filter = filter_windows })
        if first_win == nil then
            return
        end
        local second_win = require("snacks").picker.util.pick_win({ filter = filter_windows })
        if second_win == nil then
            return
        end
        local first_bufnumber = vim.api.nvim_win_get_buf(first_win)
        local second_bufnumber = vim.api.nvim_win_get_buf(second_win)
        local first_buf = vim.fn.getbufinfo(first_bufnumber)[1]
        local second_buf = vim.fn.getbufinfo(second_bufnumber)[1]
        vim.cmd.tabnew(first_buf.name)
        vim.cmd("vertical diffsplit " .. second_buf.name)
        vim.cmd.normal({ args = { "gg" }, bang = true })
    end
end, { desc = "Diff between open files" })

map("x", "<localleader>md", function()
    vim.cmd('noau normal! "vy')
    local filetype = vim.bo.filetype
    vim.cmd.tabnew()
    vim.cmd('noau normal! "0P')
    vim.bo.filetype = filetype
    vim.bo.buftype = "nowrite"
    vim.cmd.diffthis()
    vim.cmd.vsplit()
    vim.cmd.ene()
    vim.cmd('noau normal! "vP')
    vim.bo.filetype = filetype
    vim.bo.buftype = "nowrite"
    vim.cmd.diffthis()
end, { desc = "Diff selection with clipboard" })

-- Diffview
local function get_default_branch_name()
    local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
    return res.code == 0 and "main" or "master"
end

map(
    "n",
    "<leader>gdb",
    function() vim.cmd("DiffviewOpen " .. get_default_branch_name()) end,
    { desc = "Diff against master" }
)

map("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
map("v", "<leader>gdd", "<Esc><cmd>'<,'>DiffviewFileHistory --follow<cr>", { desc = "Range history" })
map("n", "<leader>gdc", ":DiffviewOpen ", { desc = "Diff custom" })
map("n", "<leader>gdhf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File history" })
map("n", "<leader>gdhd", "<cmd>DiffviewFileHistory %:p:h<cr>", { desc = "Directory history" })
map("n", "<leader>gdhg", "<cmd>DiffviewFileHistory<cr>", { desc = "Global history" })

-- Code runner
map("n", "<leader>rr", ":RunCode<CR>", { desc = "Run code" })
map("n", "<leader>rf", ":RunFile<CR>", { desc = "Run file" })
map("n", "<leader>rp", ":RunProject<CR>", { desc = "Run Project" })

-- Harpoon
map({ "n", "v" }, "<leader>hh", function()
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon toggle menu" })

map({ "n", "v" }, "<leader>ha", function()
    local harpoon = require("harpoon")
    harpoon:list():add()
end, { desc = "Harpoon Add File" })

map({ "n", "v" }, "<leader>hj", function()
    local harpoon = require("harpoon")
    harpoon:list():next()
end, { desc = "Harpoon Next" })

map({ "n", "v" }, "<leader>hk", function()
    local harpoon = require("harpoon")
    harpoon:list():prev()
end, { desc = "Harpoon Prev" })
