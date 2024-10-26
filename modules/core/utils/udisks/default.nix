# ~/dotfiles/modules/core/utils/udisks/default.nix
{
  config,
  pkgs,
  ...
}: let
  username = config.kdlt.username;
in {
  services = {
    udisks2.enable = true; # udiskie requires udisks2 to be enabled
  };

  home-manager.users = {
    ${username} = {
      services = {
        udiskie = {
          enable = true; # automount usb, todo: enable udisks2 service
          settings = {
            program_options = {
              udisks_version = 2;
              tray = true;
            };
            icon_names.media = ["media-optical"];
          };
        };
      };
    };
  };
}
