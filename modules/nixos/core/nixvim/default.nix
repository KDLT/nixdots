# Reference: https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim
{
  inputs,
  config,
  username,
  lib,
  ...
}:
{
  options = {
    kdlt.core.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf config.kdlt.core.nixvim.enable {
    home-manager.users.${username} = {
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
