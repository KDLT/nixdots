# ~/dotfiles/modules/development/git/github.nix
# programs.gh is the github cli tool
{
  lib,
  config,
  ...
}:
let
  gitAliases = {
    s = "status";
    a = "add"; # specific files
    A = "add ."; # add all
    c = "commit -m";
    ac = "commit -am"; # add and commit combo
  };
in
{
  # kdlt.core.zfs = lib.mkMerge [
  #   (lib.mkIf config.kdlt.core.persistence.enable { homeCacheLinks = [".gh"]; })
  #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
  # ];

  # TODO-COMPLETE: check if the _: can really stand in place of {...}:
  # yes but strictly for those not needing any other input like lib or pkgs
  config = {
    home-manager.users.${config.kdlt.username} = {
      programs.git = {
        enable = true;
        aliases = gitAliases;
        ignores = [
          ".*/" # ignore all dot folders but include files
          "!/.gitignore" # do not ignore .gitignore
        ];
        # better diff
        delta = {
          enable = true;
          options = {
            side-by-side = true;
            hyperlinks = true;
          };
        };
      };

      # github cli tool
      programs.gh = {
        enable = true;
        settings = {
          editor = "nvim";
          git_protocol = "ssh";
          aliases = gitAliases;
        };
      };
    };
    # _: (kdlt-gh "/home/${config.kdlt.username}");

  };
}
