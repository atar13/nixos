{
  description = "personal NixOS configuration";

  inputs = {
    dotfiles = {
      url = "github:atar13/dotfiles";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      username = "atarbinian";
      hostname = "envy-nixos";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Allow proprietary software
      };
    in
    {
      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          modules = [
            inputs.agenix.nixosModules.default
            (import ./hosts/envy { inherit pkgs; })
            (import ./config {
              inherit (inputs) agenix;
              inherit inputs pkgs system username hostname;
            })
            home-manager.nixosModules.home-manager {
              home-manager.users = {
                ${username} = {...}: 
                  {
                    imports = [./home ];
                  };
              };
              home-manager.extraSpecialArgs = {
                inherit (inputs) dotfiles;
                inherit (inputs) spicetify-nix;
                inherit username;
              };
            }
          ];
        };
      };
    };
}
