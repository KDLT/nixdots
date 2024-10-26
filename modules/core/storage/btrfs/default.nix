# ~/dotfiles/modules/core/storage/btrfs/default.nix
{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib; {
  options = {
    kdlt = {
      core = {
        persistence = {
          enable = mkEnableOption "Enable Persistence";
        };

        # this is supposed to be zfs, just lifted from dc-tec config
        # leaving it btrfs for now so options are defined
        # TODO redo for btrfs
        btrfs = {
          enable = mkEnableOption "btrfs";
          encrypted = mkEnableOption "btrfs request credentials";

          systemCacheLinks = mkOption {default = [];};
          systemDataLinks = mkOption {default = [];};
          homeCacheLinks = mkOption {default = [];};
          homeDataLinks = mkOption {default = [];};

          ensureSystemExists = mkOption {
            default = [];
            example = ["/data/etc/ssh"];
          };
          ensureHomeExists = mkOption {
            default = [];
            example = [".ssh"];
          };
          rootDataset = mkOption {
            default = [];
            example = "rpool/local/root";
          };
        };
      };
      dataPrefix = mkOption {
        example = "/data";
      };
      cachePrefix = mkOption {
        example = "/cache";
      };
    };
  };

  config = {
    kdlt = {
      core = {
        persistence = {
          # TODO: persistence is not yet set up, set to true after doing so
          enable = mkDefault false;
        };
        btrfs = {
          enable = mkDefault true;
        };
      };
      dataPrefix = mkDefault "/data";
      cachePrefix = mkDefault "/cache";
    };
  };
}
