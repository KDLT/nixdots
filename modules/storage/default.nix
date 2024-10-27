# ~/dotfiles/modules/core/storage/default.nix
{ lib, ... }:
with lib;
{
  imports = [
    ./zfs
    ./btrfs
    ./impermanence
  ];

  options.kdlt.storage = {
    dataPrefix = mkOption {
      # would mostly consist of configs, home subdirectories
      default = "/data";
      description = "directory prefix for all data that must persist on reboot";
    };
    cachePrefix = mkOption {
      # cache for my sanity to not have to relogin accounts and reset configs
      # only separating this to avoid the mess
      default = "/cache";
      description = "directory prefix for all cache that must persist on reboot";
    };
  };
}
