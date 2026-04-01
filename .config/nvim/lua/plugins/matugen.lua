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
          colors.bg_search = "#c0c4eb"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#57d6f6"
          colors.blue0 = "#004e5e"
          colors.blue1 = "#57d6f6"
          colors.blue2 = "#57d6f6"
          colors.blue5 = "#57d6f6"
          colors.blue6 = "#57d6f6"
          colors.blue7 = "#57d6f6"
          colors.cyan = "#b2cbd3"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#c0c4eb"
          colors.green1 = "#c0c4eb"
          colors.green2 = "#c0c4eb"
          colors.hint = "#b2cbd3"
          colors.info = "#57d6f6"
          colors.magenta = "#c0c4eb"
          colors.magenta2 = "#c0c4eb"
          colors.orange = "#ffb4ab"
          colors.purple = "#57d6f6"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#b2cbd3"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#b2cbd3"
        end,
      }
    end,
  }
}
