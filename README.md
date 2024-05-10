# nixos

This repo contains my configuration files for NixOS for my three machines:
- [Framework 16 Laptop](./hosts/framework-16/)
- [HP Envy x360 Laptop](./hosts/envy/)
- [Raspberry Pi Home Server](./hosts/hopst-pi/)

The confiuration is setup as a flake in `flake.nix`. Platform specific configurations exist in the `hosts` folder. I'm using home-manager to configure some user specific settings.

## Installation

`update.sh` is a convenience script to rebuild and switch to the new confiuration at different times. 

To switch now:
```shell
./update.sh <hostname> now
```

To switch on next boot:
```shell
./update.sh <hostname> later 
```
