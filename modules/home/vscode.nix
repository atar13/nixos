{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    # package = pkgs.vscodium;
    keybindings = [
      {
        key = "ctrl+p";
        # https://code.visualstudio.com/docs/getstarted/keybindings
        command = "workbench.action.quickOpen";
        # https://code.visualstudio.com/api/references/when-clause-contexts
        # when = "";
      }
    ];
    userSettings = {
      # "workbench.colorTheme" = "Firefox Dark";
      "files.autoSave" = "afterDelay";
      "[nix]"."editor.tabSize" = 2;
      "[html]" = {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "platformio-ide.useBuiltinPIOCore" = false;
      "editor.accessibilitySupport" = "off";
      "editor.wordWrap" = "on";
      # "java.home" = "/run/current-system/sw/lib/openjdk";
    };
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-vsliveshare.vsliveshare

      jnoortheen.nix-ide
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers
      ms-vscode.cpptools
      ms-toolsai.jupyter
      mechatroner.rainbow-csv

      marp-team.marp-vscode
      ritwickdey.liveserver
      esbenp.prettier-vscode
      rust-lang.rust-analyzer

      # vscjava.vscode-java-pack
      # vscjava.vscode-java-debug
      # redhat.java
      #
      piousdeer.adwaita-theme
      viktorqvarfordt.vscode-pitch-black-theme
      arrterian.nix-env-selector
      james-yu.latex-workshop
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # {
      #   name = "firefox-devtools-theme";
      #   publisher = "Heron";
      #   version = "4.10.1";
      #   sha256 = "9+Dw1FQSL1r4Te2N3Jm4wrj2rQ7LHE+6m2E4X+K+S5M=";
      # }
      {
        name = "pytrail";
        publisher = "Samir-Rashid";
        version = "0.0.3";
        sha256 = "WO+OzUNSmDcAB5U9tmKIXPijTEekRkl1D0Hw68hmN6g=";
      }
      {
        name = "platformio-ide";
        publisher = "PlatformIO";
        version = "3.3.3";
        sha256 = "d8kwQVoG/MOujmvMaX6Y0wl85L2PNdv2EnqTZKo8pGk=";
      }
      {
        name = "vscode-sshfs";
        publisher = "Kelvin";
        version = "1.26.1";
        sha256 = "WO9vYELNvwmuNeI05sUBE969KAiKYtrJ1fRfdZx3OYU=";
      }
    ];
  };

  #   environment.systemPackages = with pkgs; [
  #     (vscode-with-extensions.override {
  #       vscodeExtensions = with vscode-extensions; [
  #         #bbenoist.nix
  #         ms-python.python
  #         ms-azuretools.vscode-docker
  #         ms-vscode-remote.remote-ssh
  #         ms-vscode.cpptools
  #         vscodevim.vim
  #         piousdeer.adwaita-theme
  #         viktorqvarfordt.vscode-pitch-black-theme
  #       ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  #         {
  #           name = "remote-containers";
  #           publisher = "ms-vscode-remote";
  #           version = "0.345.0";
  #           sha256 = "ZWFebZ6YbT0bf7M0KDtrwrrv2NJc7NUH09GTBVuzy2I=";
  #         }
  #         {
  #           name = "marp-vscode";
  #           publisher = "marp-team";
  #           version = "2.8.0";
  #           sha256 = "x/nR0wSOf7RXg1Sliap+qQIagcn1YD3W5OAZAcCP9ec=";
  #         }
  #         {
  #           name = "pytrail";
  #           publisher = "Samir-Rashid";
  #           version = "0.0.3";
  #           sha256 = "WO+OzUNSmDcAB5U9tmKIXPijTEekRkl1D0Hw68hmN6g=";
  #         }
  #         {
  #           name = "vsliveshare";
  #           publisher = "MS-vsliveshare";
  #           version = "1.0.5905";
  #           sha256 = "y1MMO6fd/4a9PhdBpereEBPRk50CDgdiRc8Vwqn0PXY=";
  #         }
  #         {
  #           name = "nix-env-selector";
  #           publisher = "arrterian";
  #           version = "1.0.9";
  #           sha256 = "TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
  #         }
  #         {
  #           name = "nix-ide";
  #           publisher = "jnoortheen";
  #           version = "0.2.2";
  #           sha256 = "jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=";
  #         }
  #         {
  #           name = "Heron.firefox-devtools-theme";
  #           version = "4.10.1";
  #           publisher = "HeronSilva";
  #         }
  #       ];
  #     })
  #   ];
}
