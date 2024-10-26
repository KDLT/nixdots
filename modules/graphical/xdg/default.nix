{
  config,
  lib,
  ...
}: {
  options = {
    kdlt.graphical.xdg.enable = lib.mkEnableOption "xdg folders";
  };

  config = lib.mkIf config.kdlt.graphical.xdg.enable {
    home-manager.users.${config.kdlt.username} = {
      xdg = {
        enable = true;
        userDirs.enable = true;
        userDirs.createDirectories = true;
      };
    };
  };
}
