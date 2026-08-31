{ username, lib, ... }:
{
  # Always-on Homebrew layer: the machinery plus only what every Darwin host
  # wants. App/tool sets that differ per machine live in
  # modules/darwin/bundles/*, which append to these lists via `mkIf`.
  homebrew = {
    enable = true;

    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap"; # 'zap': uninstalls anything not declared anywhere

    brews = [
      "mas" # mac app store CLI -- required for masApps to install
      "gemini-cli"
      "m-cli" # swiss army knife for macOS
      "terminal-notifier" # notifications from the command line
    ];

    casks = [
      "firefox" # preferred browser
      "aldente" # menu-bar battery charge limiter
      "claude-code" # prefer the cask over the npm install
      "vorssaint" # multi-purpose menu bar app
    ];

    # Applications from the Mac App Store (via mas). You must have installed
    # each once manually so your Apple account has a record of it.
    # `mas search "app name"` -> use the 10-digit code.
    masApps = {
      "Dark Reader for Safari" = 1438243180;
    };
  };

  # make `brew` available in the shell
  # (equivalent of adding `eval "$(/opt/homebrew/bin/brew shellenv)"` to .zprofile)
  home-manager.users.${username} = {
    programs.zsh.initContent = lib.mkOrder 1000 ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
