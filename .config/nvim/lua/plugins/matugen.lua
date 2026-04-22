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
          colors.bg = "#11131a"
          colors.fg = "#e1e2eb"
          colors.bg_dark = "#424753"
          colors.bg_float = "#11131a"
          colors.bg_highlight = "#32353c"
          colors.bg_popup = "#1d2026"
          colors.bg_search = "#f4aeff"
          colors.bg_sidebar = "#191b22"
          colors.bg_statusline = "#1d2026"
          colors.bg_visual = "#424753"
          colors.border = "#8c909f"
          colors.fg_dark = "#c2c6d5"
          colors.fg_float = "#e1e2eb"
          colors.fg_gutter = "#424753"
          colors.fg_sidebar = "#c2c6d5"
          colors.blue = "#adc6ff"
          colors.blue0 = "#4d8efe"
          colors.blue1 = "#adc6ff"
          colors.blue2 = "#adc6ff"
          colors.blue5 = "#adc6ff"
          colors.blue6 = "#adc6ff"
          colors.blue7 = "#adc6ff"
          colors.cyan = "#b1c6f7"
          colors.dark3 = "#424753"
          colors.dark5 = "#424753"
          colors.error = "#ffb4ab"
          colors.green = "#f4aeff"
          colors.green1 = "#f4aeff"
          colors.green2 = "#f4aeff"
          colors.hint = "#b1c6f7"
          colors.info = "#adc6ff"
          colors.magenta = "#f4aeff"
          colors.magenta2 = "#f4aeff"
          colors.orange = "#ffb4ab"
          colors.purple = "#adc6ff"
          colors.red = "#ffb4ab"
          colors.red1 = "#ffb4ab"
          colors.teal = "#b1c6f7"
          colors.terminal_black = "#11131a"
          colors.warning = "#ffb4ab"
          colors.yellow = "#b1c6f7"
        end,
      }
    end,
  }
}
