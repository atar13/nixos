{
  description = "personal NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github.com/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
    let 
      user = "atarbinian";
      dots = "$HOME/Pkgs/dotfiles";
    in
  {
    nixosConfigurations = {
      import = ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager user dots;
      };
    };
    
    # homeConfigurations = {
    #   import ./nix {
    #     inherit (nixpkgs) lib;
    #     inherit inputs nixpkgs home-manager user;
    #   }
    # }

  };
}
