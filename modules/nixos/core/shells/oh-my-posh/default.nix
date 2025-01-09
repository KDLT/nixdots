# ~/dotfiles/modules/core/shells/oh-my-posh/default.nix
{
  config,
  pkgs,
  ...
}: {
  options = {};
  config = {
    home-manager.users = {
      ${config.kdlt.username} = {
        programs.oh-my-posh = {
          enable = true;
          enableZshIntegration = true;
          settings = builtins.fromTOML (builtins.readFile ./half-life-transient.toml);
        };
      };
    };
  };
}
