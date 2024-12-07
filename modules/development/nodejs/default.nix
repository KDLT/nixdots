{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  userName = config.kdlt.username;
  nodejs = config.kdlt.development.nodejs;
in
with lib;
{
  options = {
    kdlt.development = {
      nodejs.enable = mkEnableOption "nodejs";
    };
  };

  # refer to https://nixos.wiki/wiki/Node.js for nodejs temperament
  # consider using direnv along with node
  config = mkIf nodejs.enable {
    home-manager.users.${userName} = {
      # nodejs is an alias for the latest LTS (long term support) version
      home.packages = [
        pkgs.nodejs
        pkgs.deno # try adding deno, allegedly better node
      ];
    };
  };
}
