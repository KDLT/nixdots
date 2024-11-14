{
  # use disko to manage storage hardware declarations
  # input arguments for disks are acquired by running
  # ls -l /dev/disk/by-id during install
  disk ? "/dev/disk/by-id/nvme-SAMSUNG_MZVLB1T0HBLR-000L7_S4EMNX0T800799",
  config,
  lib,
  ...
}:
let
  # poolName = "rpool";
  poolName = config.kdlt.storage.zfs.zpool.name;
  poolData = config.kdlt.storage.zfs.zpool.dataset.data;
  poolCache = config.kdlt.storage.zfs.zpool.dataset.cache;
  poolMedia = poolData + "/data";
  blankRootSnap = poolName + "/local/root@blank";
in
# blankRootSnap = "rpool/local/root@blank";
with lib;
# not sure if this is the place to put options and config so i backed this up
{
  options.kdlt.storage.zfs = {
    zpool = mkOption {
      type =
        with types;
        submodule {
          options = {
            name = mkOption {
              type = str;
              default = "rpool";
            };
            dataset = {
              data = mkOption {
                type = str;
                description = "dataset to store persistent data, name of zpool excluded";
                default = "persist/data";
              };
              cache = mkOption {
                type = str;
                description = "dataset to store generated cache, name of zpool excluded";
                default = "local/cache";
              };
            };
          };
        };
    };
  };
  config = {
    disko.devices = {
      disk = {
        disk0 = {
          type = "disk";
          device = disk;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = poolName;
                };
              };
            };
          };
        };
      };
      zpool = {
        ${poolName} = {
          type = "zpool";
          mode = {
            topology = {
              type = "topology";
              vdev = [
                {
                  mode = "mirror";
                  members = [
                    "disk0"
                    "disk1"
                  ];
                }
              ];
            };
          };
          options = {
            # pool options/features
            ashift = "12";
            autotrim = "on";
            cachefile = "none";
          };
          rootFsOptions = {
            # file system properties
            canmount = "off";
            compression = "lz4";
            atime = "on";
            relatime = "on";
            xattr = "sa";
            dedup = "off";
            acltype = "posixacl";
            sync = "standard";
            # for zfs snapshotting, set up sanoid instead
            # "com.sun:auto-snapshot" = "false";
          };
          mountpoint = null;
          datasets = {
            local = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
            };
            persist = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
            };
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
              postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^${blankRootSnap}$' || zfs snapshot ${blankRootSnap}";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };
            "local/nix-store" = {
              type = "zfs_fs";
              mountpoint = "/nix/store";
            };
            ${poolCache} = {
              type = "zfs_fs";
              mountpoint = "/cache";
            };
            ${poolData} = {
              type = "zfs_fs";
              mountpoint = "/data";
            };
            ${poolMedia} = {
              type = "zfs_fs";
              mountpoint = "/media";
            };
          };
        };
      };
    };
  };
}
