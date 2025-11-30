{ config, lib, inputs, pkgs, old-pkgs, my-pkgs, hostname, ... }:
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
    ../../modules/bluetooth.nix
    # ./gonic.nix
    # ./joplin.nix
    ./homarr.nix
    # ./dash.nix
  ];
  age.secrets.joplin-env.file = ../../secrets/joplin-env.age;
  age.secrets.webdav.file = ../../secrets/webdav.age;

  environment.systemPackages = with pkgs; [
    wireguard-tools
    borgbackup

    docker-compose
    old-pkgs.segger-jlink
    yt-dlp
    # my-pkgs.soundalike
  ];

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "9.9.9.9" "1.1.1.1" ];
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 3001 5432 5433 8800 8001 8888 7575 4747 9980 ];
    allowedTCPPorts = [ 3001 5432 5433 8800 8001 8888 7575 4747 9980 ];
  };

  # services.localtimed.enable = true;
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
  hardware.graphics = {
    # hardware.opengl in 24.05
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      libva-vdpau-driver
      libvdpau-va-gl
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      # intel-media-sdk # QSV up to 11th gen
      intel-gpu-tools
    ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # services.trilium-server = {
  #   enable = true;
  #   host = "0.0.0.0";
  #   port = 5151;
  #   dataDir = "/data/trilium/";
  #   nginx = {
  #     enable = true;
  #     hostName = "trilium.atarbinian.com";
  #   };
  #  };

  services.scrutiny = {
    enable = false;
    openFirewall = true;
    settings.web.listen.port = 9991;
  };

  services.cockpit = {
    enable = false;
    openFirewall = true;
    port = 9992;
  };

  # age.secrets.spotify-id.file = ../../secrets/spotify-id.age;
  # age.secrets.spotify-secret.file = ../../secrets/spotify-secret.age;

  services.navidrome = {
    enable = true;
    group = "media";
    settings = {
      Port = 4533;
      MusicFolder = "/pool/data/Media/music_testing/library";
      DataFolder = "/pool/data/Media/music_testing/data/";
      CacheFolder = "/pool/data/Media/music_testing/cache/";
      BaseUrl = "https://music.atarbinian.com";
      UIWelcomeMessage = "parev";
      # Spotify = {
      #   ID = (builtins.readFile config.age.secrets.spotify-id.path);
      #   Secret = (builtins.readFile config.age.secrets.spotify-secret.path);
      # };
    };
  };

  services.polaris = {
    enable = false;
    group = "media";
    port = 5050;
    openFirewall = true;
    settings = {
      settings.reindex_every_n_seconds = 60 * 60; # weekly, default is 1800
      settings.album_art_pattern = "(cover|front|folder)\.(jpeg|jpg|png|bmp|gif)";
      mount_dirs = [
        {
          name = "Library";
          source = "/data/Media/music_testing/library/";
        }
      ];
    };
  };

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 4534;
    group = "media";
    openFirewall = false;
  };

  services.gonic = {
    enable = false;
    settings = {
      listen-addr = "0.0.0.0:4747";
      music-path = "/pool/data/Media/krist_music/";
      playlists-path = "/pool/data/gonic_old/playlists/";
      podcast-path = "/pool/data/gonic_old/podcast/";
      cache-path = "/var/cache/gonic/";
      # db-path = "/pool/data/gonic_old/data/gonic.db";
      scan-watcher-enabled = true;
    };
  };

  services.airsonic = {
    enable = true;
    port = 4040;
    # user = "media";
    # virtualHost = "krist.atarbinian.com";
    listenAddress = "0.0.0.0";
  };

  services.webdav = {
    enable = true;
    user = "webdav";
    group = "webdav";
    environmentFile = config.age.secrets.webdav.path;
    settings = {
      address = "0.0.0.0";
      port = 7080;
      debug = true;
      # directory = "/data/webdav/joplin/atarbinian/";
      users = [
        {

          username = "{env}JOPLIN_ATARBINIAN_USERNAME";
          password = "{env}JOPLIN_ATARBINIAN_PASSWORD";
          permissions = "CRUD";
          scope = "/pool/data/webdav/joplin/atarbinian/";
          modify = true;
          auth = true;
        }
        # {
        #   username = "rad";
        #   password = "rad";
        #   directory = "/data/webdav/joplin/atarbinian/";
        # }
      ];
    };
  };


  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
      "homeassistant_hardware"
      "zha"
      "apple_tv"
      "homekit"
      "tradfri"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
      http = {
        server_host = "::1";
        trusted_proxies = [ "::1" ];
        use_x_forwarded_for = true;
      };
      automation = "!include automations.yaml";
    };
  };

  age.secrets.nextcloud-admin.file = ../../secrets/nextcloud-admin.age;
  age.secrets.nextcloud-db-password.file = ../../secrets/nextcloud-db-password.age;
  services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      https = true;
      hostName = "cloud.atarbinian.com";
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps) calendar tasks onlyoffice richdocuments;
      };
      database.createLocally = true;
      extraAppsEnable = true;
      config.adminpassFile = config.age.secrets.nextcloud-admin.path;
      config.dbtype = "pgsql";
      # config.dbuser = "Supreme5753";
      # config.dbname = "pgsql";
      # config.dbhost = "localhost";
      # config.dbpassFile = config.age.secrets.nextcloud-db-password.path;
      settings.enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
  };

  systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url = "http://[::1]:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://office.atarbinian.com";
    wopi_allowlist = lib.concatStringsSep "," [
      "10.0.0.1"
      "127.0.0.1"
      "::1"
    ];
  in {
    wantedBy = ["multi-user.target"];
    after = ["nextcloud-setup.service" "coolwsd.service"];
    requires = ["coolwsd.service"];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${lib.escapeShellArg wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${lib.escapeShellArg public_wopi_url}
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${lib.escapeShellArg wopi_allowlist}
      ${occ}/bin/nextcloud-occ richdocuments:setup
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

  services.collabora-online = {
    enable = true;
    port = 9980; # default
    settings = {
      # Rely on reverse proxy for SSL
      ssl = {
        enable = false;
        termination = true;
      };

      # Listen on loopback interface only, and accept requests from ::1
      net = {
        listen = "loopback";
        post_allow.host = ["::1"];
      };

      # Restrict loading documents from WOPI Host nextcloud.example.com
      storage.wopi = {
        "@allow" = true;
        host = ["cloud.atarbinian.com"];
      };

      # Set FQDN of server
      server_name = "office.atarbinian.com";
    };
  };

  services.onlyoffice = {
    enable = false;
    hostname = "office.atarbinian.com";
    port = 7845;
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
      extraGroups = [ "video" "docker" ];
      isSystemUser = true;
    };
    groups."media" = { };

    users."jellyfin" = {
      extraGroups = [ "video" "media" "render" ];
    };
    users."kavita" = {
      extraGroups = [ "media" ];
    };
    # users."ddclient" = { };
    # users."bazarr" = {
    #   extraGroups = [ "media" ];
    # };
    # users."gonic" = {
    #   group = "media";
    #   isSystemUser = true;
    # };
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
