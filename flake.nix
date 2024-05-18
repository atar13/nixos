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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ { nixpkgs, nixpkgs-old, home-manager, nixos-hardware, ... }:
    let
      defaultUser = "atarbinian";

      machines = [
        { name = "framework-16"; system = "x86_64-linux"; users = [ defaultUser ]; }
        { name = "envy"; system = "x86_64-linux"; users = [ defaultUser ]; }
        { name = "hopst-pi"; system = "aarch64-linux"; users = [ defaultUser ]; }
      ];

      mkNixosConfig = machine:
        let
          pkgs = import nixpkgs {
            system = machine.system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
          };
          old-pkgs = import nixpkgs-old {
            system = machine.system;
            config.allowUnfree = true;
            config.segger-jlink.acceptLicense = true;
            config.permittedInsecurePackages = [
                "electron-12.2.3"
            ];
          };
          config = config;
        in
        nixpkgs.lib.nixosSystem {
          modules = [
            inputs.agenix.nixosModules.default
            ({ config, lib, ... }:
              (import ./hosts/${machine.name} { inherit lib config inputs pkgs old-pkgs nixos-hardware; hostname = machine.name; })
            )
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                users = builtins.listToAttrs (builtins.map
                  (username: {
                    name = username;
                    value = ({ config, lib, ... }:
                      import ./hosts/${machine.name}/home/${username} { inherit inputs config lib pkgs username; });
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
