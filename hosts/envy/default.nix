# HP-Envy Laptop specific configuration
{ config, inputs, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wg-client.nix
    (import ../../modules/nix.nix { inherit inputs pkgs; })
    (import ../../modules/cli.nix { inherit inputs pkgs; })
    ../../modules/bluetooth.nix
    ../../modules/fonts.nix
    ../../modules/gnome.nix
    ../../modules/gui.nix
    ../../modules/vscode.nix
    ../../modules/lib.nix
    ../../modules/localization.nix
  ];

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
}
