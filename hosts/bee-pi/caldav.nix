{ config, pkgs, ... }: {
  age.secrets.radicale-users = {
    file = ../../secrets/radicale-users.age;
    owner = "radicale";
    group = "radicale";
  };

  services.radicale = {
    enable = true;
    package = pkgs.radicale;
    settings = {
      server = {
        hosts = [ "0.0.0.0:5232" "[::]:5232" ];
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = config.age.secrets.radicale-users.path;
        # stored as plain but have encryption handled by agenix
        htpasswd_encryption = "plain";
      };
      storage = {
        filesystem_folder = "/pool/data/radicale/collections";
      };
    };
  };


  # services.xandikos = {
  #     enable = true;
  #     port = 5232;
  #     extraOptions = [ 
  #         "--autocreate"
  #         "-d /data/xandikos"
  #         "--defaults"
  #         "--current-user-principal user"
  #         "--dump-dav-xml"
  #     ];
  # };
}
