{lib, inputs, nixpkgs, home-manager, user, dots, ...}:

let
        system = "x86_64-linux";
        laptopHostName = "envy-nixos";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};

	lib = nixpkgs.lib;
in
{
	"envy-nixos" = lib.nixosSystem {
		inherit system;
		specialArgs = {
			inherit lib nixpkgs home-manager user;
			host = {
				hostName = laptopHostName;
				mainMonitor = "eDP";
			};
		};
		modules = [
			# ./configuration.nix
			./envy
		];
	};
}

