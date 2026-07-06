local helpers = require("helpers")
local key_scripts = require("key_scripts")

local zen = "nixGL zen --profile"
--local zen_confined = "nixGL firejail --netns=${secrets.vpn.wg.alt.provider} zen --profile";
local terminal = "alacritty";
local fileManager = "dolphin";
local menu = "wofi --show drun --style ~/.config/hypr/wofi.css";
local personalBrowser = "~/scripts/browser.sh";
local schoolBrowser = zen .. " ~/.zen/schoolProfile";
local chat = "element-desktop";
local otherChat = "signal-desktop";
local alternativeBrowser = zen .. " ~/.zen/zs3f6ux8.viv";
local anotherBrowser = zen .. " ~/.zen/x4qqcuev";
local torBrowser = "tor-browser";
local togWaybar = "~/scripts/toggleWaybar.sh";
local noteProg = "obsidian";
local people_who_dont_use_signal = "discord";
local org_mode_is_pretty_good = "emacs";
local restart_waybar = "~/scripts/restart_waybar.sh";
local d_client = "~/scripts/d_client";
local do_not_disturb = "makoctl mode -t dnd";

hl.on("hyprland.start", function() hl.exec_cmd("~/scripts/start-hypr.sh") end)

hl.bind(
  "SUPER + T",
  hl.dsp.exec_cmd(terminal)
)
hl.bind(
  "SUPER + L",
  hl.dsp.exec_cmd("hyprlock")
)
hl.bind(
  "SUPER + escape",
  hl.dsp.window.kill()
)
hl.bind(
  "SUPER + M",
  key_scripts.mute_window
)
hl.bind(
  "SUPER + SHIFT + P",
  key_scripts.popup_pid
)
hl.bind(
  "SUPER + SHIFT + E",
  hl.dsp.exec_cmd(fileManager)
)
hl.bind(
  "SUPER + C",
  hl.dsp.exec_cmd(chat)
)
hl.bind(
  "SUPER + SHIFT + C",
  hl.dsp.exec_cmd(otherChat)
)
hl.bind(
  "SUPER + CTRL + D",
  hl.dsp.exec_cmd(do_not_disturb)
)
hl.bind(
  "SUPER + SHIFT + D",
  hl.dsp.exec_cmd(people_who_dont_use_signal)
)
hl.bind(
  "SUPER + V",
  hl.dsp.window.float({ action = "toggle" })
)
hl.bind(
  "SUPER + SHIFT + R",
  hl.dsp.exec_cmd("~/scripts/re_start-hypr.sh")
)
hl.bind(
  "SUPER + Space",
  hl.dsp.exec_cmd(menu)
)
hl.bind(
  "SUPER + J",
  hl.dsp.layout("togglesplit")
)
hl.bind(
  "SUPER + SHIFT + F",
  hl.dsp.exec_cmd(schoolBrowser)
)
hl.bind(
  "SUPER + D",
  hl.dsp.exec_cmd(d_client)
)
--hl.bind(
--  "SUPER + CTRL + SHIFT + F",
--  hl.dsp.exec_cmd(zen_confined .. '/home/super/.zen/confined_profile')
--)
hl.bind(
  "SUPER + F",
  hl.dsp.exec_cmd(personalBrowser)
)
hl.bind(
  "SUPER + CTRL + F",
  hl.dsp.exec_cmd(anotherBrowser)
)
hl.bind(
  "SUPER + ALT + F",
  hl.dsp.exec_cmd(alternativeBrowser)
)
hl.bind(
  "SUPER + ALT + SHIFT + F",
  hl.dsp.exec_cmd(torBrowser)
)
hl.bind(
  "SUPER + H",
  hl.dsp.exec_cmd("wpctl set-default 75")
)
hl.bind(
  "SUPER + S",
  hl.dsp.exec_cmd("~/scripts/./screenshot.sh")
)
hl.bind(
  "SUPER + SHIFT + S",
  hl.dsp.exec_cmd("~/scripts/./screenshot.sh select")
)
hl.bind(
  "SUPER + N",
  hl.dsp.exec_cmd(noteProg)
)
hl.bind(
  "SUPER + E",
  hl.dsp.exec_cmd(org_mode_is_pretty_good)
)
hl.bind(
  "SUPER + SHIFT + W",
  hl.dsp.exec_cmd(restart_waybar)
)
hl.bind(
  "SUPER + B",
  hl.dsp.exec_cmd(togWaybar)
)
hl.bind(
  "SUPER + CTRL + E",
  hl.dsp.layout("colresize 1")
)
hl.bind(
  "SUPER + CONTROL + S",
  hl.dsp.layout("colresize 0.5")
)

for i = 1, 10 do
  local key = i % 10
  hl.bind(
    "SUPER + " .. key,
    hl.dsp.focus({ workspace = i })
  )
  hl.bind(
    "SUPER + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i })
  )
end

for i, dir in ipairs({ "down", "up", "left", "right" }) do
  hl.bind(
    "SUPER + SHIFT + " .. dir,
    hl.dsp.window.move({ direction = dir })
  )
  hl.bind(
    "SUPER + " .. dir,
    hl.dsp.focus({ direction = dir })
  )
  hl.bind(
    "SUPER + SHIFT + CONTROL + " .. dir,
    hl.dsp.window.move({ monitor = dir:sub(1, 1) })
  )
  do
    local y = ((i <= 2) and 10 or 0) * ((i % 2 ~= 0) and -1 or 1)
    if y == -0 then y = 0 end

    local x = ((i > 2) and 10 or 0) * ((i % 2 ~= 0) and -1 or 1)
    if x == -0 then x = 0 end

    hl.bind(
      "SUPER + CONTROL + " .. dir,
      hl.dsp.window.resize({ x = x, y = y, relative = true }),
      { repeating = true }
    )
  end
  if i > 2 then
    hl.bind(
      "SUPER + ALT + " .. dir,
      hl.dsp.focus({ monitor = dir:sub(1, 1) })
    )
  end
end

--SUPER + vol-up/vol-down for just current window
for i, keys in ipairs({
  { "Page_Up", "XF86AudioRaiseVolume" },
  { "Page_Down", "XF86AudioLowerVolume" }
}) do
  local d = (i % 2 == 0) and "-" or "+"
  local one = function(k)
    hl.bind(
      "SUPER + " .. k,
      key_scripts.window_vol(d)
    )
  end
  local two = function(k)
    hl.bind(
      k,
      hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%" .. d),
      { locked = true, repeating = true }
    )
  end
  for _, k in ipairs(keys) do one(k) two(k) end
end

hl.bind(
  "XF86AudioMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioMicMute",
  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
  { locked = true, repeating = true }
)
hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  { locked = true }
)
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  { locked = true }
)
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 20,

    border_size = 2,

    -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
    col = {
      active_border = {
        colors = {
          "rgba(33ccffee)",
          "rgba(00ff99ee)"
        },
        angle = 45,
      },
      inactive_border = "rgba(595959aa)",
    },

    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = false,

    -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false,

    layout = "scrolling",
  },
  decoration = {
    rounding = 10,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = 0xee1a1a1a,
    },

    -- https://wiki.hyprland.org/Configuring/Variables/#blur
    blur = {
      enabled = true,
      size = 3,
      passes = 1,
      vibrancy = 0.1696,
    },
  },
  animations = {
    enabled = true,
  },
  cursor = {
    no_hardware_cursors = true,
    inactive_timeout= 1,
    hide_on_key_press = true,
  },
})

--  # https://wiki.hyprland.org/Configuring/Variables/#misc
--  misc = {
--    force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
--    disable_hyprland_logo = false;
--  };
--
--  # https://wiki.hyprland.org/Configuring/Variables/#input
--  input = {
--    kb_layout = "us";
--
--    # NOTE: this is now handled by kanata
--    # kb_options = "caps:swapescape";
--  
--    follow_mouse = 1;
--    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
--
--    touchpad = {
--      natural_scroll = false;
--    };
--  };
--
--  # See https://wiki.hyprland.org/Configuring/Environment-variables/
--  env = [
--    "HYPRCURSOR_THEME,Bibata-Modern-Ice"
--    "HYPRCURSOR_SIZE,12"
--    "XCURSOR_THEME,Bibata-Modern-Ice"
--    "XCURSOR_SIZE,12"
--  ];
--
--  # fixes cursor flickering and misalignment
--  cursor = {
--    no_hardware_cursors = true;
--  };
--
--  # See https://wiki.hyprland.org/Configuring/Permissions/
--  # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
--  # for security reasons
--  ecosystem = {
--  #   enforce_permissions = 1;
--    no_update_news = true;
--  };
--
--  windowrule = builtins.map new_anonrule [
--    # Ignore maximize requests from apps. You'll probably like this.
--    {
--      "match:class" = ".*";
--      suppress_event = "maxmize";
--    }
--    # Fix some dragging issues with XWayland
--    {
--      "match:class" = "^$";
--      "match:title" = "^$";
--      "match:xwayland" = true;
--      "match:float" = true;
--      "match:fullscreen" = true;
--      "match:pin" = true;
--      no_focus = true;
--    }
--  ];

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
hl.monitor({ --nice-ish monitor (remains at home setup)
  output = "desc:LG Electronics LG ULTRAGEAR 209NTNH3L775",
  mode = "preferred",
  position = "0x0",
  scale = 1,
})
hl.monitor({ --(decent monitor) home [secondary] ; travel [primary]
  output = "desc:Hewlett Packard HP w2207 3CQ82426KK",
  mode = "preferred",
  position = "1920x50",
  scale = 1,
  transform = 0, --set to 1 for vertical
})
hl.monitor({
  output = "desc:Valve Corporation ANX7530 U 0x00000001",
  mode = "preferred",
  position = "0x1080",
  scale = 1,
  transform = 3,
})
hl.monitor({
  output = "desc:Sceptre Tech Inc E225W-1920",
  mode = "preferred",
  position = "1680x0",
  scale = 1,
  transform = 0,
})

hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "12")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "12")

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.curve(
  "easeOutQuint",
  { type = "bezier", points = { {0.23, 1}, {0.32, 1} } }
)
hl.curve(
  "easeInOutCubic",
  { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } }
)
hl.curve(
  "linear",
  { type = "bezier", points = { {0, 0}, {1, 1} } }
)
hl.curve(
  "almostLinear",
  { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } }
)
hl.curve(
  "quick",
  { type = "bezier", points = { {0.15, 0}, {0.1, 1} } }
)

hl.animation({
  leaf = "global", enabled = true, speed = 10, bezier = "default"
})
hl.animation({
  leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint"
})
hl.animation({
  leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint"
})
hl.animation({
  leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%"
})
hl.animation({
  leaf = "windowsOut", enabled = true, speed = 4.49, bezier = "linear", style = "popin 87%"
})
hl.animation({
  leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear"
})
hl.animation({
  leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear"
})
hl.animation({
  leaf = "fade", enabled = true, speed = 3.03, bezier = "quick"
})
hl.animation({
  leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint"
})
hl.animation({
  leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade"
})
hl.animation({
  leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade"
})
hl.animation({
  leaf = "fadeLayersIn", enabled = true, speed = 1.75, bezier = "almostLinear"
})
hl.animation({
  leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear"
})
hl.animation({
  leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade"
})
hl.animation({
  leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade"
})
hl.animation({
  leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade"
})
-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
