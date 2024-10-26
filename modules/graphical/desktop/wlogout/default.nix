{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      wlogout.enable = lib.mkEnableOption "Enable wlogout";
    };
  };

  config = lib.mkIf config.kdlt.graphical.wlogout.enable {
    home-manager.users.${config.kdlt.username} = {...}: {
      programs.wlogout = {
        enable = true;
      };

      xdg.configFile = {
        # this will be the created directory relative to $XDG_CONFIG_HOME
        # lands in ~/.config/wlogout
        "wlogout" = {
          source = ./config;
          recursive = true;
        };
      };
    };
  };
}
