{
  pkgs,
  lib,
  config,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
in
with lib;
{
  options = { };

  config = mkIf config.kdlt.graphical.enable {
    home-manager.users.${config.kdlt.username} = {
      # cursor declarations conflicts with stylix
      home.pointerCursor = mkIf (!stylix.enable) {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      xresources.properties = {
        "Xft.dpi" = 150; # dpi for xorg font
        "*.dpi" = 150; # generic dpi
      };

      gtk = {
        enable = true;
        gtk2.extraConfig = "gtk-application-prefer-dark-theme = true;";
        gtk3.extraConfig.gtk-application-prefer-dark-theme = true;

        # stylix time again
        # font = {
        #   name = "Commit Mono Nerd Font";
        #   size = 14;
        # };

        # stylix got the theme now
        # theme = {
        #   name = "catppuccin-macchiato-pink-compact";
        #   package = pkgs.catppuccin-gtk.override {
        #     accents = [ "pink" ];
        #     # accents = ["peach"];
        #     size = "compact";
        #     variant = "macchiato";
        #   };
        # };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };
    };
  };
}
