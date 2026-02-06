from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class Kanagawa(ColorScheme):
    progress_bar_color = 7  # Accent

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        # Browser
        if context.in_browser:
            fg = 223  # #DCD7BA

            if context.selected:
                attr |= reverse

            if context.marked:
                attr |= bold

            if context.main_column:
                fg = 75  # Accent #7E9CD8

        # Titlebar
        if context.in_titlebar:
            fg = 75  # Accent
            attr |= bold

        # Statusbar
        if getattr(context, "in_statusbar", False):
            bg = 236
            fg = 223

        # Error messages
        if context.error:
            fg = 167  # Red #E46876
            attr |= bold

        # Marks
        if context.marked:
            fg = 108  # Green #98BB6C
            attr |= bold

        # Directories
        if context.directory:
            fg = 180  # Secondary #C0A36E
            attr |= bold

        # Executables
        if context.executable:
            fg = 75  # Accent
            attr |= bold

        return fg, bg, attr

