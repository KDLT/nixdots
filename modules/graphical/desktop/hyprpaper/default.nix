{
  lib,
  config,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
  userName = config.kdlt.username;
in
{
  options = {
    kdlt.graphical = {
      hyprpaper.enable = lib.mkEnableOption "Enable hyprpaper";
    };
  };

  config = {
    home-manager.users."${userName}" = {
      # I have to force disable hyprpaper because this prevents swww from taking effect
      services.hyprpaper.enable = lib.mkIf (stylix.enable) (lib.mkForce false);
    };
  };
  # lib.mkIf config.kdlt.graphical.hyprpaper.enable {
  # };
}
