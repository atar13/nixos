# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  user="atarbinian";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      <home-manager/nixos>
    ];

  # Nix
  nix.settings.experimental-features = [ "flakes" "nix-command" ];

  #nix-store -q --references /run/current-system/sw | fzf TODO: add this to .zshrc later

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "envy-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  #services.xserver.windowManager.dwm.enable = true;

  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+dwm";
      };
      desktopManager.xfce.enable = true;
      windowManager.dwm.enable = true;
    };
  };

  nixpkgs.config.packageOverrides = {
    dwm = pkgs.callPackage /home/atarbinian/Pkgs/dwm { };
    dmenu = pkgs.callPackage /home/atarbinian/Pkgs/dmenu { };
    go-dwm-statusbar = pkgs.callPackage /home/atarbinian/Pkgs/go-dwm-statusbar { };
  };

  services.xserver.displayManager.session = [
    {
      manage = "window";
      name = "dwm";
      start = ''
        ${pkgs.dwm}/bin/dwm &
        waitPID=$!
      '';
    }
  ];


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "Anthony Tarbinian";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      stow

      firefox
      brave
      bitwarden
      obsidian
      discord
      mupdf
      pcmanfm
      CuboCore.corefm
      ulauncher

      cmus
      spotify
      spicetify-cli

      luajit
      neovim
      neovide
      vimPlugins.packer-nvim

      fzf
      ripgrep
      fd
      lfs
      ffmpeg 
      yt-dlp
      croc
      gocryptfs

      gotop
      btop

      hollywood
      neofetch
      cmatrix
      onefetch

      tmux
      kitty
      alacritty
      wezterm

      dmenu
      dwmbar


      lm_sensors

      picom-next
      feh
      dunst
      networkmanagerapplet
      nerdfonts
      #  thunderbird

      rnix-lsp

      cargo
      gcc
    ];
  };

  # programs.light.enable = true; # already in envy

  programs.neovim = {
    enable = true;
    configure = {
      packages."packer.nvim" = with pkgs.vimPlugins; {
        start = [ "packer.nvim" ];
      };
    };
  };


  #home-manager.users.atarbinian = {pkgs, ... }: {
  #	home.username = "atarbinian";
  #      home.homeDirectory = "/home/atarbinian";
  #	home.stateVersion = "23.05";
  #	home.packages = [
  #      	pkgs.neovim
  #      ];
  # 	programs.home-manager.enable = true;
  #      programs.neovim = {
  #            enable = true;
  #            defaultEditor = true;
  #            viAlias = true;
  #            extraLuaConfig = lib.fileContents "/home/atarbinian/Pkgs/dotfiles/nvim/.config/nvim/init.lua";
  #      };
  #};



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    efibootmgr
    refind
    tealdeer
    wget
    gnupg
    gnumake
    pulseaudio

    imlib2

    vscodium
    vscodium.fhs 
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        vscodevim.vim
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    })

    lxappearance
    materia-theme
    bibata-cursors
    tela-icon-theme
  ];



  #nixpkgs.overlays = [
  # (final: prev: {
  #   dwm = prev.dwm.overrideAttrs (old: { src = /home/atarbinian/Pkgs/dwm ;});
  # })
  #];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?


  home-manager.users.${user} = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [ htop ];

    home.file = {
      "kitty".source = "/home/atarbinian/Pkgs/dotfiles/kitty/.config/kitty/kitty.conf";
      "kitty".target = ".config/kitty/kitty.conf";
    };
  };
}
