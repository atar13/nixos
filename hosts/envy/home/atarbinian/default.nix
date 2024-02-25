{ inputs, pkgs, username, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit username; })
    (import ../../../../modules/home/gui.nix { inherit username; })
    ../../../../modules/home/theme.nix
    (import ../../../../modules/home/spicetify.nix { inherit pkgs; inherit (inputs) spicetify-nix; })
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Auto mount devices
  services.udiskie.enable = true;

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      disable-user-extensions = false;

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        # "user-theme@gnome-shell-extensions.gcampax.github.com"
        # "trayIconsReloaded@selfmade.pl"
        # "Vitals@CoreCoding.com"
        # "dash-to-panel@jderose9.github.com"
        # "sound-output-device-chooser@kgshank.net"
        # "space-bar@luchrioh"
      ];
    };
  };

  home.packages = with pkgs; [
    # ...
    gnomeExtensions.appindicator
    # gnomeExtensions.user-themes
    # gnomeExtensions.tray-icons-reloaded
    # gnomeExtensions.vitals
    # gnomeExtensions.dash-to-panel
    # gnomeExtensions.sound-output-device-chooser
    # gnomeExtensions.space-bar
  ];

  home.stateVersion = "23.11";
}
