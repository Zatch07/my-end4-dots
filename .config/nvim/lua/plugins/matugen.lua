return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      return {
        transparent = true, -- Matches Neovim background to Kitty background
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
        on_colors = function(colors)
          -- Inject Matugen Material You Colors Dynamically
          colors.bg = "#13140d"
          colors.fg = "#e4e3d7"
          colors.bg_dark = "#46483c"
          colors.bg_float = "#13140d"
          colors.bg_highlight = "#34352d"
          colors.bg_popup = "#1f2019"
          colors.bg_search = "#a1d0c4"
          colors.bg_sidebar = "#1b1c15"
          colors.bg_statusline = "#1f2019"
          colors.bg_visual = "#46483c"
          colors.border = "#919283"
          colors.fg_dark = "#c7c8b7"
          colors.fg_float = "#e4e3d7"
          colors.fg_gutter = "#46483c"
          colors.fg_sidebar = "#c7c8b7"
          colors.blue = "#bfce7f"
          colors.blue0 = "#404c09"
          colors.blue1 = "#bfce7f"
          colors.blue2 = "#bfce7f"
          colors.blue5 = "#bfce7f"
          colors.blue6 = "#bfce7f"
          colors.blue7 = "#bfce7f"
          colors.cyan = "#c5c9a8"
          colors.dark3 = "#46483c"
          colors.dark5 = "#46483c"
          colors.error = "#ffb4ab"
          colors.green = "#a1d0c4"
          colors.green1 = "#a1d0c4"
          colors.green2 = "#a1d0c4"
          colors.hint = "#c5c9a8"
          colors.info = "#bfce7f"
          colors.magenta = "#a1d0c4"
          colors.magenta2 = "#a1d0c4"
          colors.orange = "#ffb4ab"
          colors.purple = "#bfce7f"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#c5c9a8"
          colors.terminal_black = "#13140d"
          colors.warning = "#ffb4ab"
          colors.yellow = "#c5c9a8"
        end,
      }
    end,
  }
}
