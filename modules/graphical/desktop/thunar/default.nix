# ~/dotfiles/modules/graphical/desktop/thunar.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    kdlt.graphical.thunar.enable = lib.mkEnableOption "thunar";
  };
  config = lib.mkIf config.kdlt.graphical.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin # file context menus for archives
        thunar-volman # auto management of removable drives
      ];
    };
  };
}
