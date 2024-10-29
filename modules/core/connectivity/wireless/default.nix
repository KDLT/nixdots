# ~/dotfiles/modules/core/connectivity/wireless/default.nix
{
  config,
  lib,
  user,
  ...
}:
let
  impermanence = config.kdlt.storage.impermanence.enable;
  dataPrefix = config.kdlt.storage.dataPrefix;
in
with lib;
{
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

  config = mkIf config.kdlt.core.wireless.enable {
    networking.networkmanager.enable = true;

    environment.etc = mkIf impermanence {
      # difference between environment.etc declaration and ones that directly point to the directory to persist
      # is how this references a directory OUTSIDE of the typical /etc location
      # in this case the system-connection is created during installation, this was manually copied to the persistent path described by the dataPrefix variable
      "NetworkManager/system-connections" = {
        # dataPrefix does not get rolled back on boot
        source = "${dataPrefix}" + "/etc/NetworkManager/system-connections/";
      };
    };
  };
}
