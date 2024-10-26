{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  # i choose to not declare these options here but in ../default.nix instead, SIKE
  options = {
    kdlt.development.yamlls.enable = lib.mkEnableOption "Yaml Language Server";
  };

  config = lib.mkIf config.kdlt.development.yamlls.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = [pkgs.yaml-language-server];
    };
  };
}
