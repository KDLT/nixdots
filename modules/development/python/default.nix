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
      python.enable = lib.mkEnableOption "Python312";
    };
  };

  config = lib.mkIf config.kdlt.development.python.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = [
        pkgs.python312
        # pkgs.python312Full # i wonder what full means
      ];
    };
  };
}
