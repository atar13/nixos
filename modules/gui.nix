{ pkgs, ... }:
{
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
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
  ];
}
