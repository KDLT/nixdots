# ~/dotfiles/modules/core/storage/zfs/default.nix
{ config, lib, ... }:
let
  zfs = config.kdlt.storage.zfs.enable;
  impermanence = config.kdlt.storage.impermanence.enable;
in
with lib;
{
  options.kdlt.storage = {
    zfs = {
      enable = mkEnableOption "zfs";
    };
  };
  config = mkIf zfs {
    # pending sanoid
    services = {
      zfs = {
        autoScrub.enable = true;
        trim.enable = true;
      };

      sanoid = {
        enable = true;
        interval = "hourly"; # default is hourly
        datasets = {
          # attribute set of (dataset/template options)
          "rpool/local/cache" = {
            autoprune = true;
            autosnap = true;
            daily = 3; # number of daily snapshots, 3 is every 8 hours quick mafs
          };
          "rpool/persist/data" = {
            autoprune = true;
            autosnap = true;
            daily = 3;
          };
        };
      };
    };

    boot.initrd.systemd = mkIf impermanence {
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
          zfs rollback -r rpool/local/root@blank && echo " >> >> rollback complete << <<"
        '';
      };
    };
  };
}
