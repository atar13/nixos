{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  name = "cse167";
  buildInputs = with pkgs; [
    gnumake
    gcc
    freeimage
    clang-tools
    gdb
  ];
}
