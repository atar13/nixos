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
  timeshift
  signal-desktop

  cmus

  # shell utilities
  lsd
  zoxide
  starship
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
  stdenv.cc.cc.lib
  cargo

  neovide

  texlive.combined.scheme-basic

  st
  scrot
  (pkgs.callPackage /home/atarbinian/Pkgs/go-dwm-statusbar { })
  (pkgs.callPackage /home/atarbinian/Pkgs/dmenu { })
  i3lock-color
  dwmbar
  lm_sensors
  picom-next
  feh
  networkmanagerapplet


  taskwarrior
  git-sizer
  apostrophe
  hugo

  nodejs-16_x
  openssl

  go
  #haskellPackages.ghcup
  ghc
  sumneko-lua-language-server
  rnix-lsp
  rust-analyzer
  pkg-config-unwrapped
]
