{
  description = "libtock-c";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        # let pkgs = nixpkgs.legacyPackages.${system}; in
        let
          # pkgs = nixpkgs.legacyPackages.${system};
          pkgs = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
            config.permittedInsecurePackages = [
              "segger-jlink-qt4-794l"
            ];
          };
        in
        {
          devShells.default = import ./shell.nix { inherit pkgs; };
          formatter = pkgs.nixpkgs-fmt;
        }
      );
}

