-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local fn = vim.fn

-- General Settings
local general = augroup("General", { clear = true })

autocmd("FileType", {
    pattern = "*",
    callback = function()
        -- Disable comment on new line
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
    group = general,
    desc = "Disable New Line Comment",
})

-- autocmd({ "FocusLost", "BufLeave", "BufWinLeave", "InsertLeave" }, {
--     -- nested = true, -- for format on save
--     callback = function()
--         if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
--             vim.cmd("silent! w")
--         end
--     end,
--     group = general,
--     desc = "Auto Save",
-- })

autocmd({ "BufLeave", "FocusLost" }, {
    callback = function()
        if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
            vim.api.nvim_command("silent update")
        end
    end,
    group = general,
    desc = "Auto Save",
})
autocmd("FocusGained", {
    callback = function()
        vim.cmd("checktime")
    end,
    group = general,
    desc = "Update file when there are changes",
})

autocmd("VimResized", {
    callback = function()
        vim.cmd("wincmd =")
    end,
    group = general,
    desc = "Equalize Splits",
})

autocmd("FileType", {
    pattern = { "gitcommit", "markdown", "text", "log" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    group = general,
    desc = "Enable Wrap in these filetypes",
})

-- Restore cursor to file position in previous editing session
autocmd("BufReadPost", {
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            vim.cmd('normal! g`"zz')
        end
    end,
})

-- Auto resize splits when the terminal's window is resized
autocmd({ "VimResized" }, {
    group = augroup("EqualizeSplits", {}),
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        vim.cmd("tabdo wincmd =")
        vim.api.nvim_set_current_tabpage(current_tab)
    end,
    desc = "Resize splits with terminal window",
})

-- Autocreate a dir when saving a file
autocmd("BufWritePre", {
    desc = "Autocreate a dir when saving a file",
    group = augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- Use 'q' to close special buffer types. '' catches a lot of transient plugin windows.
autocmd({ "BufEnter" }, {
    callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype
        local types = { "help", "fugitive", "checkhealth", "vim", "" }
        for _, b in ipairs(types) do
            if filetype == b then
                vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "", {
                    callback = function()
                        vim.api.nvim_command("close")
                    end,
                })
            end
        end
    end,
})

-- Set nowrap if window is less than textwidth
autocmd("WinResized", {
    pattern = "*",
    callback = function()
        local win_width = vim.api.nvim_win_get_width(0)
        local text_width = vim.opt.textwidth._value
        local wide_enough = win_width < text_width + 1
        vim.api.nvim_set_option_value("wrap", wide_enough, {})
    end,
})

-- Persistence fold
local view_group = augroup("auto_view", { clear = true })
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
    desc = "Save view with mkview for real files",
    group = view_group,
    callback = function(args)
        if vim.b[args.buf].view_activated then
            vim.cmd.mkview({ mods = { emsg_silent = true } })
        end
    end,
})
autocmd("BufWinEnter", {
    desc = "Try to load file view if available and enable view saving for real files",
    group = view_group,
    callback = function(args)
        if not vim.b[args.buf].view_activated then
            local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
            local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
            local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
            if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
                vim.b[args.buf].view_activated = true
                vim.cmd.loadview({ mods = { emsg_silent = true } })
            end
        end
    end,
})
vim.api.nvim_create_autocmd("User", {
    pattern = "MarkviewAttach",
    callback = function(event)
        --- This will have all the data you need.
        local data = event.data

        vim.print(data)
    end,
})

-- vim.api.nvim_create_autocmd("TermOpen", {
--     callback = function()
--         local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or vim.fn.expand("%:p:h")
--         if root and root ~= "" then
--             vim.cmd("lcd " .. root)
--         end
--     end,
-- })
