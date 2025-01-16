{ pkgs, zephyr }:

pkgs.mkShell {
  packages = with pkgs; [
    (zephyr.sdk.override {
      targets = [
        "arm-zephyr-eabi"
      ];
    })
    zephyr.pythonEnv
    # Use zephyr.hosttools-nix to use nixpkgs built tooling instead of official Zephyr binaries
    zephyr.hosttools
    cmake
    ninja
  ];

}
