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
    home-manager.users.${config.kdlt.username} =
      { ... }:
      {
        programs.waybar = {
          enable = true;
          systemd.enable = true; # this probably causes double waybar
        };

        # xdg.configFile = {
        #   "waybar" = {
        #     # this will be the created directory relative to $XDG_CONFIG_HOME
        #     source = ./config;
        #     recursive = true;
        #   };
        # };
      };
  };
}
