{ lib, pkgs, config, ... }:
with lib;
{
  options.desktop.hyprland = {
    enable = mkEnableOption "enable Hyprland";
  };

  config = mkIf config.desktop.hyprland.enable {
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "hyprland";
    };

    services.auto-cpufreq.enable = true; # don't use with powerprofiles daemon
    services.power-profiles-daemon.enable = false;
    services.tlp.enable = false;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
    xdg.portal.config.common.default = [ "hyprland;gtk" ];

    programs.hyprland.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    security.pam.services.hyprlock = {
      # enableGnomeKeyring
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [
      wlr-randr
    ];
  };
}
