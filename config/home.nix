{ pkgs, lib, user, ... }:
{
  programs = {
  	home-manager.enable = true;
  };
  home = {
    enableNixpkgsReleaseCheck = false;
    packages = pkgs.callPackage ./packages.nix {};
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "23.05";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-purple-dark";
      package = pkgs.tela-icon-theme;
    };
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    cursorTheme = {
    	name = "Bibata-Modern-Classic";
	package = pkgs.bibata-cursors;
    };
    gtk3.bookmarks = [ "file:///home/Pkgs" ]; # TODO: bookmarks for file browser
  };

  programs.git = {
  	enable = true;
	aliases = {
		co = "checkout";
		sb = "status"; # TODO: 
	};
	extraConfig = {
		core = {
			editor = "nvim";
		};
	};
  };

  programs.gitui.enable = true;
  programs.wezterm.enable = true;

  # for dwm setup
  services.dunst.enable = true;
  programs.feh.enable = true;
  services.dwm-status.enable = true;
  services.dwm-status.order = [ "audio" "backlight" "battery" "cpu_load" "time" ];
  services.dwm-status.extraConfig = {
	  separator = "#";

	  battery = {
	    notifier_levels = [ 2 5 10 15 20 ];
	  };

	  time = {
	    format = "%H:%M";
	  };
  };

  # testing symlinks with home manager
  home.file = {
      "kitty".source = "/home/atarbinian/Pkgs/dotfiles/kitty/.config/kitty/kitty.conf";
      "kitty".target = ".config/kitty/kitty.conf";
  };

  # Screen lock
  # services.screen-locker = {
  #   enable = true;
  #   inactiveInterval = 30;
  #   lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
  #   xautolock.extraOptions = [
  #     "Xautolock.killer: systemctl suspend"
  #   ];
  # };

  # Auto mount devices
  services.udiskie.enable = true;

  # services.dunst = {
  #   enable = true;
  #   package = pkgs.dunst;
  #   settings = {
  #     global = {
  #     monitor = 0;
  #     follow = "mouse";
  #     border = 0;
  #     height = 400;
  #     width = 320;
  #     offset = "33x65";
  #     indicate_hidden = "yes";
  #     shrink = "no";
  #     separator_height = 0;
  #     padding = 32;
  #     horizontal_padding = 32;
  #     frame_width = 0;
  #     sort = "no";
  #     idle_threshold = 120;
  #     font = "Noto Sans";
  #     line_height = 4;
  #     markup = "full";
  #     format = "<b>%s</b>\n%b";
  #     alignment = "left";
  #     transparency = 10;
  #     show_age_threshold = 60;
  #     word_wrap = "yes";
  #     ignore_newline = "no";
  #     stack_duplicates = false;
  #     hide_duplicate_count = "yes";
  #     show_indicators = "no";
  #     icon_position = "left";
  #     icon_theme = "Adwaita-dark";
  #     sticky_history = "yes";
  #     history_length = 20;
  #     history = "ctrl+grave";
  #     browser = "google-chrome-stable";
  #     always_run_script = true;
  #     title = "Dunst";
  #     class = "Dunst";
  #     max_icon_size = 64;
  #   };
  #   };
  # };

}
