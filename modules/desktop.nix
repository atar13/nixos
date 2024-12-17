{ lib, pkgs, config, inputs, ... }:
let
  envs = {
    "gnome" = {
      gnome.enable = true;
      hyprland.enable = false;
      dwm.enable = false;
    };
    "hyprland" = {
      gnome.enable = false;
      hyprland.enable = true;
      dwm.enable = false;
    };
    "dwm" = {
      gnome.enable = false;
      hyprland.enable = false;
      dwm.enable = true;
    };
  };
  lookup = attrs: key: default:
    if attrs ? key then (attrs."${key}") else (attrs."${default}");
  cfg = config.gui;
  tmp = "dwm";
in
{
  imports = [
    (import ./dwm.nix { inherit lib pkgs config inputs; })
    ./hyprland.nix
    ./gnome.nix
  ];
  options.gui.desktop = lib.mkOption {
    type = with lib.types; uniq str;
    default = "gnome";
    example = "gnome";
    description = "
            Desktop environment (either dwm, hyprland, or gnome)
        ";
  };

  config.desktop = envs."${cfg.desktop}";

  # config = lookup envs "dwm" "asdf";
  # config = envs."${cfg.desktop}";
  # config = {
  #     desktop.hyprland.enable = true;
  #     # dwm.enable = false;
  #     # gnome.enable = false;
  # };
  # config = if config.desktop == "dwm" then {
  #     config.dwm.enable = true;
  # } else if config.deskop == "hyprland" {
  #     config.hyprland.enable = true;
  # } else {
  #     config.gnome.enable = true;
  # };
}
