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
    lfs
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
    yt-dlp
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

    taskwarrior
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
    inputs.agenix.packages.${pkgs.system}.default
    inputs.compose2nix.packages.${pkgs.system}.default
  ];
}
