{ ... }:
{
  services.prowlarr.enable = true;

  services.radarr = {
    enable = true;
    dataDir = "/data/arr/radarr/";
    user = "media";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/data/arr/sonarr/";
    user = "media";
  };

  services.lidarr = {
    enable = true;
    dataDir = "/data/arr/lidarr/";
    group = "media";
  };

  services.readarr = {
    enable = true;
    dataDir = "/data/arr/readarr/";
    group = "media";
  };

  services.bazarr.enable = true;

  services.jellyseerr = {
    enable = true;
    port = 5055;
  };
}
