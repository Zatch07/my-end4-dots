local map = vim.keymap.set

-- 1. Undo/Redo (Standard Ctrl+Z/Y)
map("n", "<C-z>", "u", { desc = "Undo" })
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })
map("v", "<C-z>", "<Esc>u", { desc = "Undo" })

map("n", "<C-y>", "<C-r>", { desc = "Redo" })
map("i", "<C-y>", "<C-o><C-r>", { desc = "Redo" })

-- 2. Save (Standard Ctrl+S)
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("i", "<C-s>", "<C-o>:w<cr>", { desc = "Save" })

-- 3. Select All (Standard Ctrl+A)
map({ "n", "v" }, "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- 4. Clipboard: Cut, Copy, Paste (Ctrl+X, C, V)
map("v", "<C-x>", '"+x', { desc = "Cut" })
map("v", "<C-c>", '"+y', { desc = "Copy" })

-- Paste logic (Uses + register for system clipboard)
map("n", "<C-v>", '"+p', { desc = "Paste" })
map("v", "<C-v>", '"+p', { desc = "Paste" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })

-- 5. Shift + Arrows to Select (CUA Style)
-- From Normal/Insert: Enter visual mode and move
map({ "n", "i" }, "<S-Up>", "<Esc>v<Up>", { desc = "Select Up" })
map({ "n", "i" }, "<S-Down>", "<Esc>v<Down>", { desc = "Select Down" })
map({ "n", "i" }, "<S-Left>", "<Esc>v<Left>", { desc = "Select Left" })
map({ "n", "i" }, "<S-Right>", "<Esc>v<Right>", { desc = "Select Right" })

-- From Visual: Just move to extend the selection
map("v", "<S-Up>", "<Up>", { desc = "Extend Selection Up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend Selection Down" })
map("v", "<S-Left>", "<Left>", { desc = "Extend Selection Left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend Selection Right" })

-- 6. Backspace to delete selection in Visual mode
map("v", "<BS>", "d", { desc = "Delete selection" })

-- 7. Word-by-Word Navigation (Ctrl + Arrows)
map("n", "<C-Left>", "b", { desc = "Move word back" })
map("n", "<C-Right>", "w", { desc = "Move word forward" })
map("i", "<C-Left>", "<C-o>b", { desc = "Move word back" })
map("i", "<C-Right>", "<C-o>w", { desc = "Move word forward" })

-- 8. Word-by-Word Deletion (Ctrl + Backspace)
-- Note: Mapped to both <C-BS> and <C-H> because terminals vary
map("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })
map("i", "<C-H>", "<C-w>", { desc = "Delete word backward" })
map("i", "<C-Delete>", "<C-o>dw", { desc = "Delete word forward" })

-- 9. Ctrl + Shift + Arrows (Word-by-word selection)
-- From Insert Mode
map("i", "<C-S-Left>", "<Esc>vb", { desc = "Select word back" })
map("i", "<C-S-Right>", "<Esc>ve", { desc = "Select word forward" })

-- From Visual Mode (to keep extending the selection)
map("v", "<C-S-Left>", "b", { desc = "Extend selection word back" })
map("v", "<C-S-Right>", "e", { desc = "Extend selection word forward" })

-- From Normal Mode
map("n", "<C-S-Left>", "vb", { desc = "Select word back" })
map("n", "<C-S-Right>", "ve", { desc = "Select word forward" })

-- Toggle Sidebar by sending "Space f e" (Simulates a human typing)
-- Toggle the "Reveal" version of the tree (Shows .config and hidden folders)
vim.keymap.set({ "n", "i", "v" }, "<C-`>", function()
  -- 1. Force the plugin to wake up
  require("lazy").load({ plugins = { "neo-tree.nvim" } })
  -- 2. Execute the toggle with the "reveal" flag
  vim.cmd("Neotree filesystem reveal toggle")
end, { desc = "Toggle Explorer (Reveal Mode)" })


-- Save and Exit (Alt + S)
vim.keymap.set({ "n", "i", "v" }, "<A-s>", "<Esc>:wq<cr>", { desc = "Save and Exit" })

-- Quit Without Saving (Alt + Q)
vim.keymap.set({ "n", "i", "v" }, "<A-q>", "<Esc>:q!<cr>", { desc = "Quit without saving" })

-- Toggle Focus between Neo-tree and Editor (Alt + w)
vim.keymap.set({ "n", "i", "v" }, "<A-w>", function()
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft == "neo-tree" then
    vim.cmd("wincmd l")      -- Jump right to the editor
  else
    vim.cmd("Neotree focus") -- Jump to the sidebar
  end
end, { desc = "Toggle Window Focus" })