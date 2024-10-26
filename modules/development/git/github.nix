# ~/dotfiles/modules/development/git/github.nix
# programs.gh is the github cli tool
{
  lib,
  config,
  user,
  ...
}: let
  kdlt-gh = homePath: {
    programs.gh = {
      enable = true;
      settings = {
        editor = "nvim";
        git_protocol = "ssh";
      };
    };
  };
in {
  # kdlt.core.zfs = lib.mkMerge [
  #   (lib.mkIf config.kdlt.core.persistence.enable { homeCacheLinks = [".gh"]; })
  #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
  # ];

  # TODO-COMPLETE: check if the _: can really stand in place of {...}:
  # yes but strictly for those not needing any other input like lib or pkgs
  home-manager.users.${config.kdlt.username} = _: (kdlt-gh "/home/${config.kdlt.username}");
}
