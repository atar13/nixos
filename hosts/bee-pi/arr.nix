{ ... }:
{
  services.prowlarr.enable = true;

  services.radarr = {
    enable = true;
    dataDir = "/pool/data/arr/radarr/";
    user = "media";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/pool/data/arr/sonarr/";
    user = "media";
  };

  services.lidarr = {
    enable = true;
    dataDir = "/pool/data/arr/lidarr/";
    group = "media";
  };

  services.readarr = {
    enable = true;
    dataDir = "/pool/data/arr/readarr/";
    group = "media";
  };

  services.bazarr = {
      enable = true;
      user = "media";
      group = "media";
    };

  services.jellyseerr = {
    enable = true;
    port = 5055;
  };
}
