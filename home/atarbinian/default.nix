# Home configuration for all hosts
{ pkgs, username, dotfiles, spicetify-nix, ... }:
let
  browser = "firefox";
  spicetify-pkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  imports = [
    spicetify-nix.homeManagerModule
  ];
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "spotify"
  # ];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    spotify
  ];

  home.shellAliases = {
  };

  home.file = {
    ".zshrc".source = "${dotfiles}/zsh/.zshrc";
  };

  xdg.configFile = {
    alacritty.source = "${dotfiles}/alacritty/.config/alacritty";
    cmus.source = "${dotfiles}/cmus/.config/cmus";
    kitty.source = "${dotfiles}/kitty/.config/kitty";
    "starship.toml".source = "${dotfiles}/starship/.config/starship.toml";
    nvim = {
      # needs to be recursive instead of symlink to get packer to work
      # https://github.com/nix-community/home-manager/issues/2282#issuecomment-903299819
      recursive = true;
      # source = "${dotfiles}/nvim/.config/nvim";
      source = "/home/${username}/dotfiles/nvim/.config/nvim";
    };
    tmux = {
      recursive = true;
      source = "${dotfiles}/tmux/.config/tmux";
    };
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = "${browser}";
      "x-scheme-handler/http" = "${browser}";
      "x-scheme-handler/https" = "${browser}";
      "x-scheme-handler/about" = "${browser}";
      "x-scheme-handler/unknown" = "${browser}";

      "application/pdf" = "mupdf";
    };
  };

  home.pointerCursor = {
  	name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    gtk.enable = true;
  	x11.enable = true;
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
    gtk3.bookmarks = [
      "file:///home/${username}/Dev"
      "file:///home/${username}/Pkgs"
    ];
  };

  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      sb = "status -s";
      l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      b = "!git for-each-ref --sort='-authordate' --format='%(authordate)%09%(objectname:short)%09%(refname)' refs/heads | sed -e 's-refs/heads/--'";

      d = "diff --color-words";
      ds = "diff --stat --color-words";
      dc = "diff --cached --color-words";

    };
    extraConfig = {
      color.ui = true;
      core.editor = "nvim";
      push.autoSetupRemote = true;
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks."pi" = {
      hostname = "10.0.0.1";
      user = "atarbinian";
    };
  };

  services.flameshot.enable = true;
  services.flameshot.settings = {
    General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };

  # Auto mount devices
  services.udiskie.enable = true;

  # import the flake's module for your system

  # # configure spicetify :)
  # programs.spicetify =
  #   {
  #     enable = true;
  #     # theme = spicetify-pkgs.themes.Dribbblish;
  #     # colorScheme = "purple";

  #     # enabledExtensions = with spicetify-pkgs.extensions; [
  #     #   fullAppDisplay
  #     #   shuffle # shuffle+ (special characters are sanitized out of ext names)
  #     #   hidePodcasts
  #     #   autoSkipVideo
  #     #   loopyLoop
  #     #   keyboardShortcut # https://spicetify.app/docs/advanced-usage/extensions/#keyboard-shortcut
  #     #   popupLyrics
  #     #   powerBar
  #     #   seekSong
  #     #   playlistIcons
  #     #   fullAlbumDate
  #     #   playlistIntersection
  #     #   skipStats
  #     #   wikify
  #     #   songStats
  #     #   history
  #     #   adblock
  #     # ];
  #   };

  home.stateVersion = "23.11";
}
