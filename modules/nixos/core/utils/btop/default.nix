# ~/dotfiles/modules/core/utils/bottom/default.nix
{config, ...}: {
  config = {
    # home-manager.${user.username} = {...}: {
    # why is the output not a function like above?

    home-manager.users.${config.kdlt.username} = {
      programs.btop = {
        enable = true;
        settings = {
          vim_keys = true;
        };
      };
    };
  };
}
