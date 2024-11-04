{
  pkgs,
  config,
  ...
}:
let
  dataDir = config.kdlt.storage.dataPrefix + "/transmission";
  userName = config.kdlt.username;
in
{
  config = {
    users.users."${userName}".extraGroups = [ "transmission" ];

    environment.systemPackages = with pkgs; [
      # version 4 does not have declarative configuration
      # transmission_4-gtk
      # transmission_4-qt

      # these are version 3, supports declarative configs
      # transmission-gtk # evaluation warning: rename to transmission_3-gtk
      transmission_3-gtk # i am now uncertain if this will be declaratively configurable
      # transmission-qt # opt for gtk
    ];

    services.transmission = {
      enable = true; # enable transmission daemon
      user = "transmission";
      group = "transmission";
      home = dataDir;
      downloadDirPermissions = "0700"; # same as chmod u+rwx,g+rwx

      openRPCPort = true; # open firewall for rpc, still from wiki
      openPeerPorts = true;

      settings = {
        rpc-bind-address = "0.0.0.0"; # bind to own ip
        # whitelist local device access
        rpc-whitelest-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*"; # wildcards allowed

        # separate directory for incomplete downloads
        incomplete-dir-enabled = true;
        incomplete-dir = "${dataDir}/incomplete";
        download-dir = "${dataDir}/downloads";

        # watch given directory for torrent files, automatically add those
        watch-dir-enabled = true;
        watch-dir = "${dataDir}/watch";

        # download torrents <download-queue-size> at a time
        download-queue-enabled = true;
        download-queue-size = 1;

        # when <queue-stalled-minutes> have passed, torrent is designated stalled and
        # would no longer count towards <download-queue-size>
        queue-stalled-enable = true;
        queue-stalled-minutes = 15;
      };
    };
  };
}
