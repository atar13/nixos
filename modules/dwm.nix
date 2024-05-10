{ pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
      windowManager = {
          dwm.enable = true;
          dwm.package = inputs.dwm.${pkgs.system}.default;
      }
    };
  };

}
