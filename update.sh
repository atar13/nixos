#!/bin/sh
#
# options for future:
#  hostname
#  when: (now, later, test)

sudo nixos-rebuild boot --flake .#envy-nixos --impure
