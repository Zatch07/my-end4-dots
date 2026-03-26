return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- This removes the "search/tabs" bar from the top for a cleaner look
    source_selector = {
      winbar = true,
      statusline = true,
    },
    filesystem = {
      filtered_items = {
        visible = true,          -- Always show hidden folders
        hide_dotfiles = false,   -- Show .config, .git, etc.
        hide_gitignored = false, -- Show files ignored by git
      },
    },
  },
}