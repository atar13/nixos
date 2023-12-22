{ config, ... }: {
  age.secrets.namecheap-password.file = ../../secrets/namecheap-password.age;

  services.ddclient = {
    enable = true;
    verbose = false;
    quiet = true;
    username = "atarbinian.com";
    use = "web, web=dynamicdns.park-your-domain.com/getip";
    server = "dynamicdns.park-your-domain.com";
    domains = [ "vpn" ];
    protocol = "namecheap";
    passwordFile = config.age.secrets.namecheap-password.path;
  };
}
