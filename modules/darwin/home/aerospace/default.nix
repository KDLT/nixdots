{ username, ... }:
{
  services.aerospace.enable = false; # because i want home-manager and homebrew to config aerospace

  home-manager.users.${username} = {
    # this necessitates xdg.enable = true;
    xdg.configFile = {
      "aerospace" = {
        source = ./aerospace.toml;
        target = "aerospace/aerospace.toml"; # target is relative to $XDG_CONFIG_HOME
      };
    };
  };
}
