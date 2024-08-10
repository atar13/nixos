{ config, ... }: {
  age.secrets.ddclient-config-porkbun.file = ../../secrets/ddns-config-porkbun.age;

  services.ddclient = {
    enable = true;
    verbose = true;
    quiet = false;
    configFile = config.age.secrets.ddclient-config-porkbun.path;
  };
}
