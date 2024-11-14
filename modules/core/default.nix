{
  lib,
  mylib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;

  options = {
    kdlt.core = {
      laptop = mkEnableOption "Laptop config";
      server = mkEnableOption "Server mode";
    };
  };

  config = {
    kdlt.core = {
      laptop = mkDefault false;
      server = mkDefault false;
    };
  };
}
