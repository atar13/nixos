{ config, lib, inputs, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./wireguard.nix
    (import ./nginx.nix { inherit config; })
    ./ddns.nix
    #(import ./immich.nix { inherit pkgs lib config; })
    ./arr.nix
    ./kavita.nix
    (import ./caldav.nix { inherit config pkgs; })
    ./minecraft-server.nix
    ./timetagger.nix

    (import ../../modules/cli.nix { inherit inputs pkgs; })
    ../../modules/lib.nix
    ../../modules/localization.nix
    (import ../../modules/nix.nix { inherit inputs pkgs; })
  ];

  environment.systemPackages = with pkgs; [
    wireguard-tools
    borgbackup

    docker-compose
  ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3001 5432 ];
    allowedTCPPorts = [ 3001 5432 ];
  };

  services.localtimed.enable = true;
  services.geoclue2.enable = true;

  virtualisation.docker = {
	  enable = true;
	  package = pkgs.docker_25;
  };

  programs.ssh.startAgent = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # 1. enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.graphics = { # hardware.opengl in 24.05
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk # QSV up to 11th gen
      intel-gpu-tools
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.trilium-server = {
      enable = true;
      host = "0.0.0.0";
      port = 5151;
      dataDir = "/data/trilium/";
      nginx = {
          enable = true;
          hostName = "trilium.atarbinian.com";
      };
  };

  users = {
    mutableUsers = true;
    users."atarbinian" = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "docker" "media" "render" ];
    };
    users."media" = {
      group = "media";
      extraGroups = [ "video" "docker"];
      isSystemUser = true;
    };
    groups."media" = {};

    users."jellyfin" = {
      extraGroups = [ "video" "media" "render" ];
    };
    users."kavita" = {
      extraGroups = [ "media" ];
    };
    users."bazarr" = {
      extraGroups = [ "media" ];
    };
    # users."radarr" = {
    #   extraGroups = [ "media" ];
    # };
    # users."sonarr" = {
    #   extraGroups = [ "media" ];
    # };

    # users."books" = {
    #   isNormalUser = true;
    #   group = "books";
    #   extraGroups = [ "readarr" ];
    # };
  };
}
