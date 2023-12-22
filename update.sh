#!/bin/sh
#
# options:
#  host: system hostname
#  when: (now, later, test)
#
# example usage:
# ./update.sh envy now

HOST=$1
WHEN=$2

if [ "$WHEN" = "later" ]; then
	sudo nixos-rebuild boot --flake .#"${HOST}" --impure
elif [ "$WHEN" = "now" ]; then
	sudo nixos-rebuild switch --flake .#"${HOST}" --impure
elif [ "$WHEN" = "test" ]; then
	sudo nixos-rebuild dry-build --flake .#"${HOST}" --impure
else
	sudo nixos-rebuild boot --flake .#"${HOST}" --impure
fi;
