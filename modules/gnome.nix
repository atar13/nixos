{ lib, pkgs, config, ... }:
with lib;
{
  options.desktop.gnome = {
    enable = mkEnableOption "enable GNOME";
  };

  config = mkIf config.desktop.gnome.enable {
    programs.dconf.enable = true;

    services = {
      power-profiles-daemon.enable = true;
      auto-cpufreq.enable = false;
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
      gnome-tweaks
      wl-clipboard
    ];
  };
}
