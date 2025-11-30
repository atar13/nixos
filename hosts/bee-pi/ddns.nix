{ config, ... }: {
  age.secrets.ddclient-config-porkbun.file = ../../secrets/ddns-config-porkbun.age;

  services.ddclient = {
    enable = false;
    verbose = true;
    quiet = false;
    configFile = config.age.secrets.ddclient-config-porkbun.path;
  };
}
