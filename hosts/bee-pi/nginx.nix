{ config, ... }:

{
  age.secrets.acme-porkbun.file = ../../secrets/acme-porkbun.age;

  networking.firewall = {
    allowedTCPPorts = [ 80 443 25565 ];
  };

  services.nginx = {
    enable = true;
    logError = "stderr debug";
    # mapHashMaxSize = 1024;
    recommendedTlsSettings = true;
    # recommendedOptimisation = true;
    # recommendedGzipSettings = true;
    recommendedProxySettings = true;
    appendHttpConfig = ''
        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 128;
    '';

    virtualHosts."immich.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      serverAliases = [
        "photos.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        # proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_set_header Host              $host;
          proxy_set_header X-Real-IP         $remote_addr;
          proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # enable websockets: http://nginx.org/en/docs/http/websocket.html
          proxy_http_version 1.1;
          proxy_set_header   Upgrade    $http_upgrade;
          proxy_set_header   Connection "upgrade";
          proxy_redirect     off;

          # set timeout
          proxy_read_timeout 600s;
          proxy_send_timeout 600s;
          send_timeout       600s;
        '';
      };
    };

    virtualHosts."jellyfin.atarbinian.com" = {
      enableACME = true;
      forceSSL = true;
      serverAliases = [
        "grog2day.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
      #   extraConfig =
      #     ''
      #       proxy_pass_request_headers on;
      #
      #       proxy_set_header Host $host;
      #
      #       proxy_set_header X-Real-IP $remote_addr;
      #       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #       proxy_set_header X-Forwarded-Proto $scheme;
      #       proxy_set_header X-Forwarded-Host $http_host;
      #
      #       proxy_set_header Upgrade $http_upgrade;
      #       proxy_set_header Connection $http_connection;
      #
      #       # Disable buffering when the nginx proxy gets very resource heavy upon streaming
      #       proxy_buffering off;
      #     '';
      };
    };

    virtualHosts."transmission.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
      };
    };

    virtualHosts."prowlarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
    };

    virtualHosts."sonarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };

    virtualHosts."radarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };

    virtualHosts."bazarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:6767";
      };
    };

    # virtualHosts."lidarr.atarbinian.com" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:8686";
    #   };
    # };

    # virtualHosts."readarr.atarbinian.com" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:8787";
    #   };
    # };

    virtualHosts."jellyseerr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
      };
    };

    virtualHosts."books.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      extraConfig = ''
        proxy_buffering off;
          # enable websockets: http://nginx.org/en/docs/http/websocket.html
          proxy_http_version 1.1;
          proxy_set_header   Upgrade    $http_upgrade;
          proxy_set_header   Connection "upgrade";
          proxy_redirect     off;
      '';
      locations."/" = {
        proxyPass = "http://127.0.0.1:4534";
        proxyWebsockets = true;
      };
    };

    virtualHosts."kavita.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5000";
      };
    };

    virtualHosts."music.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4533";
      };
    };

    virtualHosts."grocry.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9283";
        extraConfig = ''
            try_files $uri /index.php$is_args$query_string;
        '';
      };
    };

    virtualHosts."time.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8030";
      };
    };


    virtualHosts."minecraft.atarbinian.com" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 25565;
        }
        {
          addr = "[::0]";
          port = 25565;
        }
      ];
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:12521";
      };
    };

    virtualHosts."webdav.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7080";
        extraConfig = ''
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_redirect off;
        '';
      };
    };

    virtualHosts."caldav.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      serverAliases = [
        "radicale.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:5232";
        extraConfig = ''
          proxy_set_header  X-Script-Name "";
          proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header  Host $host;
          proxy_pass_header Authorization;
        '';
        #     # proxy_pass_header Authorization;
        # extraConfig = ''
        #     proxy_set_header  X-Script-Name /;
        #     proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
        #     proxy_set_header  X-Forwarded-Host $http_host;
        #     proxy_set_header  Host $host;
        #     auth_basic        "Radicale - Password Required";
        #     auth_basic_user_file /etc/nginx/htpasswd;
        # '';
      };

      # # https://github.com/Kozea/Radicale/issues/786#issuecomment-1934202630
      # locations."/.well-known/caldav".return = "301 http://caldav.atarbinian.com$request_uri";
      # locations."/.well-known/carddav".return = "301 http://caldav.atarbinian.com$request_uri";
      # locations."/remote.php/caldav".return = "301 http://caldav.atarbinian.com$request_uri";
      # locations."/remote.php/carddav".return = "301 http://caldav.atarbinian.com$request_uri";
    };

    virtualHosts."home.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7575";
      };
    };

    virtualHosts."krist.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4040";
      };
    };

    virtualHosts."multi.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9078";
      };
    };

    virtualHosts."koito.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4110";
      };
    };

    virtualHosts."maloja.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:42010";
      };
    };

    virtualHosts."nogy.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;
      extraConfig = ''
        proxy_buffering off;
          # enable websockets: http://nginx.org/en/docs/http/websocket.html
          proxy_http_version 1.1;
          proxy_set_header   Upgrade    $http_upgrade;
          proxy_set_header   Connection "upgrade";
          proxy_redirect     off;

          proxy_headers_hash_max_size 1024;
          proxy_headers_hash_bucket_size 128;
      '';
      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
      };
    };


    virtualHosts."cloud.atarbinian.com" = {
      addSSL = true;
      enableACME = true;
    };

    virtualHosts."office.atarbinian.com" =  {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.collabora-online.port}";
        proxyWebsockets = true; # collabora uses websockets
      };
    };

    # virtualHosts."office.atarbinian.com" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   forceSSL = true;
    #   # locations."/" = {
    #   #   proxyPass = "http://127.0.0.1:7845";
    #   # };
    # };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@atarbinian.com";
    defaults = {
      dnsProvider = "porkbun";
      credentialsFile = config.age.secrets.acme-porkbun.path;
    };
    certs = { 
        ${config.services.nextcloud.hostName}.email = config.security.acme.defaults.email; 
    };
  };
}
