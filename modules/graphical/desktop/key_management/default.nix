{
  lib,
  config,
  ...
}: {
  options = {
    kdlt.graphical = {
      key_management.enable = lib.mkEnableOption "Enable Key_management";
    };
  };

  config =
    lib.mkIf config.kdlt.graphical.key_management.enable {
    };
}
