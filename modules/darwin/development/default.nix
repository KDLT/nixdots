{
  pkgs,
  username,
  ...
}:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      # python3
      colima # for containers--requires docker cask for macOS
    ];
  };
}
