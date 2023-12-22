{ ... }:
{
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        AutoEnable = true;
        DiscoverableTimeout = 0;
      };
    };
  };
}
