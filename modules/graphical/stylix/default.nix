# ~/dotfiles/modules/graphical/stylix/default.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  monospace = "CommitMono";
  serif = "Go-Mono";
  sansSerif = "JetBrainsMono";
  fonts = name: rec {
    cleanName = builtins.replaceStrings ["-"] [""] name;
    fontName = cleanName + " Nerd Font Mono";
    fontPkg = pkgs.nerdfonts.override {fonts = [name];};
  };
in {
  # options = {
  #   kdlt = {
  #     graphical.stylix.enable = lib.mkEnableOption "Use Stylix";
  #   };
  # };

  # config = { # this requires importing the stylix.homeManagerModules.stylix
  #   home-manager.users.${config.kdlt.username} = {
  #     stylix.enable = true;
  #   };
  # };

  # config = {
  #   stylix.enable = lib.mkDefault true;
  # };

  # config = lib.mkIf config.kdlt.graphical.stylix.enable {
  #   stylix.enable = true;
  #   stylix.image = /home/kba/Pictures/aesthetic-wallpapers/images/manga.png;
  #
  #   home-manager.users.${config.kdlt.username} = {...}: {
  #   home-manager.users.${config.kdlt.username} = {
  #     stylix.enable = true;
  #     stylix.image = /home/kba/Pictures/aesthetic-wallpapers/images/manga.png;
  #   };
  # };

  # config = lib.mkIf config.kdlt.graphical.stylix {
  #   stylix = {
  #     enable = true; # TODO: enabling this just causes infinite recursion
  #     autoEnable = true;
  #     polarity = "dark";
  #     image = /home/kba/Pictures/aesthetic-wallpapers/images/manga.png;
  #     base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
  #     fonts = {
  #       monospace.name = (fonts monospace).fontName;
  #       monospace.package = (fonts monospace).fontPkg;
  #       sansSerif.name = (fonts sansSerif).fontName;
  #       sansSerif.package = (fonts sansSerif).fontPkg;
  #       serif.name = (fonts serif).fontName;
  #       serif.package = (fonts serif).fontPkg;
  #       emoji = {
  #         name = "Noto Emoji";
  #         package = pkgs.noto-fonts-monochrome-emoji;
  #       };
  #       sizes = {
  #         terminal = 18;
  #         applications = 14;
  #         popups = 12;
  #         desktop = 14;
  #       };
  #     };
  #   };
  # };
}
