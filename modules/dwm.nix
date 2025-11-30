{ lib, pkgs, config, inputs, ... }:
with lib;
{
  options.desktop.dwm = {
    enable = mkEnableOption "enable dwm setup";
  };

  config = mkIf config.desktop.dwm.enable {
    xdg.portal = {
      enable = true;
      configPackages = [
        pkgs.xdg-desktop-portal-gtk
      ];
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    services = {
        displayManager = {
          ly.enable = true;
        };
      xserver = {
        enable = true;
        windowManager = {
          dwm.enable = true;
          dwm.package = inputs.dwm.packages.${pkgs.system}.default;
        };
      };
    };

    services.auto-cpufreq.enable = true;
    services.power-profiles-daemon.enable = false;
    services.udisks2.enable = true;
    services.upower.enable = true;

    programs.i3lock = {
        enable = true;
        package = pkgs.i3lock-color;
    };

    security.pam.services.i3lock.enable = true;

    services.picom = {
        enable = true;
        package = pkgs.picom-next;
    };

    # systemd.user.services.ulauncher = {
    #     enable = true;
    # };  
    systemd.user.services.ulauncher = {
        enable = true;
        description = "Start Ulauncher";
        script = "${pkgs.ulauncher}/bin/ulauncher --hide-window";

        documentation = [ "https://github.com/Ulauncher/Ulauncher/blob/f0905b9a9cabb342f9c29d0e9efd3ba4d0fa456e/contrib/systemd/ulauncher.service" ];
        wantedBy = [ "graphical.target" "multi-user.target" ];
        after = [ "display-manager.service" ];
    };

    environment.systemPackages = with pkgs; [
      xorg.xinit
      
      # dwm-status
      inputs.dmenu.packages.${pkgs.stdenv.hostPlatform.system}.default

      xss-lock
      # i3lock-color
      rofi

      dbus
      feh
      dunst
      lxde.lxsession
      udiskie
      ulauncher

      flameshot
      pnmixer
      playerctl
      networkmanagerapplet

      alsa-utils
    ];
  # services.dwm-status  = mkIf osConfig.desktop.dwm.enable {
  #     enable = true;
  #     order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
  #     extraConfig = {
  #       separator = " | ";
  #
  #       audio = {
  #           control = "Master";
  #           mute = "󰖁";
  #           template = "{ICO} {VOL}%";
  #           icons = ["󰕿" "󰖀" "󰕾"];
  #       };
  #
  #       backlight = {
  #           device = "amdgpu_bl2";
  #           template = "{ICO} {BL}%";
  #           icons = ["󰃜" "󰃛" "󰃚"];
  #       };
  #
  #       battery = {
  #           charging = "▲";
  #           discharging = "▼";
  #           enable_notifier = true;
  #           no_battery = "NO BATT";
  #           notifier_critical = 10;
  #           notifier_levels = [2 5 10 15 20];
  #           separator = " · ";
  #           icons = ["󰁻" "󰁽" "󰂂"];
  #       };
  #
  #       cpu_load = {
  #           template = "{CL1} {CL5} {CL15}";
  #           update_interval = 20;
  #       };
  #
  #       network = {
  #           no_value = "N/A";
  #           template = "{ESSID}";
  #       };
  #
  #       time = {
  #           format = "%H:%M %m-%d";
  #           update_seconds = false;
  #       };
  #
  #     };
  # };
  };
}
