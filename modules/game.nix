{ pkgs, ... }:
{
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
        lutris
        # wine
        wineWowPackages.stable
        gnome3.adwaita-icon-theme
    ]; 
}
