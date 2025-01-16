{
  description = "A very basic Zephyr flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Customize the version of Zephyr used by the flake here
    zephyr.url = "github:zephyrproject-rtos/zephyr/v3.5.0";
    zephyr.flake = false;

    zephyr-nix.url = "github:adisbladis/zephyr-nix";
    zephyr-nix.inputs.nixpkgs.follows = "nixpkgs";
    zephyr-nix.inputs.zephyr.follows = "zephyr";
  };

  outputs = { self, nixpkgs, zephyr-nix, ... }: let
    # pkgs = nixpkgs.legacyPackages.x86_64-linux;
    pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
            allowUnfree = true;
            segger-jlink.acceptLicense = true;
            permittedInsecurePackages = [
                "segger-jlink-qt4-796s"
            ];
        };
    };
    zephyr = zephyr-nix.packages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      # Use the same mkShell as documented above
        packages = [
            (zephyr.sdk.override {
              targets = [
                "arm-zephyr-eabi"
              ];
            })
            zephyr.pythonEnv
            # Use zephyr.hosttools-nix to use nixpkgs built tooling instead of official Zephyr binaries
            zephyr.hosttools
            pkgs.cmake
            pkgs.ninja
            pkgs.picocom
            pkgs.nrf-command-line-tools
            pkgs.clang-tools
      ];
    };
  };
}
