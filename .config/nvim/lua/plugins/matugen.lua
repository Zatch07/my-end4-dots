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
          colors.bg_search = "#bcc5eb"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#51d7ee"
          colors.blue0 = "#004e59"
          colors.blue1 = "#51d7ee"
          colors.blue2 = "#51d7ee"
          colors.blue5 = "#51d7ee"
          colors.blue6 = "#51d7ee"
          colors.blue7 = "#51d7ee"
          colors.cyan = "#b1cbd1"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#bcc5eb"
          colors.green1 = "#bcc5eb"
          colors.green2 = "#bcc5eb"
          colors.hint = "#b1cbd1"
          colors.info = "#51d7ee"
          colors.magenta = "#bcc5eb"
          colors.magenta2 = "#bcc5eb"
          colors.orange = "#ffb4ab"
          colors.purple = "#51d7ee"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#b1cbd1"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#b1cbd1"
        end,
      }
    end,
  }
}
