{ config, inputs, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./wireguard.nix
    ./nginx.nix
    ./ddns.nix

    (import ../../modules/cli.nix { inherit inputs pkgs; })
    ../../modules/lib.nix
    ../../modules/localization.nix
    (import ../../modules/nix.nix { inherit inputs pkgs; })
  ];

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom

    wireguard-tools
    borgbackup

    docker-compose
  ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
  };

  services.localtimed.enable = true;
  services.geoclue2.enable = true;

  virtualisation.docker.enable = true;

  services.openssh = {
	enable = true;
	settings = {
	   PermitRootLogin = "no";
	   PasswordAuthentication = false;
	};
  };

  services.jellyfin = {
    enable = true;
  };

  # age.secrets.pi-atarbinian-password.file = ../../secrets/pi-atarbinian-password.age;
  users = {
    mutableUsers = true;
    users."atarbinian" = {
      isNormalUser = true;
      # hashedPasswordFile = config.age.secrets.pi-atarbinian-password.path;
      extraGroups = [ "wheel" "video" "docker" ];
    };
    users."jellyfin" = {
      extraGroups = [ "video" ];
    };
  };
}
