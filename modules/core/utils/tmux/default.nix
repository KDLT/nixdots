# leaving blank for now
{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.tmux ];

  programs.tmux = {
    enable = true;
    keyMode = "vi"; # vi keybindings
    baseIndex = 1; # index starts at 1 instead of 0
    escapeTime = 250; # default 500
    clock24 = true; # 24h clock
    historyLimit = 100000;
    shortcut = "a"; # Ctrl followed by this key will be the main shortcut
    extraConfig = '''';
  };
}
