{
  lib,
  mylib,
  ...
}:
with lib;
# checking here if i really need the arguments line
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./firefox
  #   ./obsidian
  # ];

  config.kdlt.graphical.applications = {
    firefox.enable = mkDefault true;
    obsidian.enable = mkDefault true;
  };
}
