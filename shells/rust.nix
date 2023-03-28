{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = with pkgs; [
  	cargo
	clippy
	rust-analyzer
  ];
}
