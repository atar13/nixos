
{ lib, pkgs, config, osConfig, dotfiles, ... }:
with lib;
{

  config = mkIf osConfig.desktop.dwm.enable {
      xdg.configFile = {
          picom.source = "${dotfiles}/picom/.config/picom";
      };
      services.dwm-status = {
          enable = true;
          order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
          extraConfig = {
            separator = " | ";

            audio = {
                control = "Master";
                mute = "󰖁";
                template = "{ICO} {VOL}%";
                icons = ["󰕿" "󰖀" "󰕾"];
            };

            backlight = {
                device = "amdgpu_bl2";
                template = "{ICO} {BL}%";
                icons = ["󰃜" "󰃛" "󰃚"];
            };

            battery = {
                charging = "▲";
                discharging = "▼";
                enable_notifier = true;
                no_battery = "NO BATT";
                notifier_critical = 10;
                notifier_levels = [2 5 10 15 20];
                separator = " · ";
                icons = ["󰁻" "󰁽" "󰂂"];
            };

            cpu_load = {
                template = "{CL1} {CL5} {CL15}";
                update_interval = 20;
            };

            network = {
                no_value = "N/A";
                template = "{ESSID}";
            };

            time = {
                format = "%H:%M %m-%d";
                update_seconds = false;
            };

          };
      };
  };
}
