{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  # i choose to not declare these options here but in ../default.nix instead
  options = {
    kdlt.development = {
      azure-cli.enable = lib.mkEnableOption "Azure CLI";
    };
  };

  config = lib.mkIf config.kdlt.development.azure-cli.enable {
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.core.persistence.enable { homeCacheLinks = [ ".azure" ]; })
    #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
    # ];

    home-manager.users.${config.kdlt.username} = {
      # NOTICE: first time i've seen pkgs.stable specifically used
      home.packages = with pkgs.stable; [
        azure-cli
        #bicep
      ];
    };
  };
}
