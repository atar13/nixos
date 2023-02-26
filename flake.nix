{
  description = "personal NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };


  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
    let 
      system = "x86_64-linux";
      hostname = "envy-nixos";
      dots = "$HOME/Pkgs/dotfiles";
      user = "atarbinian";

      lib = nixpkgs.lib;
    in
  { 
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
      	inherit system; 
	modules = [
		# ./hosts
		./hosts/envy
		# ./hosts/configuration.nix
		(import ./hosts/configuration.nix {
			inherit lib nixpkgs system user;
		})
		home-manager.nixosModules.home-manager {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			# home-manager.users.${user} = import ./nixos/home-manager.nix;
	  	}
	];
      };
      specialArgs = {
      	inherit inputs;
	inherit user;
      };
    };
  };

}
