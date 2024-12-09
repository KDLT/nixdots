{
  pkgs,
  lib,
  config,
  ...
}:
let
  userName = config.kdlt.username;
  tailscale = config.kdlt.development.tailscale;
in
with lib;
{
  options = {
    kdlt.development = {
      tailscale.enable = mkEnableOption "Tailscale";
    };
  };

  config = mkIf tailscale.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
  };
}
