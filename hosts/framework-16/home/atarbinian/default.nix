{ inputs, config, lib, pkgs, username, osConfig, ... }:
{
  imports = [
    (import ../../../../modules/home/cli.nix { inherit (inputs) dotfiles; inherit username; })
    (import ../../../../modules/home/gui.nix { inherit username; })
    (import ../../../../modules/home/neovim.nix { inherit (inputs) dotfiles; inherit pkgs config lib; })
    ../../../../modules/home/theme.nix
    ../../../../modules/home/vscode.nix
    (import ../../../../modules/home/gnome.nix { inherit lib pkgs osConfig; })
    (import ../../../../modules/home/dwm.nix { inherit lib pkgs osConfig; inherit (inputs) dotfiles; })
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
