#! /usr/bin/python3
# :>
#  $$$$$$\    $$\     $$\ $$\           $$\      $$\ $$\      $$\ 
# $$  __$$\   $$ |    \__|$$ |          $$ | $\  $$ |$$$\    $$$ |
# $$ /  $$ |$$$$$$\   $$\ $$ | $$$$$$\  $$ |$$$\ $$ |$$$$\  $$$$ |
# $$ |  $$ |\_$$  _|  $$ |$$ |$$  __$$\ $$ $$ $$\$$ |$$\$$\$$ $$ |
# $$ |  $$ |  $$ |    $$ |$$ |$$$$$$$$ |$$$$  _$$$$ |$$ \$$$  $$ |
# $$ $$\$$ |  $$ |$$\ $$ |$$ |$$   ____|$$$  / \$$$ |$$ |\$  /$$ |
# \$$$$$$ /   \$$$$  |$$ |$$ |\$$$$$$$\ $$  /   \$$ |$$ | \_/ $$ |
#  \___$$$\    \____/ \__|\__| \_______|\__/     \__|\__|     \__|
#      \___|                                                      
# :>
#----------------------------------------------------
# Author: Mirza Mahrab Hossain
# Email	: mahrjose.dev@gmail.com
# Github: https://github.com/Mahrjose/dotfiles
#----------------------------------------------------


import os
import subprocess

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

import colors


# mod4 is the window key / super key
mod = "mod4"
# mod1 is the left 'alt' key
alt = "mod1"

# My Softwares
terminal = "alacritty"
browser = "google-chrome-stable"
videoPlayer = "vlc"
primaryMenu = "rofi -show drun"


keys = [
    # =============================================================================== #
    #                     >> Switch between windows <<                                #
    # =============================================================================== #
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([alt], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # ============================================================================== #
    #  Move windows between left/right columns or move up/down in current stack.     #
    #  Moving out of range in Columns layout will create new column.                 #
    # ============================================================================== #
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # ============================================================================== #
    # RESIZE windows. If current window is on the edge of screen and direction       #
    # will be to screen edge - window would shrink.                                  #
    # ============================================================================== #
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # ============================================================================== #
    # Toggle between split and unsplit sides of stack.                               #
    # Split = all windows displayed                                                  #
    # Unsplit = 1 window displayed, like Max layout, but still with                  #
    # multiple stack panes                                                           #
    # ============================================================================== #
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # ============================================================================== #
    # Toggle between different layouts as defined below                              #
    # ============================================================================== #
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([alt, "control"], "Right", lazy.screen.next_group(skip_empty=True), desc="Change workspace to right"),
    Key([alt, "control"], "Left",lazy.screen.prev_group(skip_empty=True), desc="Change workspace to left"),

    # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
    # =============================================================================== #
    #                         Personalize Keybindings                                 #
    # =============================================================================== #
    # +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
    #
    # Terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Browser
    Key([mod, "shift"], "b", lazy.spawn(browser), desc="Launch Default Browser"),
    # rofi
    Key([mod], "space", lazy.spawn(primaryMenu), desc="Launch rofi"),
    #
    # =============================================================================== #
    #                       >> Dedicatd Volume key controls <<                        #
    #                         Volume Up, Volume Down & Mute                           #
    # =============================================================================== #
    #
    Key(
       [],
       "XF86AudioLowerVolume",
       lazy.spawn("amixer sset Master 5%-"),
       desc="Lower Volume by 5%",
    ),
    Key(
       [],
       "XF86AudioRaiseVolume",
       lazy.spawn("amixer sset Master 5%+"),
       desc="Raise Volume by 5%",
    ),
    Key(
       [],
       "XF86AudioMute",
       lazy.spawn("amixer sset Master 1+ toggle"),
       desc="Mute/Unmute Volume",
    ),
    # =============================================================================== #
    #                         Audio Play, Pause, Next                                 #
    # =============================================================================== #
    Key(
       [],
       "XF86AudioPlay",
       lazy.spawn("playerctl play-pause"),
       desc="Play/Pause player",
    ),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Skip to next"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Skip to previous"),
    # =============================================================================== #
    #                       Brightness Up & Brightness Down                           #
    # =============================================================================== #
    Key([], "XF86MonBrightnessUp", lazy.spawn("lux -a 5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("lux -s 5%")),
]

group_layout = "bsp"
groups = [
    Group(name = "1",label = " ", layout=group_layout),
    Group(name = "2",label = " ", layout=group_layout),
    Group(name = "3",label = " ", layout=group_layout),
    Group(name = "4",label = " ", layout=group_layout),
    Group(name = "5",label = " ", layout=group_layout),
    Group(name = "6",label = " ", layout=group_layout),
    Group(name = "7",label = " ", layout=group_layout),
    Group(name = "8",label = " ", layout=group_layout),
    Group(name = "9",label = " ", layout=group_layout),
]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod], i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"], i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


# Setting up default border themes
def init_layout_theme(max=False):
    if max:
        return {
        'margin': 10,
        'border_width': 3,
        'border_focus': '#0DE77C',
    }
    else:
        return {
            'margin': 8,
            'border_width': 3,
            'border_focus': '#5e81ac',
            'border_normal': '#4c566a'
        }
        


layout_theme = init_layout_theme()
max_layout_theme = init_layout_theme(max=True)

layouts = [
    layout.Max(**max_layout_theme),
    layout.Columns(**layout_theme),

    # Try more layouts by unleashing below layouts.
    # layout.Bsp(**layout_theme),
    # layout.MonadTall(**layout_theme),
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.floating.Floating(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

colors, backgroundColor, foregroundColor, workspaceColor, foregroundColorTwo = colors.dracula()

widget_defaults = dict(
    font = "Hack",
    fontsize = 12,
    padding = 2,
    background = backgroundColor
)
extension_defaults = widget_defaults.copy()

# Screens & Widget related fuctions
def shortenWindowName(text):
    nameArr = text.split(" - ")
    return nameArr[-1]

# Creating the screen
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename = './icons/ArchLinux_Logo.png',
                    scale = 'False',
                    margin_x = 4,
                    # mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(file_launcher2)}
                ),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),
                widget.GroupBox(
                    padding = 2,
					active = colors[2],
                    inactive = colors[1],
                    highlight_color = [backgroundColor, workspaceColor],
                    highlight_method = 'line',
                ),                
                # widget.Sep(
                #     linewidth = 2,
                #     padding = 1,
                #     foreground = '#f8f8f2'
                # ),
                # widget.CurrentLayout(
				# 	scale = 0.6,
                # ),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),
                widget.Prompt(),
                widget.WindowName(
                    font = 'Ubuntu Bold',
                    parse_text = shortenWindowName
                ),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                # Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),                
                widget.Net(
                    font = "Ubuntu Bold",
                    interface='wlo1',
                    format = ' NET: {down} ↓↑ {up}',
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn('connman-gtk')},
                    foreground = colors[6],
                ),
                widget.Sep(
                    linewidth = 2,
                    padding = 3,
                    foreground = '#f8f8f2'
                ),
                widget.CPU(
                    font = "Ubuntu Bold",
                    format = 'CPU: {load_percent}%',
                    foreground = colors[10],
                    padding = 13,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
                ),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),
                widget.Memory(
                    font = "Ubuntu Bold",
                    foreground = colors[4],
                    fmt = 'RAM: {}',
                    padding = 8,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
                ),
                widget.Sep(
                    linewidth = 2,
                    padding = 2,
                    foreground = '#f8f8f2'
                ),
                widget.Volume(
                    fmt = ' {}',
                    padding = 8,
                    foreground = colors[8],
                    ),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),

                widget.Battery(
                    charge_char ='',
                    discharge_char = '',
                    format = '  {percent:2.0%} {char}',
                    foreground = colors[5],
                    padding = 8,
                ),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),
                #widget.Clock(format="%d-%m %a %I:%M %p", background = foregroundColorTwo),
                 widget.Clock(format=' %a, %d/ %m/ %Y. |  %I:%M %p',
					foreground = colors[2],
                    background = backgroundColor,
					padding = 8
				),
                widget.Sep(
                    linewidth = 2,
                    padding = 4,
                    foreground = '#f8f8f2'
                ),
                # widget.QuickExit(background = foregroundColorTwo),
				widget.QuickExit(
					fmt = ' ',
					foreground = colors[9],
					padding = 8
					),   
                
            ],
            23,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)

# This script will start on log in
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([home])


auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
