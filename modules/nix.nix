{ inputs, pkgs, ... }: {
  system.stateVersion = "unstable";

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [
      "flakes"
      "nix-command"
      "auto-allocate-uids"
      "configurable-impure-env"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
