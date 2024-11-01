{
  config,
  lib,
  ...
}:
with lib;
with types;
{
  imports = [
    ./applications
    ./desktop
    ./gtk
    ./nvidia
    ./amd
    ./sound
    ./stylix # TODO: still infinite recursion when stylix is enabled
    ./terminal
    ./xdg
  ];

  options = {
    kdlt.graphical = {
      enable = mkEnableOption "Graphical Environment";
      laptop = mkEnableOption "Laptop config";
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
      laptop = mkDefault false;
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
