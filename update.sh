#!/bin/sh
#
# options:
#  when: (now, later, test)

WHEN=$1

if [ "$WHEN" = "later" ]; then
	sudo nixos-rebuild boot --flake .#envy --impure
elif [ "$WHEN" = "now" ]; then
	sudo nixos-rebuild switch --flake .#envy --impure
elif [ "$WHEN" = "test" ]; then
	sudo nixos-rebuild dry-build --flake .#envy --impure
else
	sudo nixos-rebuild boot --flake .#envy --impure
fi;
