{username, ...}:
{
  imports = [
    ./core.nix
    ./git.nix
    ./ssh.nix
    ./tmux.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      xdg.enable = true;

      home = {
        stateVersion = "24.11";
        username = username;
        homeDirectory = "/Users/" + username;
      };

      # Let home manager install and manage itself
      programs.home-manager.enable = true;
    };
  };
}
