{
  config,
  lib,
  ...
}:
# nerdFontName = name: builtins.replaceStrings ["-"] [""] name + " Nerd Font";
# nerdFontPkg = nerdFontName: (pkgs.nerdfonts.override { fonts = [ nerdFontName ]; });
{
  options = {
    kdlt = {
      graphical.terminal.enable = lib.mkEnableOption "terminal";
    };
  };

  config = lib.mkIf config.kdlt.graphical.terminal.enable {
    home-manager.users.${config.kdlt.username} = {...}: {
      programs.kitty = {
        enable = true;

        font = lib.mkIf config.kdlt.nerdfont.enable {
          # name = config.kdlt.nerdfont.monospace.fontName + " Nerd Font";
          # name = "BlexMono Nerd Font";
          name = builtins.replaceStrings ["-"] [""] config.kdlt.nerdfont.monospace.fontName + " Nerd Font";
          size = 16;
        };

        settings = {
          background_opacity = lib.mkForce "0.89";
          window_padding_width = "12";
          enabled_layouts = "fat:bias=80, tall, splits";
          inactive_border_color = "#0f0d0d";
          active_border_color = "#ffebeb";
          # tab settings
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
        };
      };
    };
  };
}
