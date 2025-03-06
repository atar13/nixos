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

    services.dwm-status = {
      enable = true;
      order = [ "audio" "backlight" "battery" "cpu_load" "network" "time" ];
      extraConfig = ''
        separator = " | "

        [audio]
        control = "Master"
        mute = "MUTE"
        template = "S {VOL}%"
        icons = []

        [backlight]
        device = "amdgpu_bl2"
        template = "L {BL}%"
        icons = ["󰃜", "󰃛", "󰃚"]

        [battery]
        charging = "▲"
        discharging = "▼"
        enable_notifier = true
        no_battery = "NO BATT"
        notifier_critical = 10
        notifier_levels = [2, 5, 10, 15, 20]
        separator = " · "
        icons = []

        [cpu_load]
        template = "{CL1} {CL5} {CL15}"
        update_interval = 20

        [network]
        no_value = "N/A"
        template = "{ESSID}"

        [time]
        format = "%m-%d %H:%M"
        update_seconds = false
      '';
    };

    environment.systemPackages = with pkgs; [
      xorg.xinit
      
      dwm-status
      inputs.dmenu.packages.${pkgs.system}.default

      picom-next
      xss-lock
      i3lock-color

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
  };
}
