{ pkgs, spicetify-nix, ... }:
let
  spicetify-pkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = {
    spotifyPackage = pkgs.spotify;
    enable = true;
    theme = spicetify-pkgs.themes.defaultDynamic;
    # theme = spicetify-pkgs.themes.dribbblish;
    # colorScheme = "purple";

    enabledExtensions = with spicetify-pkgs.extensions; [
      # fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      # hidePodcasts
      # autoSkipVideo
      # loopyLoop
      # keyboardShortcut # https://spicetify.app/docs/advanced-usage/extensions/#keyboard-shortcut
      # popupLyrics
      # powerBar
      # seekSong
      # playlistIcons
      # fullAlbumDate
      # playlistIntersection
      # skipStats
      # wikify
      # songStats
      # history
      adblock
    ];
  };
}
