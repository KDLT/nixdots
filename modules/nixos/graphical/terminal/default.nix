{
  config,
  lib,
  ...
}:
let
  nerdfont = config.kdlt.nerdfont;
in
{
  options = {
    kdlt = {
      graphical.terminal.enable = lib.mkEnableOption "terminal";
    };
  };

  config = lib.mkIf config.kdlt.graphical.terminal.enable {
    home-manager.users.${config.kdlt.username} = {
      programs.kitty = {
        enable = true;
        settings = {
          font_family = "CommitMono Nerd Font Mono";

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
