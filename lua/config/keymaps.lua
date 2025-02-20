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

-- Window navigation and resize
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

-- Enter creates new line
map({ "n" }, "<CR>", "o<Esc>", { noremap = true, silent = true })
map({ "n" }, "<S-CR>", "O<Esc>", { noremap = true, silent = true })

-- Add some DAP mappings
map("n", "<F5>", function()
    require("dap").continue()
end, { desc = "Debugger: Start" })
map("n", "<F6>", function()
    require("dap").pause()
end, { desc = "Debugger: Pause" })
map("n", "<F9>", function()
    require("dap").toggle_breakpoint()
end, { desc = "Debugger: Toggle Breakpoint" })
map("n", "<F10>", function()
    require("dap").step_over()
end, { desc = "Debugger: Step Over" })
map("n", "<F11>", function()
    require("dap").step_into()
end, { desc = "Debugger: Step Into" })
map("n", "<F17>", function()
    require("dap").terminate()
end, { desc = "Debugger: Terminate" }) -- Shift+F5
map("n", "<F23>", function()
    require("dap").step_out()
end, { desc = "Debugger: Step Out" }) -- Shift+F11

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
map({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
map({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
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

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" }, -- Apply only for C and C++ files
    callback = function()
        local cpp_standard = "-std=c++23"
        local compile_flags = cpp_standard
            .. " -pedantic-errors -Wall -Wextra -Wconversion -Wsign-conversion -Wshadow -Wold-style-cast -Woverloaded-virtual -Wnon-virtual-dtor -Werror"

        map("n", "<leader>cbr", function()
            vim.cmd("w")
            local filename = vim.fn.expand("%:t:r") -- Get filename without extension
            vim.cmd("split | term clang++ % " .. compile_flags .. " -o %:r && ./" .. filename)
        end, { noremap = true, silent = true, desc = "Compile & Run C++ in Terminal", buffer = true })

        map("n", "<leader>cbc", function()
            vim.cmd("w")
            vim.cmd("split | term clang++ % " .. compile_flags .. " -o %:r")
        end, { noremap = true, silent = true, desc = "Compile C++ Code", buffer = true })

        map("n", "<leader>cbd", function()
            vim.cmd("w")
            local filename = vim.fn.expand("%:t:r") -- Get filename without extension
            vim.cmd("split | term clang++ % " .. compile_flags .. " -o %:r && lldb ./" .. filename)
        end, { noremap = true, silent = true, desc = "Compile & Debug C++ in LLDB", buffer = true })
    end,
})

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

-- Testing centering cursor
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

local function get_default_branch_name()
  local res = vim.system({ "git", "rev-parse", "--verify", "main" }, { capture_output = true }):wait()
  return res.code == 0 and "main" or "master"
end

vim.keymap.set("n", "<leader>gdb", function() vim.cmd("DiffviewOpen " .. get_default_branch_name()) end, { desc = "Diff against master" })

vim.keymap.set("n", "<leader>gdd", "<cmd>DiffviewOpen<cr>", { desc = "Diff view" })
vim.keymap.set("v", "<leader>gdd", "<Esc><cmd>'<,'>DiffviewFileHistory --follow<cr>", { desc = "Range history" })
vim.keymap.set("n", "<leader>gdc", ":DiffviewOpen ", { desc = "Diff custom" })
vim.keymap.set("n", "<leader>gdhf", "<cmd>DiffviewFileHistory --follow %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gdhd", "<cmd>DiffviewFileHistory %:p:h<cr>", { desc = "Directory history" })
vim.keymap.set("n", "<leader>gdhg", "<cmd>DiffviewFileHistory<cr>", { desc = "Global history" })

