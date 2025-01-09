# ~/dotfiles/modules/core/home-manager/default.nix
{
  username,
  stateVersion,
  pkgs,
  ...
}:
{
  home-manager.users.${username}.home.stateVersion = stateVersion;
  home-manager.users.root.home.stateVersion = stateVersion;
}
