{ inputs, config, lib, pkgs, username, osConfig, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit pkgs; })
    (import ../../../../modules/home/gui.nix { inherit username; })
    (import ../../../../modules/home/neovim.nix { inherit lib pkgs; inherit (inputs) dotfiles; })
    ../../../../modules/home/theme.nix
    ../../../../modules/home/vscode.nix
    (import ../../../../modules/home/gnome.nix { inherit lib pkgs osConfig; })
    (import ../../../../modules/home/dwm.nix { inherit lib pkgs config osConfig; inherit (inputs) dotfiles; })
    (import ../../../../modules/home/hyprland.nix { inherit lib pkgs osConfig; })
    ../../../../modules/home/firefox.nix
    (import ../../../../modules/home/spicetify.nix { inherit pkgs; inherit (inputs) spicetify-nix; })
  ];

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  # Auto mount devices
  services.udiskie.enable = true;

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.stateVersion = "25.05";
}
