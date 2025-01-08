{username, ...}:
{
  homebrew = {
    enable = true;

    onActivation.autoUpdate = false;
    onActivation.cleanup = "zap"; # 'zap': uninstalls all formulae(and related files) not listed here.

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    # brews = [
    #   "aria2"  # download tool
    # ];

    # `brew install --cask` are GUI apps
    casks = [
      "karabiner-elements"
      # { # testing what happens when home-manager AND homebrew installs kitty
      #   name = "kitty";
      #   args = { appdir = "~/Applications"; };
      # }
    ];
  };

  # add this to .zprofile
  # eval "$(/opt/homebrew/bin/brew shellenv)"

  home-manager.users.${username} = {
    programs.zsh.initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

}
