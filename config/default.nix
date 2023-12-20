# System configuration for all hosts
{ inputs, pkgs, system, username, hostname, ... }:
{
  imports = [
    ./modules/vscode.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [ "flakes" "nix-command" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  programs.zsh.enable = true;
  users.users.${username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Anthony Tarbinian";
    extraGroups = [
      "wheel"
      "video"
      "camera"
      "networkmanager"
      "docker"
      "libvirtd"
    ];
  };

  #nix-store -q --references /run/current-system/sw | fzf TODO: add this to .zshrc later

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
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
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  fonts.packages = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    font-awesome # Icons
    corefonts # MS
    (nerdfonts.override {
      # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];


  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
      desktopManager = {
        gnome.enable = true;
      };
    };
  };

  nixpkgs.config.packageOverrides = {
    # dwm = pkgs.callPackage /home/atarbinian/Pkgs/dwm { };
    # dmenu = pkgs.callPackage /home/atarbinian/Pkgs/dmenu { };
    # go-dwm-statusbar = pkgs.callPackage ../..//Pkgs/go-dwm-statusbar { };
  };

  # services.xserver.displayManager.session = [
  #   {
  #     manage = "window";
  #     name = "dwm";
  #     start = ''
  #       ${pkgs.dwm}/bin/dwm &
  #       waitPID=$!
  #     '';
  #   }
  # ];


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
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


  environment = {
    variables = {
      XCURSOR_THEME = "Bibata-Modern-Classic";
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemPackages =
      (import ./packages/cli.nix { inherit pkgs; }) ++
      (import ./packages/gui.nix { inherit pkgs; }) ++
      (import ./packages/lib.nix { inherit pkgs; }) ++
      [ inputs.agenix.packages.${system}.default ];
  };

  programs.dconf.enable = true;

  services.openssh.enable = true;
  services.flatpak.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
      libGLU
    ];
    setLdLibraryPath = true;
  };

  system.stateVersion = "unstable";
}
