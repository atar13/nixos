{ lib, pkgs, config, inputs, ... }:
with lib;
{
  options.gui.desktop = mkOption {
    type = with types; uniq str;
    default = "gnome";
    example = "gnome";
    description = "
            Desktop environment (either dwm or gnome)
        ";
  };

  # config = if config.desktop == "dwm" then {
  #     import ./dwm.nix { inherit inputs pkgs; }
  # } else {
  #     import ./gnome.nix { inherit pkgs; }
  # };
}
