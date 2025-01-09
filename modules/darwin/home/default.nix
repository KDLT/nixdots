{username, stateVersion, mylib, ...}:
{
  imports = mylib.scanPaths ./.;

  config = {
    programs.home-manager.enable = true;
    home-manager.users.${username} = {
      # stateVersion is hard declared here for now
      # plan to move this to machines/MBP
      home.stateVersion = stateVersion;
      xdg.enable = true;
    };
  };
}
