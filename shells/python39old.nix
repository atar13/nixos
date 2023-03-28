{pkgs ? import <nixpkgs> {}}:
with pkgs;
mkShell {
  name = "python 3.9";
  buildInputs = with pkgs; [
	python39
	pipenv
	stdenv

	zlib
	glib
	glibmm
	glibc

	libglibutil
	libkrb5

	python39Packages.python-lsp-server
	which
	gcc
	binutils
	# ncurses
	# # glib
	# # glibc
	stdenv.cc.cc.lib
	# libGL
	# libGLU
	#python39Packages.numpy
	# which
	#  gcc
	#  binutils

	# All the C libraries that a manylinux_1 wheel might depend on:
	# ncurses
	# xorg.libX11
	# xorg.libXext
	# xorg.libXrender
	# xorg.libICE
	# xorg.libSM

  ];
shellHook = ''
    LD_LIBRARY_PATH=${pkgs.zlib}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glibc}/lib:${pkgs.glib}/lib:${pkgs.cudaPackages_10_1.cudatoolkit}/lib:${pkgs.cudaPackages_10_1.cudatoolkit.lib}/lib:/run/opengl-driver/lib:/run/opengl-driver-32/lib:$LD_LIBRARY_PATH
    # set SOURCE_DATE_EPOCH so that we can use python wheels
    SOURCE_DATE_EPOCH=$(date +%s)
    PATH=$HOME/.local/bin:$PATH
    PYTHONPATH=$HOME/.local/lib/python3.9/site-packages:$PYTHONPATH
    export PIP_PREFIX=$(pwd)/_build/pip_packages
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"
    unset SOURCE_DATE_EPOCH
  '';
}
