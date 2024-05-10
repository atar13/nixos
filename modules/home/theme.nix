{ lib, nixosConfig, pkgs, ... }:
with lib;
{
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables.GTK_THEME = mkIf (nixosConfig.desktop.dwm.enable) "Materia-dark";
  gtk.theme = mkIf (nixosConfig.desktop.dwm.enable) {
    name = "Materia-dark";
    package = pkgs.materia-theme;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-purple-dark";
      package = pkgs.tela-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

}
