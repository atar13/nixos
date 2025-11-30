{ inputs, pkgs, ... }: {
  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.segger-jlink.acceptLicense = true;

  nix = {
    settings.experimental-features = [
      "flakes"
      "nix-command"
      "auto-allocate-uids"
      "configurable-impure-env"
    ];
    # settings.substituters = [
    #     "http://10.0.3.16:8081"
    # ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.latest;
    channel.enable = false;
    settings = {
        nix-path = [ "/etc/nix/path" ]; # This will fix the missing NIX_PATH
        # build-dir = "/var/tmp";
    };
    registry.nixpkgs.flake = inputs.nixpkgs;
    nixPath = [ "nixpkgs=/etc/nix/path/nixpkgs" "nixpkgs-old=/etc/nix/path/nixpkgs-old" ];
    # https://github.com/NobbZ/nixos-config/blob/main/nixos/modules/flake.nix
    # https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/2
    # https://discourse.nixos.org/t/problems-after-switching-to-flake-system/24093/8
  };
  systemd.tmpfiles.rules = [
    "L+ /etc/nix/path/nixpkgs     - - - - ${inputs.nixpkgs}"
    "L+ /etc/nix/path/nixpkgs-old      - - - - ${inputs.nixpkgs-old}"
  ];

}
