# ~/dotfiles/modules/core/storage/default.nix
_: {
  imports = [
    ./zfs
    ./btrfs
  ];
}
