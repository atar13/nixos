{ lib, inputs, config, pkgs, username, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit pkgs; })
    (import ../../../../modules/home/neovim.nix { inherit (inputs) dotfiles; inherit pkgs config lib; })
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Auto mount devices
  services.udiskie.enable = true;

  home.stateVersion = "23.11";
}
