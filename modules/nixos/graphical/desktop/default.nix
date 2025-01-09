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
      fuzzel.enable = mkDefault true; # app launcher
      hyprland.enable = mkDefault true; # tiling window compositor
      hyprlock.enable = mkDefault true;
      hyprpaper.enable = mkDefault true;
      key_management.enable = mkDefault true;
      swaync.enable = mkDefault true; # sway notification center
      swww.enable = mkDefault true; # wallpaper
      thunar.enable = mkDefault true; # file explorer
      waybar.enable = mkDefault true; # desktop bar
      wlogout.enable = mkDefault true;
      swayimg.enable = mkDefault true; # image, gif viewer (wayland only)
    };
  };
}
