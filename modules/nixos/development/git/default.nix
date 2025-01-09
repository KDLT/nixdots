{
  config,
  mylib,
  lib,
  ...
}:
let
in
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./lazy_git.nix
  #   ./github.nix
  # ];

  options = {
    kdlt.development.git = {
      enable = lib.mkEnableOption "enable github";
      # username = lib.mkOption { default = user.username; }; # TODO this should not be commented out
      # email = lib.mkOption { default = user.email; }; # TODO this should not be commented out
    };
  };

  config =
    # git config in a let binding to allow declaration in multiple userspaces
    let
      gitAliases = {
        s = "status";
        a = "add"; # specific files
        A = "add -A"; # add all
        c = "commit -m";
        ac = "commit -am"; # add and commit combo
      };

      kdlt-git = {
        programs.git = {
          enable = true;
          userName = config.kdlt.username;
          userEmail = config.kdlt.email;
          aliases = gitAliases;
          ignores = [
            # ".*/" # ignore all dot folders but include files, DO not ignore all dot folders since .github/ is required for actions
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

          # TODO: git configs i'm not familiar with yet so commented out
          # extraConfig = {
          #   init.defaultBranch = "main";
          #   push.autoSetupRemote = true;
          #   pull.rebase = true;
          #
          #   user.signingkey = "";
          #   commit.gpgsign = true;
          #   gpg.program = "${pkgs.gnupg}/bin/gpg2";
          #
          #   url = {
          #     "ssh://git@github.com/kdlt" = {
          #       insteadOf = "https://github.com/kdlt";
          #     };
          #   };
          #
          #   github.user = "kdlt";
          #   safe.directory = "/home/${username}/code/github/test/.git";
          # };
        };
      };
    in
    {
      # see the multiple userspaces here
      home-manager.users.${config.kdlt.username} = { ... }: kdlt-git;
      home-manager.users.root = { ... }: kdlt-git;
    };
}
