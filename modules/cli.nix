{ inputs, pkgs, ... }:
{
  programs.zsh.enable = true;


  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    tmux

    jq
    bat
    lsd
    tree
    fzf
    ripgrep
    fd
    dysk
    zoxide
    starship
    stow
    file

    zsh-completions
    nix-zsh-completions
    coreutils-full

    vim
    neovim
    nano

    tealdeer
    wget
    curl
    gnupg

    zip
    unzip
    gnutar

    mupdf
    feh
    scrot
    ffmpeg
    # yt-dlp
    croc
    gocryptfs

    cmus

    htop
    gotop
    btop

    hollywood
    cmatrix
    neofetch
    pfetch
    nitch
    onefetch

    cargo

    # taskwarrior
    git-sizer
    apostrophe
    hugo

    killall
    exfatprogs
    pciutils
    usbutils

    xclip

    # TODO: this should go in a shell eventually
    nixpkgs-fmt
    nil

    nurl
    comma
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.compose2nix.packages.${pkgs.stdenv.hostPlatform.system}.default

    imagemagick
    timetagger_cli

    dig
    just
    dust

    openjdk
    nrf-command-line-tools
    helix
    gnumake
    picocom
    nix-output-monitor
    hexyl

    rust-analyzer
    fastfetch
  ];
}
