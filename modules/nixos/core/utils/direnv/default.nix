# ~/dotfiles/modules/core/utils/direnv/default.nix
{
  config,
  lib,
  user,
  ...
}:
let
  userName = config.kdlt.username;
  direnv = config.kdlt.core.nix.direnv;
in
with lib;
{
  config = {
    home-manager.users.${userName} = {
      programs.direnv = {
        enable = mkIf direnv.enable true;
        # this takes care of the shell hook in .zshrc
        enableZshIntegration = true;
        nix-direnv.enable = mkIf direnv.enable true;
      };
    };
  };
}
