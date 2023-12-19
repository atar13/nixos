{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = with pkgs; [
    go
    golangci-lint
    gotools
    # goimports
    # gocode
    # gotests
    # richgo
  ];
}
