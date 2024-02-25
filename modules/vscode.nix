{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        #bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-vscode.cpptools
        vscodevim.vim
        piousdeer.adwaita-theme
        viktorqvarfordt.vscode-pitch-black-theme
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #      {
        # name = "remote-ssh";
        # publisher = "ms-vscode-remote";
        # version = "0.101.2023032415";
        # sha256 = "c+sCR+Zly5KiyQdQhGG0w+e+PHWICJfKaOPFbsdL7y8=";
        #      }
        {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.345.0";
          sha256 = "ZWFebZ6YbT0bf7M0KDtrwrrv2NJc7NUH09GTBVuzy2I=";
        }
        {
          name = "marp-vscode";
          publisher = "marp-team";
          version = "2.8.0";
          sha256 = "x/nR0wSOf7RXg1Sliap+qQIagcn1YD3W5OAZAcCP9ec=";
        }
        {
          name = "pytrail";
          publisher = "Samir-Rashid";
          version = "0.0.3";
          sha256 = "WO+OzUNSmDcAB5U9tmKIXPijTEekRkl1D0Hw68hmN6g=";
        }
        {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.9";
          sha256 = "TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.2";
          sha256 = "jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=";
        }
        #      {
        #      	name = "Heron.firefox-devtools-theme";
        # version = "4.10.1";
        # publisher = "HeronSilva";
        #      }
      ];
    })
  ];
}
