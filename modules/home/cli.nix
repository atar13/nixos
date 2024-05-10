# { lib, inputs, ... }:
{ dotfiles, username, ... }:
# with lib;
{
  home.file = {
    ".zshrc".source = "${dotfiles}/zsh/.zshrc";
  };

  xdg.configFile = {
    alacritty.source = "${dotfiles}/alacritty/.config/alacritty";
    cmus.source = "${dotfiles}/cmus/.config/cmus";
    kitty.source = "${dotfiles}/kitty/.config/kitty";
    "starship.toml".source = "${dotfiles}/starship/.config/starship.toml";
    tmux = {
      recursive = true;
      source = "${dotfiles}/tmux/.config/tmux";
    };
    dunst.source = "${dotfiles}/dunst/.config/dunst";
    # "go-dwm-statusbar".source = mkIf nixosConfig.desktop.dwm.enable "${dotfiles}/go-dwm-statusbar/.config/go-dwm-statusbar";
  };

  home.shellAliases = {
    store = "nix-store -q --references /run/current-system/sw | fzf";
  };

  programs.git = {
    enable = true;
    userName = "Anthony Tarbinian";
    userEmail = "atar137h@gmail.com";
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
    matchBlocks."datahub-gpu" = {
      user = "atarbini";
      proxyCommand = "ssh -i ~/.ssh/datahub_rsa atarbini@dsmlp-login.ucsd.edu /opt/launch-sh/bin/launch-scipy-ml.sh -P Always -g 1 -i tritonuas/cv-docker:master -H -N datahub-vscode";
    };
    matchBlocks."jetson" = {
      hostname = "192.168.1.51";
      user = "jetson2";
    };
  };
}
