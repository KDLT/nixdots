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
    formula -- so each machine declares that in its own config.
    Also pins python312 (+ pip), same version as the NixOS side,
    separate from Apple's locked /usr/bin/python3'';

  config = lib.mkIf cfg.enable {
    home-manager.users.${username}.home.packages = [
      pkgs.colima
      pkgs.python312
      pkgs.python312Packages.pip
    ];
  };
}
