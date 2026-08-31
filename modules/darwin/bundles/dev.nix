{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.kdlt.darwin.bundles.dev;
in
{
  options.kdlt.darwin.bundles.dev.enable = lib.mkEnableOption ''
    container tooling: colima. The docker engine itself is a per-machine
    choice -- K-MBP uses the docker-desktop cask, K-MBA the docker CLI
    formula -- so each machine declares that in its own config'';

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.home.packages = [ pkgs.colima ];
  };
}
