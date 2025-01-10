{username, stateVersion, ...}:
{
  home-manager.users.${username} = {
    # stateVersion is hard declared here for now
    # plan to move this to machines/MBP
    home.stateVersion = stateVersion;
    xdg.enable = true; # this is required by my setup for the auto-session plugin for tmux
    programs.home-manager.enable = true;
  };
}
