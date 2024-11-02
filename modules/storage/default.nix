# ~/dotfiles/modules/core/storage/default.nix
{
  lib,
  mylib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./btrfs
  #   ./impermanence
  #   ./zfs
  # ];

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

  # one of these must be set to true filesystem
  config.kdlt.storage = {
    btrfs.enable = mkDefault false;
    zfs.enable = mkDefault false;
  };
}
