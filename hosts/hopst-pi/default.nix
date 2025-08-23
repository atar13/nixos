{ config, lib, inputs, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./wireguard.nix
    (import ./nginx.nix { inherit config; })
    ./ddns.nix
    # (import ./immich.nix { inherit pkgs lib config; })
    ./arr.nix
    ./kavita.nix
    (import ./caldav.nix { inherit config pkgs; })

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

  # virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users = {
    mutableUsers = true;
    users."atarbinian" = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "docker" "radarr" "lidarr" "readarr" "sonarr" "nfs" "media" ];
    };
    users."media" = {
      group = "media";
      extraGroups = [ "video" "docker" "radarr" "sonarr" "lidarr" "readarr" ];
      isSystemUser = true;
    };
    groups."media" = { };

    users."jellyfin" = {
      extraGroups = [ "video" "radarr" "sonarr" "lidarr" ];
    };
    users."kavita" = {
      extraGroups = [ "readarr" ];
    };
    users."bazarr" = {
      extraGroups = [ "radarr" "sonarr" ];
    };

    # users."books" = {
    #   isNormalUser = true;
    #   group = "books";
    #   extraGroups = [ "readarr" ];
    # };
  };
}
