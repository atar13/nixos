{ inputs, config, lib, pkgs, username, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit username; })
    (import ../../../../modules/home/gui.nix { inherit username; })
    (import ../../../../modules/home/neovim.nix { inherit (inputs) dotfiles; inherit pkgs config lib; })
    ../../../../modules/home/theme.nix
    ../../../../modules/home/vscode.nix
    (import ../../../../modules/home/spicetify.nix { inherit pkgs; inherit (inputs) spicetify-nix; })
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Auto mount devices
  services.udiskie.enable = true;

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-background = [ "<Shift><Alt>Tab" ];
      switch-to-workspace-left = [ "<Super>q" ];
      switch-to-workspace-right = [ "<Super>w" ];
      move-to-workspace-left = [ "<Shift><Super>q" ];
      move-to-workspace-right = [ "<Shift><Super>w" ];
    };


    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.Software.desktop"
        "org.gnome.Epiphany.desktop"
      ];
    };


    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "Alacritty.desktop"
        "kitty.desktop"
        "code.desktop"
        "org.kicad.kicad.desktop"
        "firefox.desktop"
        "org.gnome.Calendar.desktop"
        "thunderbird.desktop"
        "signal-desktop.desktop"
        "element-desktop.desktop"
        "discord.desktop"
        "slack.desktop"
        "spotify.desktop"
        "org.gnome.Calculator.desktop"
        "bitwarden.desktop"
        "gnome-system-monitor.desktop"
        "org.gnome.Settings.desktop"
      ];

      # `gnome-extensions list` for a list
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "Vitals@CoreCoding.com"
        "advanced-alt-tab@G-dH.github.com"
        # "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        # "quick-settings-audio-panel@rayzeq.github.io"
        "quick-settings-tweaks@qwreey"
        # "sound-output-device-chooser@kgshank.net"
        # "space-bar@luchrioh"


        # "user-theme@gnome-shell-extensions.gcampax.github.com"
        # "trayIconsReloaded@selfmade.pl"
        # "Vitals@CoreCoding.com"
        # "dash-to-panel@jderose9.github.com"
        # "sound-output-device-chooser@kgshank.net"
        # "space-bar@luchrioh"
      ];

    };

    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      output-show-selected = true;
      input-show-selected = true;
      input-always-show = true;
    };
  };

  home.packages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.quick-settings-tweaker
    gnomeExtensions.quick-settings-audio-panel
    gnomeExtensions.space-bar
    # gnomeExtensions.advanced-alttab-window-switcher
  ];

  home.stateVersion = "23.11";
}
