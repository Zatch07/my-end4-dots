-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here



-- Start in Insert Mode every time a file is opened
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.cmd("startinsert")
  end,
})

-- Standard "Normal Editor" Options
vim.opt.clipboard = "unnamedplus"   -- Sync with system clipboard (needs wl-clipboard)
vim.opt.undofile = true            -- Persistent undo (even after closing nvim)

-- Seamless Navigation
vim.opt.whichwrap:append("<,>,[,],h,l") -- Arrows cross lines
vim.opt.backspace = { "indent", "eol", "start" }