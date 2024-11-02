{
  pkgs,
  lib,
  config,
  ...
}:
let
  userName = config.kdlt.username;
  docker = config.kdlt.development.virtualization.docker;
  impermanence = config.kdlt.storage.impermanence;
  dataPrefix = config.kdlt.storage.dataPrefix;
in
with lib;
{
  options = {
    kdlt.development = {
      virtualization.docker.enable = mkEnableOption "Docker";
    };
  };

  config = mkIf docker.enable {
    # if impermanence is enabled as well, add /opt/docker to persistent system dirs
    kdlt.storage.impermanence = {
      persist.systemDirs = mkIf impermanence.enable [ "/opt/docker" ];
    };

    users.users.${userName}.extraGroups = [ "docker" ];

    virtualisation.docker = {
      enable = true;
      extraOptions = "--data-root ${dataPrefix}/var/lib/docker";
      storageDriver = "zfs"; # changing storage drivers will turn current images inaccessible
    };

    home-manager.users.${userName} = {
      home.packages = [
        pkgs.python312
        # pkgs.python312Full # i wonder what full means
      ];
    };
  };
}
