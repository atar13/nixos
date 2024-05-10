{ inputs, config, lib, pkgs, username, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit username; })
    (import ../../../../modules/home/gui.nix { inherit username; })
    (import ../../../../modules/home/neovim.nix { inherit (inputs) dotfiles; inherit pkgs config lib; })
    ../../../../modules/home/theme.nix
    ../../../../modules/home/vscode.nix
    ../../../../modules/home/gnome.nix
    (import ../../../../modules/home/spicetify.nix { inherit pkgs; inherit (inputs) spicetify-nix; })
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Auto mount devices
  services.udiskie.enable = true;


  home.stateVersion = "23.11";
}
