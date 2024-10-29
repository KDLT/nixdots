# ~/dotfiles/modules/graphical/stylix/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
  wallpaper = config.kdlt.graphical.wallpaper;
  userName = config.kdlt.username;
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
      image = /. + wallpaper; # not sure  if i can coerce this to a path like so;
      # image = /home/kba/Pictures/aesthetic-wallpapers/images/manga.png;
      # image = /home/kba/nixdots/assets/wallpaper.png;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/vesper.yaml";
      fonts.packages = [ pkgs.nerdfonts ];

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          name = config.kdlt.nerdfont.monospace.name;
          package = pkgs.nerdfonts;
        };
        sansSerif = {
          name = config.kdlt.nerdfont.sansSerif.name;
          package = pkgs.nerdfonts;
        };
        serif = {
          name = config.kdlt.nerdfont.serif.name;
          package = pkgs.nerdfonts;
        };
        emoji = {
          name = config.kdlt.nerdfont.emoji.name;
          package = pkgs.noto-fonts-color-emoji;
        };
        sizes = {
          terminal = 18;
          applications = 14;
          popups = 12;
          desktop = 14;
        };
      };
    };

    # home-manager.users.${userName} = {
    #   stylix = {
    #     enable = true;
    #     autoEnable = true;
    #
    #     opacity = {
    #       applications = 1.0;
    #       desktop = 1.0;
    #       popups = 1.0;
    #       terminal = 1.0;
    #       polarity = "dark";
    #     };
    #   };
    # };
  };
}
