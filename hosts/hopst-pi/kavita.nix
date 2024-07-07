{ config, ... }:

{
  age.secrets.kavita-token = {
    file = ../../secrets/kavita-token.age;
    owner = "kavita";
    group = "kavita";
  };

  services.kavita = {
    enable = true;
    # user = "books";
    port = 5000;
    dataDir = "/data/kavita";
    tokenKeyFile = config.age.secrets.kavita-token.path;
  };
}
