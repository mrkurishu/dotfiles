# Modded by mrkurishu

import os
import subprocess
from libqtile import bar, extension, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
# Make sure 'qtile-extras' is installed or this config will not work.
from qtile_extras import widget
from qtile_extras.widget.decorations import BorderDecoration
from qtile_extras.widget import StatusNotifier
from qtile_extras.widget import CheckUpdates
from libqtile.widget import NvidiaSensors
from qtile_extras.widget import Mpris2
import colors
import itertools

mod = "mod4"
myTerm = "alacritty"
myBrowser = "firefox"
doomemacs = "emacsclient -c -a 'emacs' "


# Allows you to input a name when adding treetab section.
@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)

# A function for hide/show all the windows in a group
@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()

# A function for toggling between MAX and MONADTALL layouts
@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == 'monadtall':
        qtile.current_group.layout = 'max'
    elif current_layout_name == 'max':
        qtile.current_group.layout = 'monadtall'


keys = [
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    Key([mod], "b", lazy.spawn(myBrowser), desc='Web browser'),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod],  "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Dmenu
    Key([ "mod4", "shift" ], "Return", lazy.spawn("bash -c '~/.local/bin/dmenu_run_i.sh'"), desc="Dmenu Run"),
    Key([mod], "a", lazy.spawn("bash -c '~/.local/bin/dmenu_audio_switch.sh'"), desc="Switch Audio output"),
    Key([mod], "p", lazy.spawn("bash -c '~/.local/bin/dmenu_pass.sh'"), desc="Launches passmenu+otp and clipboard pass"),
    Key([mod], "F8", lazy.spawn("bash -c '~/.local/bin/toogle_music_play_stop.sh'"), desc="Play/Stop music"),
    Key([ "mod4", "shift" ], "n", lazy.spawn("bash -c '~/.local/bin/dmenu_notes.sh'"), desc="Dmenu QuickNote"),

    # Function keys
    Key([mod], "F9", lazy.spawn("slock"), desc="Lock session"),
    Key([mod], "F10", lazy.spawn("amixer sset Master toggle"), desc="Toggle mute/unmute vol"),
    Key([mod], "F11", lazy.spawn("amixer sset Master 5%-"), desc="Decrease volume"),
    Key([mod], "F12", lazy.spawn("amixer sset Master 5%+"), desc="Increse volume"),
    Key([mod], "F1", lazy.spawn('amixer sset "Capture Switch" toggle'), desc="Toggle mute mic/unmute"),

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Search word dictionary
    Key([mod], "d", lazy.spawn("/home/kurishu/.local/bin/defineword.sh"), desc='Search word on dictionary online'),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab"),

    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab"),

    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab"
    ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab"
    ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "space", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Treetab prompt
    Key([mod, "shift"], "a", add_treetab_section, desc='Prompt to add new section in treetab'),

    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key([mod], "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
    ),
    Key([mod], "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
    ),

    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc='Toggle between min and max sizes'),
    Key([mod], "t", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod], "f", maximize_by_switching_layout(), lazy.window.toggle_fullscreen(), desc='toggle fullscreen'),
    Key([mod, "shift"], "m", minimize_all(), desc="Toggle hide/show all windows on current group"),

    # Switch focus of monitors
    #Key([mod], "period", lazy.next_screen(), desc='Move focus to next monitor'),
    #Key([mod], "comma", lazy.prev_screen(), desc='Move focus to prev monitor'),

    #Apps
    Key([mod], "s", lazy.spawn("signal-desktop"), desc="Launch or focus Signal Desktop"),
    #LF explorer
    Key([mod], 'masculine', lazy.spawn("alacritty -e /home/kurishu/.local/bin/lfub")),

]

# Media animation icons for audio output playing
media_icons = itertools.cycle([
    "⠋", "⠙", "⠹", "⠸",
    "⠼", "⠴", "⠦", "⠧",
    "⠇", "⠏"

    ])


def get_animated_media():
    try:
        players = subprocess.run(
            ["playerctl", "-l"],
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            timeout=0.5,
        ).stdout.decode().splitlines()

        for player in players:
            title = subprocess.run(
                ["playerctl", "--player=" + player, "metadata", "--format", "{{title}} - {{artist}}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                timeout=0.5,
            ).stdout.decode().strip()

            if title:
                icon = next(media_icons)
                return f"{icon} {title}"
    except Exception:
        pass
    return "⏸ Not Playing"


groups = []
group_names = ["1", "2", "9", "0",]

group_labels = ["1", "2", "9", "0",]

group_layouts = ["monadtall", "monadtall", "tile", "tile"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=False),
                desc="Move focused window to group {}".format(i.name),
            ),
        ]
    )

colors = colors.GruvboxDark

layout_theme = {"border_width": 4,
                "margin": 10,
                "border_focus": colors[8],
                "border_normal": colors[0]
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.Tile(
         shift_windows=True,
         border_width = 0,
         margin = 0,
         ratio = 0.335,
         ),
    layout.Max(
         border_width = 0,
         margin = 0,
         ),
]

widget_defaults = dict(
    font="Fira Code Bold",  # Updated to Fira Code Bold
    fontsize = 22,
    padding = 0,
    background=colors[0]
)

extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
       widget.Prompt(
                 font = "Fira Code",  # Updated to Fira Code
                 fontsize=22,
                 foreground = colors[1]
        ),
        widget.GroupBox(
                 fontsize = 22,
                 margin_y = 5,
                 margin_x = 5,
                 padding_y = 0,
                 padding_x = 1,
                 borderwidth = 3,
                 active = colors[8],
                 inactive = colors[1],
                 rounded = False,
                 highlight_color = colors[2],
                 highlight_method = "block",
                 this_current_screen_border = colors[7],
                 this_screen_border = colors [4],
                 other_current_screen_border = colors[7],
                 other_screen_border = colors[4],
                 ),
        widget.TextBox(
                 text = '|',
                 font = "Fira Code",  # Updated to Fira Code
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 18
                 ),
        widget.CurrentLayoutIcon(
                 # custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                 foreground = colors[1],
                 padding = 4,
                 scale = 0.9
                 ),

       widget.TextBox(
                 text = '|',
                 font = "Fira Code",  # Updated to Fira Code
                 foreground = colors[1],
                 padding = 2,
                 fontsize = 18
                 ),
        widget.WindowName(
                 foreground = colors[6],
                 max_chars = 40
                 ),
        widget.Spacer(length = 8),

        widget.GenPollText(
                update_interval=0.5,  # Faster = smoother animation
                font="Fira Code",
                fontsize=20,
                foreground=colors[6],
                func=get_animated_media,
                ),

        widget.Spacer(length = 10),

        widget.GenPollText(
                foreground = colors[1],
                update_interval=1800,  # updates every 30 minutes
                func=lambda: subprocess.check_output(
                ["curl", "-s", "wttr.in/andorra?format=%c+%t+%h+%p+%w+%m"]
                ).decode("utf-8").strip(),
                name="weather",
                fmt="|{} |",
                decorations=[
                     BorderDecoration(
                         colour = colors[8],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                ),

        widget.Spacer(length = 10),

        widget.CPU(
                format = 'CPU:{load_percent}%',
                 foreground = colors[1],
                 decorations=[
                     BorderDecoration(
                         colour = colors[4],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 10),
        widget.Memory(
                 foreground = colors[1],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e btop')},
                 format = '{MemUsed:.0f}{mm}',
                 measure_mem='G',
                 fmt = 'RAM:{}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[8],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 10),
        widget.DF(
                 update_interval = 60,
                 foreground = colors[1],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
                 partition = '/',
                 format = '{uf}{m}({r:.0f}%)',
                 #format = '{uf}{m} free',
                 #format = '{r:.0f}% {uf}/{total} ({uf}/{total})',
                 fmt = 'SSD:{}',
                 visible_on_warn = False,
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),
        widget.Spacer(length = 8),
        widget.DF(
                 update_interval = 60,
                 foreground = colors[1],
                 mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e df')},
                 partition = '/home',
                 format = '{uf}{m}({r:.0f}%)',
                 #format = '{uf}{m} free',
                 #format = '{r:.0f}% {uf}/{total} ({uf}/{total})',
                 fmt = 'NVME:{}',
                 visible_on_warn = False,
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),
       widget.Spacer(length = 10),

NvidiaSensors(
        format='GPU:{temp}°C |',
        foreground = colors[1],
        update_interval=2,
        foreground_alert='ff0000',
        decorations=[
                BorderDecoration(
                colour = colors[5],
                border_width = [0, 0, 0, 0],
                )
        ],
        func=lambda: 'ff0000' if int(subprocess.check_output(["nvidia-smi", "--query-gpu=temperature.gpu", "--format=csv,noheader,nounits"]).strip()) >= 80 else colors[1]

        ),

       widget.Spacer(length = 14),


widget.Volume(
                foreground = colors[1],
                fmt='{}',
                emoji=True,
                emoji_list=['🔇', '🔈', '🔉', '🔊'],
                theme_path='/usr/share/icons/Papirus-Dark/',
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),

widget.Volume(
                 foreground = colors[1],
                 fmt='{}',
                 decorations=[
                     BorderDecoration(
                         colour = colors[5],
                         border_width = [0, 0, 0, 0],
                     )
                 ],
                 ),


widget.Spacer(length = 3),
        widget.Clock(
                 foreground = colors[6],
                 format = "  %a, %d %b - %H:%M:%S",
                 ),
        widget.Spacer(length = 8),
        widget.Systray(
                padding = 9,
                icon_size=31
                ),
        widget.Spacer(length = 8),

        ]
    return widgets_list

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).
def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    del widgets_screen2[22:24]
    return widgets_screen2

# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=32)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=32)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=32))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.windows_map[qtile.currentWindow.window].group = qtile.groups[i-1]

def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)

def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)

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
    border_focus=colors[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),   # gitk
        Match(wm_class="dialog"),         # dialog boxes
        Match(wm_class="download"),       # downloads
        Match(wm_class="error"),          # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class='kdenlive'),       # kdenlive
        Match(wm_class="makebranch"),     # gitk
        Match(wm_class="maketag"),        # gitk
        Match(wm_class="notification"),   # notifications
        Match(wm_class='pinentry-gtk-2'), # GPG key password entry
        Match(wm_class="ssh-askpass"),    # ssh-askpass
        Match(wm_class="toolbar"),        # toolbars
        Match(wm_class="Yad"),            # yad boxes
        Match(title="branchdialog"),      # gitk
        Match(title='Confirmation'),      # tastyworks exit box
        Match(title='Qalculate!'),        # qalculate-gtk
        Match(title="pinentry"),          # GPG key password entry
        Match(title="tastycharts"),       # tastytrade pop-out charts
        Match(title="tastytrade"),        # tastytrade pop-out side gutter
        Match(title="tastytrade - Portfolio Report"), # tastytrade pop-out allocation
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"), # tastytrade settings
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

wmname = "LG3D"

# Open mpv in fullscreen mode
@hook.subscribe.startup
def startup():
   for window in qtile.windows_map.values():
        if window.window.get_wm_class() == ('mpv', 'mpv'):
            window.fullscreen = True

# END
