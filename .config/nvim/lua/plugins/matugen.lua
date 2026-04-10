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
          colors.bg_search = "#d1bfe7"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#91cdff"
          colors.blue0 = "#004b72"
          colors.blue1 = "#91cdff"
          colors.blue2 = "#91cdff"
          colors.blue5 = "#91cdff"
          colors.blue6 = "#91cdff"
          colors.blue7 = "#91cdff"
          colors.cyan = "#b8c8d9"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#d1bfe7"
          colors.green1 = "#d1bfe7"
          colors.green2 = "#d1bfe7"
          colors.hint = "#b8c8d9"
          colors.info = "#91cdff"
          colors.magenta = "#d1bfe7"
          colors.magenta2 = "#d1bfe7"
          colors.orange = "#ffb4ab"
          colors.purple = "#91cdff"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#b8c8d9"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#b8c8d9"
        end,
      }
    end,
  }
}
