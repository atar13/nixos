# hosts/hopst-pi/

Configuration for Raspberry Pi 4 home server. The top-level configuration files are for system-wide configuration while user-specific configuration is in [hosts/hopst-pi/home](home/README.md).

The server is headless and therefore doesn't depend on any of the shared NixOS modules that deal with graphical applications.

## ddns.nix
Dynamic DNS with the namcheap DNS provider

## default.nix
Entrypoint for system-wide configuration

## hardware-configuration.nix
Raspberry Pi specific hardware configuration

## nginx.nix
Configuration for NGINX as a reverse proxy for services running on the home server

## wireguard.nix
Wireguard VPN server 