# nixos

This repo contains my configuration files for NixOS for my three machines:
- [Framework 16 Laptop](./hosts/framework-16/)
- [HP Envy x360 Laptop](./hosts/envy/)
- [Raspberry Pi Home Server](./hosts/hopst-pi/)

The confiuration is setup as a flake in `flake.nix`. Platform specific configurations exist in the `hosts` folder. I'm using home-manager to configure some user specific settings.

## Installation

See the Justfile for how to build the system using `just`.

To switch now:
```sh
just rebuild <hostname> switch
```

To switch on next boot:
```sh
just rebuild <hostname> boot 
```

To launch a system in a QEMU VM:
```sh
just vm <hostname>
```

To update flake inputs:
```sh
just update-all
```

For help:
```sh
just --help
```
