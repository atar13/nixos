{ lib, pkgs, inputs, ... }:
{
    options.deskop = mkOption {
        type = with types; uniq str;
        default = "gnome";
        example = "gnome";
        description = "
            Desktop environment (either dwm or gnome)
        ";
    };

    config = if config.desktop == "dwm" then (
        (import ../../modules/dwm.nix { inherit inputs pkgs; })
    ) else (
        (import ../../modules/gnome.nix { inherit pkgs; })
    );
}
