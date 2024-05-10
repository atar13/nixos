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
      xserver = {
        enable = true;
        displayManager = {
          gdm.enable = true;
        };
        windowManager = {
          dwm.enable = true;
          dwm.package = inputs.dwm.packages.${pkgs.system}.default;
        };
      };
    };

    services.auto-cpufreq.enable = true;
    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
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
    ];
  };
}
