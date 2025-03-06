{ lib, pkgs, osConfig, ... }:
with lib;
let
  theme = pkgs.materia-theme;
  # theme = pkgs.fluent-gtk-theme;
in
{
  config = mkIf osConfig.desktop.hyprland.enable {

    home.sessionVariables.GTK_THEME = theme.name;

    gtk.theme = {
      name = theme.name;
      package = theme;
    };

    # programs.waybar = {
    #     enable = true;
    #     package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
    # };
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
      style = ''
               * {
                 font-family: "JetBrainsMono Nerd Font";
                 font-size: 12pt;
                 font-weight: bold;
                 border-radius: 8px;
                 transition-property: background-color;
                 transition-duration: 0.5s;
               }
               @keyframes blink_red {
                 to {
                   background-color: rgb(242, 143, 173);
                   color: rgb(26, 24, 38);
                 }
               }
               .warning, .critical, .urgent {
                 animation-name: blink_red;
                 animation-duration: 1s;
                 animation-timing-function: linear;
                 animation-iteration-count: infinite;
                 animation-direction: alternate;
               }
               window#waybar {
                 background-color: transparent;
               }
               window > box {
                 margin-left: 5px;
                 margin-right: 5px;
                 margin-top: 5px;
                 background-color: #1e1e2a;
                 padding: 3px;
                 padding-left:8px;
                 border: 2px none #33ccff;
               }
         #workspaces {
                 padding-left: 0px;
                 padding-right: 4px;
               }
         #workspaces button {
                 padding-top: 5px;
                 padding-bottom: 5px;
                 padding-left: 6px;
                 padding-right: 6px;
               }
         #workspaces button.active {
                 background-color: rgb(181, 232, 224);
                 color: rgb(26, 24, 38);
               }
         #workspaces button.urgent {
                 color: rgb(26, 24, 38);
               }
         #workspaces button:hover {
                 background-color: rgb(248, 189, 150);
                 color: rgb(26, 24, 38);
               }
               tooltip {
                 background: rgb(48, 45, 65);
               }
               tooltip label {
                 color: rgb(217, 224, 238);
               }
         #custom-launcher {
                 font-size: 20px;
                 padding-left: 8px;
                 padding-right: 6px;
                 color: #7ebae4;
               }
         #mode, #clock, #memory, #temperature,#cpu,#mpd, #custom-wall, #temperature, #backlight, #pulseaudio, #network, #battery, #custom-powermenu, #custom-cava-internal {
                 padding-left: 10px;
                 padding-right: 10px;
               }
               /* #mode { */
               /* 	margin-left: 10px; */
               /* 	background-color: rgb(248, 189, 150); */
               /*     color: rgb(26, 24, 38); */
               /* } */
         #window {
                 color: rgb(217, 224, 238);
               }
         #submap {
                 color: rgb(217, 224, 238);
               }
         #workspaces {
                 color: rgb(217, 224, 238);
               }
         #battery {
                 color: rgb(181, 232, 224);
               }
         #memory {
                 color: rgb(181, 232, 224);
               }
         #cpu {
                 color: rgb(245, 194, 231);
               }
         #clock {
                 color: rgb(217, 224, 238);
               }
        /* #idle_inhibitor {
                 color: rgb(221, 182, 242);
               }*/
         #custom-wall {
                 color: #33ccff;
            }
         #temperature {
                 color: rgb(150, 205, 251);
               }
         #backlight {
                 color: rgb(248, 189, 150);
               }
         #pulseaudio {
                 color: rgb(245, 224, 220);
               }
         #network {
                 color: #ABE9B3;
               }
         #network.disconnected {
                 color: rgb(255, 255, 255);
               }
         #custom-powermenu {
                 color: rgb(242, 143, 173);
                 padding-right: 8px;
               }
         #tray {
                 padding-right: 8px;
                 padding-left: 10px;
               }
         #mpd.paused {
                 color: #414868;
                 font-style: italic;
               }
         #mpd.stopped {
                 background: transparent;
               }
         #mpd {
                 color: #c0caf5;
               }
         #custom-cava-internal{
                 font-family: "Hack Nerd Font" ;
                 color: #33ccff;
               }
      '';
      settings = [{
        "layer" = "top";
        "position" = "top";
        modules-left = [
          "custom/launcher"
          "hyprland/submap"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          "idle_inhibitor"
          "hyprland/workspaces"
        ];
        modules-right = [
          "bluetooth"
          "pulseaudio"
          "backlight"
          "cpu"
          "temperature"
          "memory"
          "battery"
          "network"
          "custom/powermenu"
          "tray"
        ];
        "hyprland/window" = {
          "format" = "{}";
          "separate-outputs" = true;
        };
        "hyprland/language" = {
          "format" = "{}";
          "format-en" = "en";
          "format-ru" = "ru";
          "format-hy" = "hy";
        };
        "wlr/workspaces" = {
          "format" = "{name}";
          "on-click" = "activate";
          "all-outputs" = false;
          "sort-by-number" = true;
          "format-icons" = {
            "1" = "one";
            "2" = "two";
            "3" = "three";
            "4" = "four";
            "5" = "five";
            "6" = "six";
            "7" = "seven";
            "8" = "eight";
            "9" = "nine";
            "urgent" = "!!!";
          };
        };
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "pkill anyrun || anyrun";
          # "on-click-middle" = "exec default_wall";
          "on-click-right" = "pkill fuzzel || fuzzel";
          "tooltip" = false;
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = "󰖁 Muted";
          "format-icons" = {
            "default" = [ "" "" "" ];
          };
          "on-click" = "pamixer -t";
          "tooltip" = false;
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%I:%M %p  %A %b %d}";
          "tooltip" = true;
          "tooltip-format" = "{=%A; %d %B %Y}\n<tt>{calendar}</tt>";
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰻠 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰍛 {usage}%";
        };
        "mpd" = {
          "max-length" = 25;
          "format" = "<span foreground='#bb9af7'></span> {title}";
          "format-paused" = " {title}";
          "format-stopped" = "<span foreground='#bb9af7'></span>";
          "format-disconnected" = "";
          "on-click" = "mpc --quiet toggle";
          "on-click-right" = "mpc update; mpc ls | mpc add";
          "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };
        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰒢 Connected!";
          "format-linked" = "󰖪 {essid} (No IP)";
          "format-wifi" = "󰖩";
          "interval" = 5;
          "tooltip" = false;
        };
        "custom/powermenu" = {
          "format" = "⏻";
          "on-click" = "wlogout";
          "tooltip" = false;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
        "hyprland/submap"= {
            "format"= "✌️ {}";
            "max-length" = 8;
            "tooltip" = false;
        };
      }];
    };

    programs.hyprlock = {
      enable = true;
      importantPrefixes = [
        "$"
        "monitor"
        "size"
        "source"
      ];
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
            shadow_passes = 2;
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      importantPrefixes = [
        "$"
      ];
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      importantPrefixes = [
        "$"
      ];
      settings = {
        ipc = "off";
        splash = false;
        splash_offset = 2.0;

        preload =
          [ "${pkgs.gnome-backgrounds}/backgrounds/amber-d.jxl" ];

        wallpaper = [
          "${pkgs.gnome-backgrounds}/backgrounds/amber-d.jxl"
        ];
      };
    };

    # programs.anyrun = {
    #   enable = true;
    #   config = {
    #     x = { fraction = 0.5; };
    #     y = { fraction = 0.3; };
    #     width = { fraction = 0.3; };
    #     hideIcons = false;
    #     ignoreExclusiveZones = false;
    #     layer = "overlay";
    #     hidePluginInfo = false;
    #     closeOnClick = false;
    #     showResultsImmediately = false;
    #     maxEntries = null;
    #
    #     plugins = [
    #       # An array of all the plugins you want, which either can be paths to the .so files, or their packages
    #       inputs.anyrun.packages.${pkgs.system}.applications
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/randr"
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/translate"
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/shell"
    #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/websearch"
    #     ];
    #   };
    #
    #   # Inline comments are supported for language injection into
    #   # multi-line strings with Treesitter! (Depends on your editor)
    #   extraCss = /*css */ ''
    #     .some_class {
    #       background: red;
    #     }
    #   '';
    #
    #   extraConfigFiles."some-plugin.ron".text = ''
    #     Config(
    #       // for any other plugin
    #       // this file will be put in ~/.config/anyrun/some-plugin.ron
    #       // refer to docs of xdg.configFile for available options
    #     )
    #   '';
    # };
    #
    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$browser" = "firefox";
      monitor = "eDP-2, 2560x1600@165.00000, 0x0, 1.333333";
      env = [
        "GTK_THEME, ${theme.name}"
      ];
      exec-once = [
        # "waybar"
        "dunst"
      ];
      bindl = [
        ", switch:on:Lid Switch, exec, hyprctl dispatch dpms off"
        ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on"
      ];
      bind = [
        "$mod SHIFT, grave, exit"

        "$mod SHIFT, F, exec, $browser"
        "$mod SHIFT, Return, exec, $terminal"
        "$mod, P, exec, wofi --show drun"
        "$mod, space, exec, anyrun"
        ", Print, exec, grimblast copy area"

        "$mod SHIFT, C, killactive"

        "$mod, M, fullscreen, 1"
        "$mod, T, dwindle, 1"
        "$mod, F, togglefloating"
        "$mod SHIFT, P, pin"

        "$mod, S, cyclenext"
        "$mod, A, cyclenext, prev"

        "$mod, L, splitratio, +0.1"
        "$mod, H, splitratio, -0.1"

        "$mod, Q, workspace, -1"
        "$mod, W, workspace, +1"

        "$mod SHIFT, Q, movetoworkspace, -1"
        "$mod SHIFT, W, movetoworkspace, +1"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList
          (
            x:
            let
              ws =
                let
                  c = (x + 1) / 10;
                in
                builtins.toString (x + 1 - (c * 10));
            in
            [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      input = {
        touchpad.natural_scroll = true;
      };
      gestures = {
        workspace_swipe = true;
      };
      decoration = {
        rounding = 10;
        shadow.enabled = false;
        blur = {
          enabled = false;
        };
        # "blur:enabled = false"
        # drop_shadow = false;
      };
      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
    home.packages = with pkgs; [
      gnome-backgrounds
      # waybar
      anyrun
      # anyrun-with-all-plugins
      wofi
      fuzzel
      wlogout
      hyprpicker
      hyprcursor
      hyprlock
      hypridle
      hyprpaper
      dunst
      wev
      libnotify
    ];
  };
}
