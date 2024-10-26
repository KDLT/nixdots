# ~/dotfiles/modules/development/git/lazy_git.nix
{
  config,
  user,
  ...
}: let
  kdlt-lazygit = homeDir: {
    programs.lazygit = {
      enable = true;
      settings = {
        overrideGpg = true;
      };
    };
  };
in {
  home-manager.users.${config.kdlt.username} = {...}:
    kdlt-lazygit "/home/${config.kdlt.username}";
}
