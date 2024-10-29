{
  lib,
  ...
}:
with lib;
{
  imports = [
    ./settings.nix
  ];
  options = {
    kdlt = {
      graphical = {
        nvidia.enable = mkEnableOption "nvidia gpu";
        nvidia.super = mkEnableOption "nvidia super series gpu";
      };
    };
  };
  config.kdlt.graphical = {
    nvidia.enable = mkDefault false;
  };
}
