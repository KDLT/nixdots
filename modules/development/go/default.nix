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
      go.enable = lib.mkEnableOption "Go";
    };
  };

  config = lib.mkIf config.kdlt.development.go.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = [pkgs.go];
    };
  };
}
