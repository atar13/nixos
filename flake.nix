{
  description = "personal NixOS configuration";

  inputs = {
    dotfiles = {
      url = "github:atar13/dotfiles";
      # url = "file+file:///home/atarbinian/dotfiles";
      flake = false;
    };

    dwm.url = "github:atar13/dwm";
    dmenu.url = "github:atar13/dmenu";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-23.05";
    my-nixpkgs.url = "github:atar13/nixpkgs/nfrconnect-5.0.2";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-xilinx = {
      # Recommended if you also override the default nixpkgs flake, common among
      # nixos-unstable users:
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-xilinx";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = inputs @ { nixpkgs, nixpkgs-old, my-nixpkgs, home-manager, nixos-hardware, nix-xilinx, ghostty, ... }:
    let
      defaultUser = "atarbinian";

      machines = [
        { name = "framework-16"; system = "x86_64-linux"; users = [ defaultUser ]; }
        { name = "envy"; system = "x86_64-linux"; users = [ defaultUser ]; }
        { name = "hopst-pi"; system = "aarch64-linux"; users = [ defaultUser ]; }
        { name = "bee-pi"; system = "x86_64-linux"; users = [ defaultUser ]; }
      ];

      mkNixosConfig = machine:
        let
          pkgs = import nixpkgs {
            system = machine.system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
            config.permittedInsecurePackages = [
              "googleearth-pro-7.3.4.8248"
              "segger-jlink-qt4-796s"
              "segger-jlink-qt4-810"
              "segger-jlink-qt4-874"
              "electron-33.4.11"
              "qtwebengine-5.15.19"
              "electron-36.9.5"
            ];
          };
          old-pkgs = import nixpkgs-old {
            system = machine.system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
            config.permittedInsecurePackages = [
              "electron-12.2.3"
            ];
          };
          my-pkgs = import my-nixpkgs {
            system = machine.system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
            config.permittedInsecurePackages = [
              "segger-jlink-qt4-796s"
              "segger-jlink-qt4-810"
            ];
          };
          config = config;

        in
        nixpkgs.lib.nixosSystem {
          modules = [
            inputs.agenix.nixosModules.default
            ({ config, lib, ... }:
              (import ./hosts/${machine.name} { inherit lib config inputs pkgs old-pkgs my-pkgs nixos-hardware; hostname = machine.name; })
            )
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users = builtins.listToAttrs (builtins.map
                  (username: {
                    name = username;
                    value = ({ config, lib, osConfig, ... }:
                      import ./hosts/${machine.name}/home/${username} { inherit inputs config lib pkgs username osConfig; });
                  })
                  machine.users);
                extraSpecialArgs = { nixosConfig = config; };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = builtins.listToAttrs (builtins.map (machine: { name = machine.name; value = (mkNixosConfig machine); }) machines);
    };
}
