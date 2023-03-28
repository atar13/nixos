# nixos

This repo contains my configuration files for NixOS.


The confiuration is setup as a flake in `flake.nix`. Platform specific configurations (will) exist in the `hosts` folder. I'm using home-manager to configure some user specific settings.


Everything here is still a work in progress that can use quite a bit of organization. 

## Installation

`update.sh` is a convenience script to rebuild and switch to the new confiuration at different times. 

To switch now:
```shell
./update.sh now
```

To switch on next boot:
```shell
./update.sh later 
```
