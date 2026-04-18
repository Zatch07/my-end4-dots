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
          colors.bg_search = "#afcfab"
          colors.bg_sidebar = "#1b1b1b"
          colors.bg_statusline = "#1f1f1f"
          colors.bg_visual = "#474747"
          colors.border = "#919191"
          colors.fg_dark = "#c6c6c6"
          colors.fg_float = "#e2e2e2"
          colors.fg_gutter = "#474747"
          colors.fg_sidebar = "#c6c6c6"
          colors.blue = "#f0c048"
          colors.blue0 = "#5a4300"
          colors.blue1 = "#f0c048"
          colors.blue2 = "#f0c048"
          colors.blue5 = "#f0c048"
          colors.blue6 = "#f0c048"
          colors.blue7 = "#f0c048"
          colors.cyan = "#d7c4a0"
          colors.dark3 = "#474747"
          colors.dark5 = "#474747"
          colors.error = "#ffb4ab"
          colors.green = "#afcfab"
          colors.green1 = "#afcfab"
          colors.green2 = "#afcfab"
          colors.hint = "#d7c4a0"
          colors.info = "#f0c048"
          colors.magenta = "#afcfab"
          colors.magenta2 = "#afcfab"
          colors.orange = "#ffb4ab"
          colors.purple = "#f0c048"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#d7c4a0"
          colors.terminal_black = "#131313"
          colors.warning = "#ffb4ab"
          colors.yellow = "#d7c4a0"
        end,
      }
    end,
  }
}
