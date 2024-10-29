{
  config,
  lib,
  ...
}:
let
  userName = config.kdlt.username;
  dataPrefix = config.kdlt.storage.dataPrefix;
  cachePrefix = config.kdlt.storage.cachePrefix;
  persistentSystemDirs = [
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
  ] ++ config.kdlt.storage.impermanence.persist.systemDirs;

  persistentSystemFiles = [
    "/etc/machine-id"
    {
      file = "/var/keys/secret_file";
      parentDirectory = {
        mode = "u=rwx,g=,o=";
      };
    }
  ] ++ config.kdlt.storage.impermanence.persist.systemFiles;

  persistentHomeDirs = [
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
  ] ++ config.kdlt.storage.impermanence.persist.homeDirs;

  persistentHomeFiles = [
    ".screenrc"
  ] ++ config.kdlt.storage.impermanence.persist.homeFiles;

  PersistentCacheDirs = [
    ".cache/epiphany"
    ".cache/mozilla"
    ".cache/tracker3"
    ".cache/mesa_shader_cache_db"
  ] ++ config.kdlt.storage.impermanence.persist.cacheDirs;

in
with lib;
{
  # imports = [
  #   ./persist
  # ];
  options.kdlt.storage = {
    impermanence = {
      enable = mkEnableOption "Enable Impermanence";
      persist = with types; {
        systemDirs = mkOption {
          # a list that can consist of strings or attributes consisting of strings
          type = listOf (either str (attrsOf str));
          # type = types.listOf (types.str || types.attrs); # not sure if this is the right type declaration
          default = [ ];
          example = [ "/etc/nixos" ];
          description = "Additional system directories to persist on boot";
        };
        systemFiles = mkOption {
          type = listOf (either str (attrsOf str));
          default = [ ];
          example = [ "/etc/machine-id" ];
          description = "Additional system files to persist on boot";
        };
        homeDirs = mkOption {
          type = listOf (either str (attrsOf str));
          default = [ ];
          example = [
            "Documents"
            "Downloads"
          ];
          description = "Additional home directories to persist on boot";
        };
        homeFiles = mkOption {
          type = listOf (either str (attrsOf str));
          default = [ ];
          example = [
            ".screenrc"
            ".zshenv"
          ];
          description = "Additional home files to persist on boot";
        };
        cacheDirs = mkOption {
          type = listOf (either str (attrsOf str));
          default = [ ];
          example = [
            ".cache/epiphany"
            ".cache/mozilla"
          ];
          description = "Additional home directories to persist on boot";
        };
      };
    };
  };
  config = mkIf config.kdlt.storage.impermanence.enable {

    fileSystems."${dataPrefix}".neededForBoot = true;
    environment.persistence."${dataPrefix}" = {
      hideMounts = true;
      directories = persistentSystemDirs;
      files = persistentSystemFiles;

      # either this or the home.persistence approach
      users."${userName}" = {
        directories = persistentHomeDirs;
        files = persistentHomeFiles;
      };
    };

    fileSystems."${cachePrefix}".neededForBoot = true;
    environment.persistence."${cachePrefix}" = {
      users."${userName}" = {
        directories = PersistentCacheDirs;
      };
    };

    # # now declared in ~/nixdots/modules/core/connectivity/wireless/default.nix
    # environment.etc = {
    #   # difference between environment.etc declaration and ones that directly point to the directory to persist
    #   # is how this references a directory OUTSIDE of the typical /etc location
    #   # in this case the system-connection is created during installation, this was manually copied to the persistent path described by the dataPrefix variable
    #   "NetworkManager/system-connections" = {
    #     # dataPrefix does not get rolled back on boot
    #     source = "${dataPrefix}" + "/etc/NetworkManager/system-connections/";
    #   };
    # };

    # # now declared in ~/nixdots/modules/core/utils/sshd/default.nix
    # # persistence for ssh keys
    # services.openssh = {
    #   enable = true;
    #   hostKeys = [
    #     {
    #       path = "${dataPrefix}" + "/ssh/ssh_host_K-Link_ed25519_key";
    #       type = "ed25519";
    #     }
    #     {
    #       path = "${dataPrefix}" + "/ssh/ssh_host_K-Link_rsa_key";
    #       type = "rsa";
    #       bits = 4096;
    #     }
    #   ];
    # };

    # # now declared in ~/nixdots/modules/core/connectivity/bluetooth/default.nix
    # # persistence for bluetooth devices
    # systemd.tmpfiles.rules = [
    #   # L creates symlink, from target path to destination?
    #   ''L /var/lib/bluetooth - - - - "${dataPrefix}" + "/var/lib/bluetooth''
    # ];

    # allegedly needed for persistence
    # allow non-root users to specify the allow_other or allow_root mount options
    programs.fuse.userAllowOther = true;
  };
}
