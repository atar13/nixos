{ pkgs, lib, user, spicetify-nix, ... }:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
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
  # home.pointerCursor = {
  # 	name = "Bibata-Modern-Classic";
  #       package = pkgs.bibata-cursors;
  #       gtk.enable = true;
  # 	x11.enable = true;
  # };
  # home.shellAliases = {
  # };

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
    gtk3.bookmarks = [ "file:///home/${user}/Dev" "file:///home/${user}/Pkgs" ]; # TODO: bookmarks for file browser
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
  # services.dunst.enable = true;
  # services.picom.enable = true;
  # services.picom.package = pkgs.picom-next;
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

      "zsh".source = "/home/atarbinian/Pkgs/dotfiles/zsh/.zshrc";
      "zsh".target = ".zshrc";

      "starship".source = "/home/atarbinian/Pkgs/dotfiles/starship/.config/starship.toml";
      "starship".target = ".config/starship.toml";
  };


  # Screen lock
  services.screen-locker = {
    enable = true;
    inactiveInterval = 30;
    lockCmd = "/home/atarbinian/Pkgs/dotfiles/misc/lock/lock";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };

  # Auto mount devices
  services.udiskie.enable = true;

  services.dunst = {
    enable = true;
    package = pkgs.dunst;
    settings = {
      global = {
      monitor = 0;
      follow = "mouse";
      border = 0;
      height = 400;
      width = 320;
      offset = "33x65";
      indicate_hidden = "yes";
      shrink = "no";
      separator_height = 0;
      padding = 16;
      horizontal_padding = 16;
      frame_width = 0;
      sort = "no";
      idle_threshold = 120;
      font = "Noto Sans";
      line_height = 4;
      markup = "full";
      format = "<b>%s</b>\n%b";
      alignment = "left";
      transparency = 10;
      show_age_threshold = 60;
      word_wrap = "yes";
      ignore_newline = "no";
      stack_duplicates = false;
      hide_duplicate_count = "yes";
      show_indicators = "no";
      icon_position = "left";
      icon_theme = "Adwaita-dark";
      sticky_history = "yes";
      history_length = 20;
      # history = "ctrl+grave";
      browser = "firefox";
      always_run_script = true;
      title = "Dunst";
      class = "Dunst";
      max_icon_size = 64;
    };
    };
  };

  services.flameshot.enable = true;
  services.flameshot.settings = {
	  General = {
	    disabledTrayIcon = false;
	    showStartupLaunchMessage = false;
	  };
	};
	# programs.vscode = {
	#   enable = true;
	#   extensions = with pkgs.vscode-extensions; [
	#     dracula-theme.theme-dracula
	#     vscodevim.vim
	#     yzhang.markdown-all-in-one
	#     ms-vscode.cpptools
	#   ];
	# };

	# allow spotify to be installed if you don't have unfree enabled already
	  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	    "spotify"
	  ];

	  # import the flake's module for your system
	  imports = [ spicetify-nix.homeManagerModule ];

	  # configure spicetify :)
	  programs.spicetify =
	    {
	      enable = true;
	      theme = spicePkgs.themes.Dribbblish;
	      colorScheme = "purple";

	      enabledExtensions = with spicePkgs.extensions; [
		fullAppDisplay
		shuffle # shuffle+ (special characters are sanitized out of ext names)
		hidePodcasts
		autoSkipVideo
		loopyLoop
		keyboardShortcut # https://spicetify.app/docs/advanced-usage/extensions/#keyboard-shortcut
		popupLyrics
		powerBar
		seekSong
		playlistIcons
		fullAlbumDate
		playlistIntersection
		skipStats
		wikify
		songStats
		history
		adblock
	      ];
	    };
}
