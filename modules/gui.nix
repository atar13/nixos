{ pkgs, ... }:
{
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  environment = {
    variables = {
      TERMINAL = "kitty";
    };
  };

  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.4.8248"
  ];


  environment.systemPackages = with pkgs; [
    firefox
    brave
    # ungoogled-chromium
    chromium

    thunderbird
    signal-desktop
    slack
    discord

    bitwarden

    pcmanfm
    CuboCore.corefm

    joplin-desktop
    # obsidian
    okular
    neovide

    vlc
    mpv
    obs-studio
    kdenlive
    blender

    pavucontrol
    pulseaudio
    virt-manager
    appimage-run
    ulauncher
    timeshift

    xterm
    alacritty
    kitty
    st

    kicad-small

    blanket
    activitywatch
    googleearth-pro
    gimp
    xournal
    endeavour
  ];
}
