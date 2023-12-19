{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  name = "c";
  buildInputs = with pkgs; [
    gnumake
    gcc
    clang-tools
    gdb
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    imlib2
    light
  ];
}
