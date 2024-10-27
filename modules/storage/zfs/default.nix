# ~/dotfiles/modules/storage/zfs/default.nix
{ config, lib, ... }:
let
  zfs = config.kdlt.storage.zfs;
  impermanence = config.kdlt.storage.impermanence;
  poolName = config.kdlt.storage.zfs.zpool.name;
  blankRootSnap = poolName + "/local/root@blank";
  cacheDataset = config.kdlt.zfs.zpool.dataset.cache;
  dataDataset = config.kdlt.zfs.zpool.dataset.data;
in
with lib;
{
  options.kdlt.storage = {
    zfs = {
      enable = mkEnableOption "zfs";
    };
  };

  config = mkIf zfs.enable {
    # pending sanoid
    services = {
      zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      # sanoid is zfs snapshotting service
      sanoid = {
        enable = true;
        interval = "hourly"; # default is hourly
        datasets = {
          # attribute set of (dataset/template options)
          ${dataDataset} = {
            autoprune = true;
            autosnap = true;
            daily = 3; # number of daily snapshots, 3 is every 8 hours quick mafs
          };
          ${cacheDataset} = {
            autoprune = true;
            autosnap = true;
            daily = 3;
          };
        };
      };
    };

    boot.initrd.systemd = mkIf impermanence.enable {
      enable = mkDefault true;
      services.rollback = {
        description = "Rollback root filesystem to blank state";
        wantedBy = [ "initrd.target" ];
        after = [ "zfs-import-rpool.service" ];
        before = [ "sysroot.mount" ];
        path = [ pkgs.zfs ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          zfs rollback -r ${blankRootSnap} && echo " >> >> rollback complete << <<"
        '';
      };
    };
  };
}
