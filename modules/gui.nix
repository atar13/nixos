{ pkgs, old-pkgs, ... }:
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
    # googleearth-pro
    gimp
    xournal
    endeavour
    gtg
    evolution
    zoom-us
    pinta
    element-desktop
    pika-backup
    minecraft
    freecad
    libreoffice-still
    saleae-logic-2
    old-pkgs.etcher
  ];
}
