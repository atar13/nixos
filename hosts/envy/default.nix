# HP-Envy Laptop specific configuration
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./wg-client.nix
  ];

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
    blueman.enable = true;
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

  virtualisation.docker.storageDriver = "btrfs";

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = true;
        DiscoverableTimeout = 0;
      };
    };
  };
}
