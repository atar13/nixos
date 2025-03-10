# Framework 16 Laptop specific configuration
{ lib, config, inputs, pkgs, old-pkgs, my-pkgs, arm-pkgs, hostname, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.framework-16-7040-amd
    ./hardware-configuration.nix
    ./wg-client.nix
    (import ../../modules/nix.nix { inherit inputs pkgs; })
    (import ../../modules/cli.nix { inherit inputs pkgs; })
    ../../modules/bluetooth.nix
    ../../modules/fonts.nix
    (import ../../modules/desktop.nix { inherit lib pkgs config inputs; })
    (import ../../modules/gui.nix { inherit pkgs old-pkgs my-pkgs; })
    ../../modules/lib.nix
    ../../modules/localization.nix
    ../../modules/game.nix
  ];

  gui.desktop = "gnome";

  nixpkgs.overlays = [
    (
      final: prev: {
        # Your own overlays...
      }
    )
  ] ++ [ inputs.nix-xilinx.overlay ];


  boot.initrd.kernelModules = [ "amdgpu" ];

  programs.corectrl.enable = true;

  services.fwupd.enable = true;

  services.fprintd.enable = true;

  programs.noisetorch.enable = true;

  programs.wireshark.enable = true;

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1102"; # used to be necessary, but doesn't seem to anymore
    };
    rocmOverrideGfx = "11.0.2";
  };

  # # following configuration is added only when building VM with build-vm
  # users.users.nixosvmtest.isSystemUser = true ;
  # users.users.nixosvmtest.initialPassword = "test";
  # users.users.nixosvmtest.group = "nixosvmtest";
  # users.groups.nixosvmtest = {};
  # virtualisation.vmVariant = {
  #     virtualisation = {
  #       memorySize =  2048; # Use 2048MiB memory.
  #       cores = 3;         
  #     };
  # };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  users.users."atarbinian" = {
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
      "dialout"
      "tty"
      "wireshark"
      "plugdev"
    ];
  };

  boot = {
    tmp.useTmpfs = true;
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Display the 5 latest nixos generations
      };
    };
  };

  environment = {
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
      SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
    };
    systemPackages = with pkgs; [
      wireshark
      openconnect
      vdirsyncer
      todoman
      old-pkgs.segger-jlink
      acpi
      virtiofsd
      barrier
      inputs.nix-xilinx.packages.${pkgs.system}.vitis
      inputs.nix-xilinx.packages.${pkgs.system}.vitis_hls
      inputs.nix-xilinx.packages.${pkgs.system}.vivado
      inputs.nix-xilinx.packages.${pkgs.system}.model_composer
      libimobiledevice
      ifuse
      inputs.ghostty.packages.${pkgs.system}.default
      borgbackup
      qemu
      # qemu_full
      qemu-user
      nrfutil
      input-remapper
    ];
  };


  # static ip for PYNQ board
  # networking.interfaces.eth0.ipv4.addresses = [{
  #   address = "192.168.2.1";
  #   prefixLength = 24;
  # }];

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;

  programs.light.enable = true;

  networking.networkmanager.wifi.powersave = true;

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
    libinput = {
      enable = true;
      touchpad.naturalScrolling = true;
      touchpad.tapping = true;
    };

    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed

    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = false;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
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

  boot.binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
  ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;


  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
      libGLU
    ];
    # setLdLibraryPath = true;
  };

  services.openssh.enable = true;

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #           "nrf-command-line-tools-10.23.2"
  #         ];
  nixpkgs.config.permittedInsecurePackages = [
    "segger-jlink-qt4-794a"
    "googleearth-pro-7.3.4.8248"
    "electron-12.2.3"
  ];
  # enable udev rules from packages
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "51-android.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee0", MODE="0666", GROUP="plugdev"
      '';
      destination = "/etc/udev/rules.d/51-android.rules";
    })
    (pkgs.writeTextFile {
      name = "99-ftdi.rules";
      text = ''
        ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-ftdi.rules";
    })
    (pkgs.writeTextFile {
      name = "xilinx-dilligent-usb-udev";
      destination = "/etc/udev/rules.d/52-xilinx-digilent-usb.rules";
      text = ''
        ATTR{idVendor}=="1443", MODE:="666"
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Digilent", MODE:="666"
      '';
    })
    (pkgs.writeTextFile {
      name = "xilinx-pcusb-udev";
      destination = "/etc/udev/rules.d/52-xilinx-pcusb.rules";
      text = ''
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE="666"
        ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE="666"
      '';
    })
    (pkgs.writeTextFile {
      name = "xilinx-ftdi-usb-udev";
      destination = "/etc/udev/rules.d/52-xilinx-ftdi-usb.rules";
      text = ''
        ACTION=="add", ATTR{idVendor}=="0403", ATTR{manufacturer}=="Xilinx", MODE:="666"
      '';
    })
    old-pkgs.segger-jlink
    pkgs.saleae-logic-2
    my-pkgs.nrf-udev
    pkgs.platformio-core.udev
    pkgs.platformio-core
    pkgs.openocd
  ];

  # https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_16#Prevent_wake_up_in_backpack
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
  '';
}
