{
  description = "personal NixOS configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

    spicetify-nix.url = github:the-argus/spicetify-nix;

  };

  outputs = inputs @ { self, nixpkgs, home-manager, spicetify-nix, ... }: 
    let 
      system = "x86_64-linux";
      hostname = "envy-nixos";
      dots = "$HOME/Pkgs/dotfiles";
      user = "atarbinian";

      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;                              # Allow proprietary software
	#config.allowBroken = true;
      };
    in
  { 
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
      	inherit system; 
	modules = [
		./hosts/envy
		(import ./config/configuration.nix {
			inherit lib inputs nixpkgs pkgs system user;
		})
		home-manager.nixosModules.home-manager {
			home-manager.useGlobalPkgs = true;
			home-manager.useUserPackages = true;
			home-manager.users.${user} = import ./config/home.nix {inherit pkgs lib user spicetify-nix;};
	  	}
	];
      };

    };
  };

}
