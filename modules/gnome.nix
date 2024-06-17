{ lib, pkgs, config, ... }:
with lib;
{
  options.desktop.gnome = {
    enable = mkEnableOption "enable GNOME";
  };

  config = mkIf config.desktop.gnome.enable {
    programs.dconf.enable = true;

    services = {
      xserver = {
        enable = true;
        displayManager = {
          gdm.enable = true;
        };
        desktopManager = {
          gnome.enable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      wl-clipboard
    ];
  };
}
