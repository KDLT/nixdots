{
  pkgs,
  lib,
  config,
  user,
  ...
}:
let
  userName = config.kdlt.username;
  lua = config.kdlt.development.lua;
in
with lib;
{
  options = {
    kdlt.development = {
      lua.enable = mkEnableOption "Lua";
    };
  };

  config = mkIf lua.enable {
    home-manager.users.${userName} = {
      home.packages = [ pkgs.lua ];
    };
  };
}
