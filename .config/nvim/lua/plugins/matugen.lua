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
          colors.bg_search = "#d4c78e"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#ffb598"
          colors.blue0 = "#7b2f09"
          colors.blue1 = "#ffb598"
          colors.blue2 = "#ffb598"
          colors.blue5 = "#ffb598"
          colors.blue6 = "#ffb598"
          colors.blue7 = "#ffb598"
          colors.cyan = "#e7beae"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#d4c78e"
          colors.green1 = "#d4c78e"
          colors.green2 = "#d4c78e"
          colors.hint = "#e7beae"
          colors.info = "#ffb598"
          colors.magenta = "#d4c78e"
          colors.magenta2 = "#d4c78e"
          colors.orange = "#ffb4ab"
          colors.purple = "#ffb598"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#e7beae"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#e7beae"
        end,
      }
    end,
  }
}
