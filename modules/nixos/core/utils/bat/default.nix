# ~/dotfiles/modules/core/utils/bat/default.nix
{
  config,
  pkgs,
  ...
}: {
  config = {
    # home-manager.${user.username} = {...}: {
    # why is the output not a function like above?

    home-manager.users.${config.kdlt.username} = {
      programs.bat = {
        enable = true;
        # TODO: test if pkgs.bat is not required, eliminating the need for pkgs in the inputs
        package = pkgs.bat;
      };
    };
  };
}
