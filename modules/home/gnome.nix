{ lib, pkgs, osConfig, ... }:
with lib;
{
  config = mkIf osConfig.desktop.gnome.enable {
    dconf.settings = {
      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [ "<Super>a" ];
        switch-applications-backward = [ "<Super>s" ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-background = [ "<Shift><Alt>Tab" ];
        switch-to-workspace-left = [ "<Super>q" ];
        switch-to-workspace-right = [ "<Super>w" ];
        move-to-workspace-left = [ "<Shift><Super>q" ];
        move-to-workspace-right = [ "<Shift><Super>w" ];
        close = [ "<Shift><Super>c" ];
      };


      "org/gnome/desktop/search-providers" = {
        disabled = [
          "org.gnome.Contacts.desktop"
          "org.gnome.Characters.desktop"
          "org.gnome.seahorse.Application.desktop"
          "org.gnome.Software.desktop"
          "org.gnome.Epiphany.desktop"
        ];
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
      };


      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;

        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "Alacritty.desktop"
          "kitty.desktop"
          "code.desktop"
          "org.kicad.kicad.desktop"
          "firefox.desktop"
          "io.github.alainm23.planify.desktop"
          "org.gnome.Calendar.desktop"
          "thunderbird.desktop"
          "signal-desktop.desktop"
          "element-desktop.desktop"
          "discord.desktop"
          "slack.desktop"
          "feishin.desktop"
          "spotify.desktop"
          "org.gnome.Calculator.desktop"
          "bitwarden.desktop"
          "gnome-system-monitor.desktop"
          "org.gnome.Settings.desktop"
          "io.missioncenter.MissionCenter.desktop"
          "re.sonny.Tangram.desktop"
        ];

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "Vitals@CoreCoding.com"
          "advanced-alt-tab@G-dH.github.com"
          # "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          # "quick-settings-audio-panel@rayzeq.github.io"
          "quick-settings-tweaks@qwreey"
          # "desktop-cube@"
          # "sound-output-device-chooser@kgshank.net"
          pkgs.gnomeExtensions.desktop-cube.extensionUuid
          pkgs.gnomeExtensions.compact-top-bar.extensionUuid
          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          # "space-bar@luchrioh"


          # "user-theme@gnome-shell-extensions.gcampax.github.com"
          # "trayIconsReloaded@selfmade.pl"
          # "Vitals@CoreCoding.com"
          # "dash-to-panel@jderose9.github.com"
          # "sound-output-device-chooser@kgshank.net"
          # "space-bar@luchrioh"
        ];

      };
      "org/gnome/shell/extensions/dash-to-dock" = {
          hot-keys = false;
      };

      "org/gnome/shell/extensions/quick-settings-tweaks" = {
        output-show-selected = true;
        input-show-selected = true;
        input-always-show = true;
      };
    };

    home.packages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.vitals
      gnomeExtensions.sound-output-device-chooser
      gnomeExtensions.quick-settings-tweaker
      gnomeExtensions.quick-settings-audio-panel
      gnomeExtensions.space-bar
      gnomeExtensions.desktop-cube
      gnomeExtensions.compact-top-bar
      gnomeExtensions.hide-top-bar
      # gnomeExtensions.advanced-alttab-window-switcher
    ];
  };
}
