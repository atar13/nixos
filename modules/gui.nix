{ pkgs, old-pkgs, my-pkgs, ... }:
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
    # chromium

    thunderbird
    signal-desktop
    slack
    discord

    bitwarden-desktop

    pcmanfm
    CuboCore.corefm

    joplin-desktop
    # obsidian
    kdePackages.okular
    kdePackages.kdenlive
    neovide

    vlc
    mpv
    obs-studio
    blender

    pavucontrol
    pulseaudio
    appimage-run
    # ulauncher
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
    xournalpp
    endeavour
    gtg
    evolution
    zoom-us
    pinta
    element-desktop
    pika-backup
    prismlauncher
    freecad
    libreoffice-still
    saleae-logic-2
    old-pkgs.etcher
    gpick
    # audacity
    cool-retro-term
    arduino-ide
    hoppscotch
    telegram-desktop
    my-pkgs.nrfconnect
    my-pkgs.nrf-udev
    supersonic
    mission-center
    sony-headphones-client
    pdfarranger
    tangram
    zed-editor
    feishin
    errands
    freecad-wayland
    librecad
    youtube-music
    delfin
    jellyfin-media-player
    smile
    libnotify
    sticky
    sticky-notes
    rhythmbox
    planify
    nextcloud-client
  ];
}
