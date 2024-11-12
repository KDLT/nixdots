{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with pkgs;
{
  options.kdlt.graphical = {
    swayimg.enable = mkEnableOption "sway image viewer";
  };
  config = {
    environment.systemPackages = mkIf config.kdlt.graphical.hyprland.enable [
      swayimg
    ];
  };
}
