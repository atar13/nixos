{ pkgs}:

with pkgs; [
  alacritty
  kitty
  firefox
  brave
  thunderbird
  bitwarden
  appimage-run
  pcmanfm
  obsidian
  CuboCore.corefm
  ulauncher
  discord
  vlc
  mpv
  obs-studio
  kdenlive
  blender
  slack

  cmus
  spotify
  spicetify-cli

  zsh-completions
  nix-zsh-completions
  coreutils-full
  tealdeer
  act # local gh actions
  stow
  zip 
  unzip
  gnutar
  bat
  jq
  tree
  tmux
  fzf
  ripgrep
  fd
  lfs
  ffmpeg 
  yt-dlp
  croc
  gocryptfs

  htop
  gotop
  btop


  pavucontrol

  mupdf
  okular

  hollywood
  cmatrix
  neofetch
  pfetch
  nitch

  luajit
  gcc
  cargo

  neovim
  neovide
  vimPlugins.packer-nvim
  rnix-lsp

  texlive.combined.scheme-basic

  # dmenu
  (pkgs.callPackage /home/atarbinian/Pkgs/dmenu { })
  st
  # dwmbar
  lm_sensors
  picom-next
  feh
  networkmanagerapplet
]
