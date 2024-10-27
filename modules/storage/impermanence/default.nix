{
  config,
  lib,
  ...
}:
let
  userName = config.kdlt.username;
  dataPrefix = config.kdlt.storage.dataPrefix;
  cachePrefix = config.kdlt.storage.cachePrefix;
  persistSystemDirs = [
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
  persistSystemFiles = [
    "/etc/machine-id"
    {
      file = "/var/keys/secret_file";
      parentDirectory = {
        mode = "u=rwx,g=,o=";
      };
    }
  ];
  persistHomeDirs = [
    "Downloads"
    "Music"
    "Pictures"
    "Documents"
    "Videos"
    "nixdots"
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
  persistHomeFiles = [
    ".screenrc"
  ];
  cacheDirs = [
    ".cache/epiphany"
    ".cache/mozilla"
    ".cache/tracker3"
    ".cache/mesa_shader_cache_db"
  ];
in
with lib;
{
  options.kdlt.storage = {
    impermanence = {
      enable = mkEnableOption "Enable Impermanence";
    };
    persist = {
      systemDirs = mkOption {
        type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
        default = [ "" ]; # would this complain on an empty string?
        example = [ "/etc/nixos" ];
        description = "Additional system directories to persist on boot";
      };
      systemFiles = mkOption {
        type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
        default = null; # would this complain on null?
        example = [ "/etc/machine-id" ];
        description = "Additional system files to persist on boot";
      };
      homeDirs = mkOption {
        type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
        default = null; # would this complain on null?
        example = [
          "Documents"
          "Downloads"
        ];
        description = "Additional home directories to persist on boot";
      };
      homeFiles = mkOption {
        type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
        default = null; # would this complain on null?
        example = [
          ".screenrc"
          ".zshenv"
        ];
        description = "Additional home files to persist on boot";
      };
      cacheDirs = mkOption {
        type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
        default = null; # would this complain on null?
        example = [
          ".cache/epiphany"
          ".cache/mozilla"
        ];
        description = "Additional home directories to persist on boot";
      };
    };
  };
  config = mkIf config.kdlt.storage.impermanence.enable {

    fileSystems."${dataPrefix}".neededForBoot = true;
    environment.persistence."${dataPrefix}" = {
      hideMounts = true;
      directories = persistSystemDirs ++ config.kdlt.storage.persist.systemDirs;
      files = persistSystemFiles ++ config.kdlt.storage.persist.systemFiles;

      # either this or the home.persistence approach
      users."${userName}" = {
        directories = persistHomeDirs ++ config.kdlt.storage.persist.homeDirs;
        files = persistHomeFiles ++ config.kdlt.storage.persist.homeFiles;
      };
    };

    fileSystems."${cachePrefix}".neededForBoot = true;
    environment.persistence."${cachePrefix}" = {
      users."${userName}" = {
        directories = cacheDirs ++ config.kdlt.storage.persist.cacheDirs;
      };
    };
  };
}
