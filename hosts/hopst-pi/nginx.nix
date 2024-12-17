{ config, ... }:

{
  age.secrets.acme-porkbun.file = ../../secrets/acme-porkbun.age;

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

  services.nginx = {
    enable = true;
    #recommendedTlsSettings = true;
    #recommendedOptimisation = true;
    #recommendedGzipSettings = true;
    #recommendedProxySettings = true;

    virtualHosts."immich.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      serverAliases = [
        "photos.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_set_header Host              $host;
          proxy_set_header X-Real-IP         $remote_addr;
          proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # http://nginx.org/en/docs/http/websocket.html
          proxy_set_header   Upgrade    $http_upgrade;
          proxy_set_header   Connection "Upgrade";
          proxy_redirect off;
        '';
      };
    };

    virtualHosts."jellyfin.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      serverAliases = [
        "grog2day.atarbinian.com"
        "media.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        extraConfig =
          ''
            proxy_pass_request_headers on;

            proxy_set_header Host $host;

            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $http_connection;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
      };
    };

    virtualHosts."transmission.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9091";
      };
    };

    # virtualHosts."jackett.atarbinian.com" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   addSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:9117";
    #   };
    # };

    virtualHosts."prowlarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
    };

    virtualHosts."sonarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };

    virtualHosts."radarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };

    virtualHosts."bazarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:6767";
      };
    };

    virtualHosts."lidarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
      };
    };

    virtualHosts."readarr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8787";
      };
    };

    virtualHosts."dozzle.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9090";
      };
    };

    virtualHosts."jellyseerr.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055";
      };
    };

    virtualHosts."books.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      serverAliases = [
        "kavita.atarbinian.com"
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:5000";
      };
    };

    # virtualHosts."traggo.atarbinian.com" = {
    #   enableACME = true;
    #   acmeRoot = null;
    #   addSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:3030";
    #   };
    # };

    virtualHosts."time.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8030";
      };
    };

    virtualHosts."webdav.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:7080";
        extraConfig = ''
          proxy_buffering       off;
          client_max_body_size  0;
          proxy_read_timeout    120s;
          proxy_connect_timeout 90s;
          proxy_send_timeout    90s;
          proxy_redirect        off;
          proxy_set_header      Host $host;
          proxy_set_header      X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header      X-Forwarded-Proto $scheme;
          proxy_set_header      X-Forwarded-Ssl on;
          proxy_set_header      Connection "";
          proxy_pass_header     Date;
          proxy_pass_header     Server;
        '';
      };
    };

    virtualHosts."caldav.atarbinian.com" = {
      enableACME = true;
      acmeRoot = null;
      addSSL = true;
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

    # virtualHosts."todo.atarbinian.com" = {
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:3456/";
    #   };
    # };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@atarbinian.com";
    defaults = {
      dnsProvider = "porkbun";
      credentialsFile = config.age.secrets.acme-porkbun.path;
    };
  };
}
