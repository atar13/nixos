{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
  };

  services.nginx = {
    enable = true;
    #recommendedTlsSettings = true;
    #recommendedOptimisation = true;
    #recommendedGzipSettings = true;
    #recommendedProxySettings = true;

    virtualHosts."photos.atarbinian.com" = {
      http2 = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080/";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_set_header Host              $host;
          proxy_set_header X-Real-IP         $remote_addr;
          proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          # http://nginx.org/en/docs/http/websocket.html
          proxy_set_header   Upgrade    $http_upgrade;
          proxy_set_header   Connection "upgrade";
          proxy_redirect off;
        '';
      };
    };

    virtualHosts."jellyfin.atarbinian.com" = {
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
  };
}
