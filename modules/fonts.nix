{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    carlito
    vegur
    source-code-pro
    jetbrains-mono
    fira-code
    fira-code-symbols
    font-awesome # Icons
    corefonts # MS
    nerd-fonts.fira-code
  ];
}
