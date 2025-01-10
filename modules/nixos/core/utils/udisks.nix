# ~/dotfiles/modules/core/utils/udisks/default.nix
{ username, ... }:
{
  services = {
    udisks2.enable = true; # udiskie requires udisks2 to be enabled
  };

  home-manager.users.${username} = {
    services.udiskie = {
      enable = true; # automount usb, needs udisks2 service enabled
      settings = {
        program_options = {
          udisks_version = 2;
          tray = true;
        };
        icon_names.media = ["media-optical"];
      };
    };
  };
}
