{ lib, username, useremail, ... }:
{
  home-manager.users.${username} = {
    # `programs.git` will generate the config file: ~/.config/git/config
    # to make git use this config file, `~/.gitconfig` should not exist!
    #
    #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
    # this errors out complaining about hm not existing
    # home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    #   rm -f ~/.gitconfig
    # '';

    programs.git = {
      enable = true;
      lfs.enable = true;

      userName = username;
      userEmail = useremail;

      # dunno what this is
      # includes = [
      #   {
      #     # use diffrent email & name for work
      #     path = "~/work/.gitconfig";
      #     condition = "gitdir:~/work/";
      #   }
      # ];

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
      };

      # signing = {
      #   key = "xxx";
      #   signByDefault = true;
      # };

      delta = {
        enable = true;
        options = {
          features = "side-by-side";
        };
      };

      aliases = {
        # common aliases
        br = "branch";
        co = "checkout";
        a = "add";
        s = "status";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";
        amend = "commit --amend -m";

        # aliases for submodule
        update = "submodule update --init --recursive";
        foreach = "submodule foreach";
      };
    };
  };
}
