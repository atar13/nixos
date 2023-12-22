{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # TODO: these should probably be in a shell
    imlib2
    glib
    glibc

    luajit
    gcc
    stdenv.cc.cc.lib

    texlive.combined.scheme-basic
  ];
}
