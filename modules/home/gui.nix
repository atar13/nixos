{ username, ... }:
let
  browser = "firefox.desktop";
  pdf = "mupdf.desktop";
in
{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;

      "application/pdf" = pdf;
    };
  };

  gtk.gtk3.bookmarks = [
    "file:///home/${username}/Dev"
    "file:///home/${username}/Pkgs"
  ];


  services.flameshot.enable = true;
  services.flameshot.settings = {
    General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };
}
