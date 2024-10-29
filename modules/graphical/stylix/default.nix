# ~/dotfiles/modules/graphical/stylix/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
  monospace = "CommitMono";
  serif = "Go-Mono";
  sansSerif = "JetBrainsMono";
  fonts = name: rec {
    cleanName = builtins.replaceStrings [ "-" ] [ "" ] name;
    fontName = cleanName + " Nerd Font Mono";
    fontPkg = pkgs.nerdfonts.override { fonts = [ name ]; };
  };
in
with lib;
{
  options = {
    kdlt = {
      graphical.stylix.enable = mkEnableOption "Use Stylix";
    };
  };

  config = mkIf stylix.enable {
    stylix = {
      enable = true; # infinite recursion likely solved by programs.dconf.enable = true;
      autoEnable = true;
      polarity = "dark";
      # image = /home/kba/Pictures/aesthetic-wallpapers/images/manga.png;
      image = /home/kba/nixdots/assets/wallpaper.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
      fonts = {
        monospace.name = (fonts monospace).fontName;
        monospace.package = (fonts monospace).fontPkg;
        sansSerif.name = (fonts sansSerif).fontName;
        sansSerif.package = (fonts sansSerif).fontPkg;
        serif.name = (fonts serif).fontName;
        serif.package = (fonts serif).fontPkg;
        emoji = {
          name = "Noto Emoji";
          package = pkgs.noto-fonts-monochrome-emoji;
        };
        sizes = {
          terminal = 18;
          applications = 14;
          popups = 12;
          desktop = 14;
        };
      };
    };
  };
}
