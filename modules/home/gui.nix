{ username, ... }:
let
  browser = "firefox.desktop";
  pdf = "mupdf.desktop";
  img = "org.gnome.Loupe.desktop";
  signal = "signal.desktop";
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
      "x-scheme-handler/sgnl" = signal;
      "x-scheme-handler/signalcaptcha" = signal; 

      "application/pdf" = pdf;

      "image/jpeg" = img;
      "image/png" = img;
    };
  };

  gtk.gtk3.bookmarks = [
    "file:///home/${username}/Downloads"
    "file:///home/${username}/Documents"
    "file:///home/${username}/Dev"
    "file:///home/${username}/Pkgs"
    "file:///home/${username}/nixos"
    "file:///home/${username}/dotfiles"
    "file:///home/${username}/Pictures"
    "file:///home/${username}/Nextcloud"
  ];

  services.flameshot.enable = true;
  services.flameshot.settings = {
    General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };
}
