{
  config,
  pkgs,
  lib,
  ...
}:
let
  dataPrefix = config.kdlt.storage.dataPrefix;
  cachePrefix = config.kdlt.storage.cachePrefix;
  userName = config.kdlt.username;
in
with lib;
{
  options.kdlt.storage = {
    impermanence = {
      enable = mkEnableOption "Enable Impermanence";
    };
  };
  config = mkIf config.kdlt.storage.impermanence.enable {

    fileSystems."${dataPrefix}".neededForBoot = true;
    environment.persistence."${dataPrefix}" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
      ];

      # either this or the home.persistence approach
      users."${userName}" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "dotfiles"
          "code"
          {
            directory = ".ssh";
            mode = "0700";
          }
          {
            directory = ".mozilla";
            mode = "0700";
          }
          {
            directory = ".config";
            mode = "0700";
          }
          {
            directory = ".local/share";
            mode = "0700";
          }
        ];
        files = [
          ".screenrc"
        ];
      };
    };

    fileSystems."${cachePrefix}".neededForBoot = true;
    environment.persistence."${cachePrefix}" = {
      users."${userName}" = {
        directories = [
          ".cache/epiphany"
          ".cache/mozilla"
          ".cache/tracker3"
          ".cache/mesa_shader_cache_db"
        ];
      };
    };
  };
}
