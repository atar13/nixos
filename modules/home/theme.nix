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

  home.packages = with pkgs; [
    orchis-theme
    fluent-gtk-theme
  ];

  home.sessionVariables.GTK_THEME = theme.name;

  gtk.theme = {
    # name = "Materia-dark";
    name = "Orchis-Purple-Dark";
    package = pkgs.orchis-theme;
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
    gtk3 = {
      extraConfig = {
          gtk-application-prefer-dark-theme = true;
      };
    };
    # gtk4 = {
    #   AdwStyleManager.color-scheme = "ADW_COLOR_SCHEME_PREFER_DARK";
    #   extraConfig.gtk-application-prefer-dark-theme = true;
    # };
  };

  xdg.configFile."gtk-4.0/settings.ini" = {
      enable = true;
      text = ''
      [AdwStyleManager]
      color-scheme=ADW_COLOR_SCHEME_PREFER_DARK
      '';
  };

  xdg.configFile."gtk-3.0/settings.ini" = {
      enable = true;
      text = ''
      [AdwStyleManager]
      color-scheme=ADW_COLOR_SCHEME_PREFER_DARK
      '';
  };

  # dconf.settings = {
  #   "org/gnome/desktop/interface" = {
  #     gtk-theme = theme.name;
  #     color-scheme = "prefer-dark";
  #   };
  # };

}
