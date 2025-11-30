{ ... }:
{
  services.minecraft-server = {
    enable = true;
    declarative = true;
    eula = true;
    dataDir = "/pool/data/minecraft";
    openFirewall = true;
    serverProperties = {
      server-port = 12521;
      difficulty = 2;
      gamemode = 0;
      level-name = "8intheevenening";
      motd = "grogiworld";
      allow-cheats = true;
      enable-command-block = true;
      use-native-transport = true;
    };
  };
}
