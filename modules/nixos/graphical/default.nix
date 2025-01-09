{
  mylib,
  config,
  lib,
  ...
}:
with lib;
with types;
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./applications
  #   ./desktop
  #   ./gtk
  #   ./nvidia
  #   ./amd
  #   ./sound
  #   ./stylix
  #   ./terminal
  #   ./xdg
  # ];

  options = {
    kdlt.graphical = {
      enable = mkEnableOption "Graphical Environment";
      wallpaper = mkOption {
        description = "path to wallpaper";
        type = either str path;
        default = ../../assets/wallpaper.png;
        # default = "~/nixdots/assets/wallpaper.png";
      };
    };
  };

  config = mkIf config.kdlt.graphical.enable {
    kdlt.graphical = {
      sound = mkDefault true;
      terminal.enable = mkDefault true;
      xdg.enable = mkDefault true;
      applications = {
        firefox.enable = mkDefault true;
        obsidian.enable = mkDefault true;
      };
    };
  };
}
