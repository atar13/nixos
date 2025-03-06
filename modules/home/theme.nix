{ lib, nixosConfig, pkgs, ... }:
with lib;
let
  theme = pkgs.materia-theme;
in
{
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  # home.sessionVariables.GTK_THEME = mkIf (nixosConfig.gui.desktop != "gnome") theme.name;
  #
  # gtk.theme = mkIf (nixosConfig.gui.desktop != "gnome") {
  #   name = theme.name;
  #   package = theme;
  # };

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
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     gtk-theme = theme.name;
  #     color-scheme = "prefer-dark";
  #   };
  # };

}
