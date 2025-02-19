-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "[P]go to the end of the line" })
-- When you do joins with J it will keep your cursor at the beginning instead of at the end
vim.keymap.set({ "n", "v" }, "J", "mzJ`z")

-- Toggle executable permission on current file, previously I had 2 keymaps, to
-- add or remove exec permissions, now it's a toggle using the same keymap
vim.keymap.set("n", "<leader>fx", function()
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
        map("n", "<leader>cgr", function()
            vim.cmd("w")
            local filename = vim.fn.expand("%:t:r") -- Get filename without extension
            vim.cmd("split | term g++ % -o " .. filename .. " && ./" .. filename)
        end, { noremap = true, silent = true, desc = "Compile & Run C++ in Terminal", buffer = true })

        map("n", "<leader>cgc", function()
            vim.cmd("w")
            local filename = vim.fn.expand("%:t:r") -- Get filename without extension
            vim.cmd("split | term g++ % -o " .. filename)
        end, { noremap = true, silent = true, desc = "Compile & Run C++ in Terminal", buffer = true })

        map("n", "<leader>cgd", function()
            vim.cmd("w")
            local filename = vim.fn.expand("%:t:r") -- Get filename without extension
            vim.cmd("split | term g++ % -o " .. filename .. " && gdb ./" .. filename)
        end, { noremap = true, silent = true, desc = "Compile & Run C++ in Terminal", buffer = true })
    end,
})
