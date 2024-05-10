
# default recipe to display help information
help:
  @just --list

alias u := update

# update flake inputs (by default update dotfiles repo input)
update INPUT='dotfiles':
    nix flake update {{INPUT}}

update-all:
    nix flake update

# rebuild nixos system
#     HOST is a hostname from flake.nix
#     WHEN can be either "switch", "boot", "dry-build", etc
rebuild HOST WHEN:
	sudo nixos-rebuild {{WHEN}} --flake .#{{HOST}} --impure

# https://nixos.wiki/wiki/NixOS:nixos-rebuild_build-vm
# create a QEMU virtual machine with a specified host's config
vm HOST:
	sudo nixos-rebuild build-vm --flake .#{{HOST}} --impure

NIX_FILES := `find . -name '*.nix' -printf '%p '`
# format nix files
fmt:
    nixpkgs-fmt {{NIX_FILES}}

