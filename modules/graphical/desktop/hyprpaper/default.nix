{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
    };
  };

  config =
    lib.mkIf config.kdlt.graphical.hyprpaper.enable {
    };
}
