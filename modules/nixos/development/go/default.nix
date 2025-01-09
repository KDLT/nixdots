{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  userName = config.kdlt.username;
  go = config.kdlt.development.go;
in
with lib;
{
  options = {
    kdlt.development = {
      go.enable = mkEnableOption "Go";
    };
  };

  config = mkIf go.enable {
    home-manager.users.${userName} = {
      home.packages = [ pkgs.go ];
    };
  };
}
