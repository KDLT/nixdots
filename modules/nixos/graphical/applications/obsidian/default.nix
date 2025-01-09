{
  config,
  lib,
  ...
}:
let
  obsidian = config.kdlt.graphical.applications.obsidian;
in
with lib;
{
  options = {
    kdlt = {
      graphical.applications.obsidian.enable = mkEnableOption "obsidian";
    };
  };

  config = mkIf obsidian.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [ "obsidian" ];
    # environment.systemPackages = [ pkgs.obsidian ];
  };
}
