{ config, lib, ... }:
let
  dataPrefix = config.kdlt.storage.dataPrefix;
  impermanence = config.kdlt.storage.impermanence;
in
with lib;
{
  # persistence for bluetooth devices
  systemd.tmpfiles.rules = mkIf impermanence.enable [
    # L creates symlink, from target path to destination?
    ''L /var/lib/bluetooth - - - - "${dataPrefix}" + "/var/lib/bluetooth''
  ];
}
