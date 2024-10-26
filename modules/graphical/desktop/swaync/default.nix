{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      swaync.enable = lib.mkEnableOption "Enable Swaync";
    };
  };

  config =
    lib.mkIf config.kdlt.graphical.swaync.enable {
    };
}
