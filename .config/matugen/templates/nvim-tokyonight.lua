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
          colors.bg = "{{colors.surface}}"
          colors.fg = "{{colors.on_surface}}"
          colors.bg_dark = "{{colors.surface_variant}}"
          colors.bg_float = "{{colors.surface}}"
          colors.bg_highlight = "{{colors.surface_container_highest}}"
          colors.bg_popup = "{{colors.surface_container}}"
          colors.bg_search = "{{colors.tertiary}}"
          colors.bg_sidebar = "{{colors.surface_container_low}}"
          colors.bg_statusline = "{{colors.surface_container}}"
          colors.bg_visual = "{{colors.surface_variant}}"
          colors.border = "{{colors.outline}}"
          colors.fg_dark = "{{colors.on_surface_variant}}"
          colors.fg_float = "{{colors.on_surface}}"
          colors.fg_gutter = "{{colors.outline_variant}}"
          colors.fg_sidebar = "{{colors.on_surface_variant}}"
          colors.blue = "{{colors.primary}}"
          colors.blue0 = "{{colors.primary_container}}"
          colors.blue1 = "{{colors.primary}}"
          colors.blue2 = "{{colors.primary}}"
          colors.blue5 = "{{colors.primary}}"
          colors.blue6 = "{{colors.primary}}"
          colors.blue7 = "{{colors.primary}}"
          colors.cyan = "{{colors.secondary}}"
          colors.dark3 = "{{colors.surface_variant}}"
          colors.dark5 = "{{colors.surface_variant}}"
          colors.error = "{{colors.error}}"
          colors.green = "{{colors.tertiary}}"
          colors.green1 = "{{colors.tertiary}}"
          colors.green2 = "{{colors.tertiary}}"
          colors.hint = "{{colors.secondary}}"
          colors.info = "{{colors.primary}}"
          colors.magenta = "{{colors.tertiary}}"
          colors.magenta2 = "{{colors.tertiary}}"
          colors.orange = "{{colors.error}}"
          colors.purple = "{{colors.primary}}"
          colors.red = "{{colors.error}}"
          colors.red1 = "{{colors.error}}"
          colors.teal = "{{colors.secondary}}"
          colors.terminal_black = "{{colors.surface}}"
          colors.warning = "{{colors.error}}"
          colors.yellow = "{{colors.secondary}}"
        end,
      }
    end,
  }
}
