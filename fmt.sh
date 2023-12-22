#!/bin/sh

FILES=`find . -name '*.nix' -print`
nixpkgs-fmt ${FILES} 