{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      swww.enable = lib.mkEnableOption "Enable swww";
    };
  };

  config =
    lib.mkIf config.kdlt.graphical.swww.enable {
    };
}
