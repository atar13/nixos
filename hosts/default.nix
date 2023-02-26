{lib, inputs, nixpkgs, home-manager, user, location, ...}:

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
	laptopHostName = lib.nixosSystem {
		inherit system;
		specialArgs = {
			inherit inputs user location;
			host = {
				hostName = laptopHostName;
				mainMonitor = "eDP";
			};
		};
		modules = [
			./configuration.nix
			./envy
		];
	};
}

