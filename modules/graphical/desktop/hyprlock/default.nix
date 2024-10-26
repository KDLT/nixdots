{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      hyprlock.enable = lib.mkEnableOption "Enable hyprlock";
    };
  };

  config =
    lib.mkIf config.kdlt.graphical.hyprlock.enable {
    };
}
