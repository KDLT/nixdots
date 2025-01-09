{
  lib,
  mylib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./settings.nix
  # ];
  options.kdlt.graphical = {
    amd.enable = mkEnableOption "amd gpu";
  };
  config.kdlt.graphical = {
    amd.enable = mkDefault false;
  };
}
