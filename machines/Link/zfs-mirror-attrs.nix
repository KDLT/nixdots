{
  # use disko to manage storage hardware declarations
  # input arguments for disks are acquired by running
  # ls -l /dev/disk/by-id during install
  disks ? [
    "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2J1820088291"
    "/dev/disk/by-id/nvme-CT1000P3PSSD8_234544D6272D"
  ],
  ...
}:
# not sure if this is the place to put options and config so i backed this up
{
  disko.devices = {
    disk = {
      disk0 = {
        type = "disk";
        device = builtins.elemAt disks 0;
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
                # pool = "zroot";
                pool = "rpool"; # rpool is the name of the zpool
              };
            };
          };
        };
      };
      disk1 = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                # pool = "zroot";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      # zroot = {
      rpool = {
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
        # mountpoint = "/";
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
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "local/nix-store" = {
            type = "zfs_fs";
            mountpoint = "/nix/store";
          };
          "local/cache" = {
            type = "zfs_fs";
            mountpoint = "/cache";
          };
          "persist/data" = {
            type = "zfs_fs";
            mountpoint = "/data";
          };
        };
      };
    };
  };
}
