# Reference: https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim
{
  inputs,
  config,
  lib,
  ...
}:
let
  userName = config.kdlt.username;
in
{
  options = {
    kdlt.core.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf config.kdlt.core.nixvim.enable {
    home-manager.users.${userName} = {
      home = {
        packages = [
          # this ought to be my own nixvim configuration from inputs, see flake.nix
          inputs.nixvim.packages.x86_64-linux.default
        ];

        sessionVariables = {
          EDITOR = "nvim";
        };

        shellAliases = {
          v = "nvim";
        };
      };
    };
  };
}
