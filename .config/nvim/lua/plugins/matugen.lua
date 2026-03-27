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
          colors.bg = "#131313"
          colors.fg = "#e2e2e2"
          colors.bg_dark = "#474747"
          colors.bg_float = "#131313"
          colors.bg_highlight = "#353535"
          colors.bg_popup = "#1f1f1f"
          colors.bg_search = "#a1d0c4"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#bbd063"
          colors.blue0 = "#3f4c00"
          colors.blue1 = "#bbd063"
          colors.blue2 = "#bbd063"
          colors.blue5 = "#bbd063"
          colors.blue6 = "#bbd063"
          colors.blue7 = "#bbd063"
          colors.cyan = "#c5caa8"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#a1d0c4"
          colors.green1 = "#a1d0c4"
          colors.green2 = "#a1d0c4"
          colors.hint = "#c5caa8"
          colors.info = "#bbd063"
          colors.magenta = "#a1d0c4"
          colors.magenta2 = "#a1d0c4"
          colors.orange = "#ffb4ab"
          colors.purple = "#bbd063"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#c5caa8"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#c5caa8"
        end,
      }
    end,
  }
}
