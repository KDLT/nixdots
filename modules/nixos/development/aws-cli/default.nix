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
      aws-cli.enable = lib.mkEnableOption "Aws CLI";
    };
  };

  config = lib.mkIf config.kdlt.development.aws-cli.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = [pkgs.awscli2];
    };
  };
}
