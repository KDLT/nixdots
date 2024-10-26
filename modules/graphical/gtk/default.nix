{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {};

  config = lib.mkIf config.kdlt.graphical.enable {
    home-manager.users.${config.kdlt.username} = {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      xresources.properties = {
        "Xft.dpi" = 150; # dpi for xorg font
        "*.dpi" = 150; # generic dpi
      };

      gtk = {
        enable = true;
        gtk2.extraConfig = "gtk-application-prefer-dark-theme = true;";
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

        # this also controls all the non configurable font size in firefox
        font = {
          name = "Commit Mono Nerd Font";
          # size = 16;
          size = 14;
        };

        theme = {
          name = "catppuccin-macchiato-pink-compact";
          package = pkgs.catppuccin-gtk.override {
            accents = ["pink"];
            # accents = ["peach"];
            size = "compact";
            variant = "macchiato";
          };
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };
    };
  };
}
