{
  config,
  lib,
  ...
}: {
  options = {
    kdlt.graphical.waybar.enable = lib.mkEnableOption "waybar on";
  };

  config = lib.mkIf config.kdlt.graphical.waybar.enable {
    home-manager.users.${config.kdlt.username} = {...}: {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile = {
        # "hypr/waybar" = { # this lifted config is not a valid path for waybar
        "waybar" = {
          # this will be the created directory relative to $XDG_CONFIG_HOME
          source = ./config;
          recursive = true;
        };
      };
    };
  };
}
