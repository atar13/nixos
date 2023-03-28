# Configuration for all hosts

{ lib, inputs, nixpkgs, pkgs, system, user, ... }:
let 
	hostname = "envy-nixos";
	
in
{
  imports =
    [
      # <home-manager/nixos>
      # ./envy
    ];
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowBroken = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Anthony Tarbinian";
    extraGroups = [ "networkmanager" "wheel" "video" "camera" "networkmanager" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };

  # Nix
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

  #nix-store -q --references /run/current-system/sw | fzf TODO: add this to .zshrc later

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = hostname; # Define your hostname.
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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";                          # or us/azerty/etc
  };


  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];


  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+dwm";
      };
      desktopManager.xfce.enable = true;
      windowManager.dwm.enable = true;
    };
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  nixpkgs.config.packageOverrides = {
    dwm = pkgs.callPackage /home/atarbinian/Pkgs/dwm { };
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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput = {
  	enable = true;
	touchpad.naturalScrolling = true;
	touchpad.tapping = true;
  };

  #programs.neovim = {
  #  enable = true;
  #  configure = {
  #    packages."packer.nvim" = with pkgs.vimPlugins; {
  #      start = [ "packer.nvim" ];
  #    };
  #  };
  #};


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
        sessionVariables = {
	  MOZ_USE_XINPUT2 = "1";
	};
  	variables = {
		XCURSOR_THEME = "Bibata-Modern-Classic";
  		TERMINAL = "kitty";
  		EDITOR = "nvim";
  		VISUAL = "nvim";
  	};
  	systemPackages = with pkgs; [
	# (pkgs.callPackage /home/atarbinian/Pkgs/dwm { })
  	git
  	vim

  	efibootmgr
  	refind
  	tealdeer
  	wget
  	gnupg
  	gnumake
  	pulseaudio
  	killall
  	nano
  	pciutils
  	usbutils
  	curl

	exfatprogs

	xterm
	xclip

  	imlib2
	glib
	glibc

	virt-manager

	neovim

	# (pkgs.callPackage (import /home/atarbinian/Pkgs/dwm) {})
	(vscode-with-extensions.override { vscodeExtensions = with vscode-extensions; [
	      bbenoist.nix
	      ms-python.python
	      ms-azuretools.vscode-docker
	      ms-vscode-remote.remote-ssh
	      ms-vscode.cpptools
	      vscodevim.vim
	      piousdeer.adwaita-theme
	      viktorqvarfordt.vscode-pitch-black-theme
	    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
	 #      {
		# name = "remote-ssh";
		# publisher = "ms-vscode-remote";
		# version = "0.101.2023032415";
		# sha256 = "c+sCR+Zly5KiyQdQhGG0w+e+PHWICJfKaOPFbsdL7y8=";
	 #      }
	      {
		name = "nix-env-selector";
		publisher = "arrterian";
		version = "1.0.9";
		sha256 = "TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
	      }
	 #      {
	 #      	name = "Heron.firefox-devtools-theme";
		# version = "4.10.1";
		# publisher = "HeronSilva";
	 #      }
	    ];
	  })

  	];

  };


  # nixpkgs.overlays = [
  # (final: prev: {
  #   dwm = prev.dwm.overrideAttrs (old: { src = /home/atarbinian/Pkgs/dwm ;});
  # })
  # ];

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
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  services.flatpak.enable = true;

  virtualisation.libvirtd.enable = true;
programs.dconf.enable = true;
virtualisation.spiceUSBRedirection.enable = true;


  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

hardware.opengl = {
     enable = true;
     extraPackages = with pkgs; [
       libGL
       libGLU
     ];
     setLdLibraryPath = true;
   };


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
}
