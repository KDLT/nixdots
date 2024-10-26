# ~/dotfiles/modules/core/connectivity/wireless/default.nix
{
  config,
  lib,
  user,
  ...
}: let
in {
  options = {
    kdlt.core.wireless = {
      enable = lib.mkEnableOption "wireless via nmtui, must add user to networkmanager group";
      # enable = lib.mkOption {
      #   default = true;
      #   type = lib.types.bool;
      #   description = "enable wireless, connect with nmtui";
      # };
    };
  };

  config = lib.mkIf config.kdlt.core.wireless.enable {
    networking.networkmanager.enable = true;
  };
}
