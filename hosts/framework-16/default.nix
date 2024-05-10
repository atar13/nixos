# Framework 16 Laptop specific configuration
{ lib, config, inputs, pkgs, old-pkgs, hostname, ... }:
{
  imports = [
    # ./hardware-configuration.nix
    # ./wg-client.nix
    (import ../../modules/nix.nix { inherit inputs pkgs; })
    (import ../../modules/cli.nix { inherit inputs pkgs; })
    ../../modules/bluetooth.nix
    ../../modules/fonts.nix
    ../../modules/gnome.nix
    (import ../../modules/dwm.nix { inherit lib pkgs config inputs; })
    ../../modules/desktop.nix
    (import ../../modules/gui.nix { inherit pkgs old-pkgs; })
    ../../modules/lib.nix
    ../../modules/localization.nix
  ];

  # users.users.nixosvmtest.isSystemUser = true ;
  # users.users.nixosvmtest.initialPassword = "test";
  # users.users.nixosvmtest.group = "nixosvmtest";
  # users.groups.nixosvmtest = {};
  # virtualisation.vmVariant = {
  # # following configuration is added only when building VM with build-vm
  #     virtualisation = {
  #       memorySize =  2048; # Use 2048MiB memory.
  #       cores = 3;         
  #     };
  # };

  # desktop.dwm.enable = true;
  desktop.gnome.enable = true;
  networking.firewall.allowedTCPPorts = [ 2355 ];
  networking.firewall.allowedUDPPorts = [ 2355 ];

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
    };
    systemPackages = with pkgs; [
      old-pkgs.segger-jlink
      acpi
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;

  programs.light.enable = true;

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
        touchpad.tapping = true;
      };
    };
    # auto-cpufreq.enable = true; # don't use with powerprofiles daemon
    power-profiles-daemon.enable = true;
    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
    printing = {
      enable = true;
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
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
      name = "99-ftdi.rules";
      text = ''
        ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6015", MODE="0666"
      '';
      destination = "/etc/udev/rules.d/99-ftdi.rules";
    })
    old-pkgs.segger-jlink
    pkgs.saleae-logic-2
  ];
}
