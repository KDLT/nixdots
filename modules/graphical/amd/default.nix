{
  lib,
  ...
}:
with lib;
{
  imports = [
    ./settings.nix
  ];
  options.kdlt.graphical = {
    amd.enable = mkEnableOption "amd gpu";
  };
  config.kdlt.graphical = {
    amd.enable = mkDefault false;
  };
}
