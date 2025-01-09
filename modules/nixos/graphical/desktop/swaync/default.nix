{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    kdlt.graphical = {
      swaync.enable = lib.mkEnableOption "Enable Swaync";
    };
  };

  config = lib.mkIf config.kdlt.graphical.swaync.enable {
    home-manager.users.${config.kdlt.username} = {
      services = {
        swaync = {
          enable = true;
          # example settings lifted from
          # https://mynixos.com/home-manager/options/services.swaync.settings
          settings = {
            positionX = "right";
            positionY = "top";
            layer = "overlay";
            control-center-layer = "top";
            layer-shell = true;
            cssPriority = "application";
            control-center-margin-top = 0;
            control-center-margin-bottom = 0;
            control-center-margin-right = 0;
            control-center-margin-left = 0;
            notification-2fa-action = true;
            notification-inline-replies = false;
            notification-icon-size = 64;
            notification-body-image-height = 100;
            notification-body-image-width = 200;
          };
          style = ''''; # null or path or multiline string
        };
      };
    };
  };
}
