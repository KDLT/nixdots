{
  config,
  lib,
  ...
}: {
  options = {
    kdlt = {
      graphical.applications.obsidian.enable = lib.mkEnableOption "obsidian";
    };
  };

  config = lib.mkIf config.kdlt.graphical.applications.obsidian.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["obsidian"];
    # environment.systemPackages = [ pkgs.obsidian ];
  };
}
