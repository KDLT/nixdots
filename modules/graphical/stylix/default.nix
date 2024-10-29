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
      # this cannot be an absolute path, evaluation becomes impure
      image = /. + wallpaper; # succesfully coerced this to path
      # fonts.packages = [ pkgs.nerdfonts ];

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
          terminal = 16;
          applications = 16;
          popups = 18;
          desktop = 16;
        };
      };
    };

    # this conflicts with home-manager's nixosModule
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
