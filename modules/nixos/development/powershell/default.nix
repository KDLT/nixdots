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
      powershell.enable = lib.mkEnableOption "Powershell";
    };
  };

  config = lib.mkIf config.kdlt.development.powershell.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = [pkgs.powershell];
    };
  };
}
