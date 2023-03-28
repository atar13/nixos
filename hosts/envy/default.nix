# HP-Envy Laptop specific configuration
{ config, pkgs, user, ...}:

{
	imports = [./hardware-configuration.nix];
	
	boot = {                                  # Boot options
	    tmpOnTmpfs = true;
	    kernelPackages = pkgs.linuxPackages_latest; # latest kernel. Needed for wifi adapter

	    loader = {                              # EFI Boot
	      efi = {
					canTouchEfiVariables = true;
					efiSysMountPoint = "/boot/efi";
	      };
	      systemd-boot = {                              
					enable = true;
					configurationLimit = 5; 	    			# Display the 5 latest generations
	      };
	    };
	  };

	  environment = {
	    systemPackages = with pkgs; [
	      simple-scan
	      acpi
	    ];
	  };

	  programs = {                              # No xbacklight, this is the alterantive
	    dconf.enable = true;
	    light.enable = true;
	  };

	  services = {
	    tlp.enable = true;                      # TLP and auto-cpufreq for power management
	    auto-cpufreq.enable = true;
	    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
	    blueman.enable = true;
	    printing = {                            # Printing 
	      enable = true;
	    };
	    avahi = {                               # Needed to find wireless printer
	      enable = true;
	      nssmdns = true;
	      publish = {                           # Needed for detecting the scanner
		enable = true;
		addresses = true;
		userServices = true;
	      };
	    };
	 #    samba = {
	 #      enable = true;
	 #      shares = {
		# share = {
		#   "path" = "/home/${user}";
		#   "guest ok" = "no";
		#   "read only" = "no";
		# };
	 #      };
	 #      openFirewall = true;
	 #    };
	  };

	  #temporary bluetooth fix
	  systemd.tmpfiles.rules = [
	    "d /var/lib/bluetooth 700 root root - -"
	  ];
	  systemd.targets."bluetooth".after = ["systemd-tmpfiles-setup.service"];
	  hardware.bluetooth = {
		  enable = true;
		  settings = {
			  General = {
			    AutoEnable = true;
			    DiscoverableTimeout = 0;
			  };
		};
	  };
}
