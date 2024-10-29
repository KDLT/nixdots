{
  config,
  lib,
  ...
}:
{
  options = {
    kdlt.graphical.waybar.enable = lib.mkEnableOption "waybar on";
  };

  config = lib.mkIf config.kdlt.graphical.waybar.enable {
    home-manager.users.${config.kdlt.username} = {
      # better run waybar from hyprland's exec-start where configs are intact
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };

      xdg.configFile = {
        "waybar" = {
          # this will be the created directory relative to $XDG_CONFIG_HOME
          source = ./config;
          recursive = true;
        };
      };
    };
  };
}
