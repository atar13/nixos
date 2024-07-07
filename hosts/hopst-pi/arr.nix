{ ... }:
{
  services.prowlarr.enable = true;

  services.radarr = {
    enable = true;
    dataDir = "/data/arr/radarr/";
  };

  services.sonarr = {
    enable = true;
    dataDir = "/data/arr/sonarr/";
  };

  services.lidarr = {
    enable = true;
    dataDir = "/data/arr/lidarr/";
  };

  services.readarr = {
    enable = true;
    dataDir = "/data/arr/readarr/";
  };

  services.bazarr.enable = true;

  services.jellyseerr = {
    enable = true;
    port = 5055;
  };
}
