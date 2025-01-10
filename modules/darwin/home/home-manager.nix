{username, stateVersion, ...}:
{
  home-manager.users.${username} = {
    home.stateVersion = stateVersion;
    xdg.enable = true; # this is required by my setup for the auto-session plugin for tmux
    programs.home-manager.enable = true;
  };
}
