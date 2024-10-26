# ~/dotfiles/modules/core/utils/direnv/default.nix
{
  config,
  lib,
  user,
  ...
}: {
  config = {
    home-manager.users.${config.kdlt.username} = {
      programs.direnv = {
        enable = lib.mkIf config.kdlt.core.nix.enableDirenv true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
