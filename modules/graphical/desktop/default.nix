{
  config,
  mylib,
  lib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./anyrun
  #   ./fuzzel
  #   ./hyprland
  #   ./hyprlock
  #   ./hyprpaper
  #   ./key_management
  #   ./swaync
  #   ./swww
  #   ./thunar
  #   ./waybar
  #   ./wlogout
  # ];

  config = mkIf config.kdlt.graphical.enable {
    kdlt.graphical = {
      anyrun.enable = mkDefault true;
      fuzzel.enable = mkDefault true;
      hyprland.enable = mkDefault true;
      hyprlock.enable = mkDefault true;
      hyprpaper.enable = mkDefault true;
      key_management.enable = mkDefault true;
      swaync.enable = mkDefault true;
      swww.enable = mkDefault true;
      thunar.enable = mkDefault true;
      waybar.enable = mkDefault true;
      wlogout.enable = mkDefault true;
    };
  };
}
