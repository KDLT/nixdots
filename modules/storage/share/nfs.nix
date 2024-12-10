{
  lib,
  pkgs,
  config,
  ...
}:
let
  nfs = config.kdlt.storage.share.nfs;
in
{
  options.kdlt.storage = {
    share.nfs.enable = lib.mkEnableOption "NFS server";
  };
  config = lib.mkIf nfs.enable {
    environment.systemPackages = [ pkgs.nfs-utils ];

    services.nfs.server = {
      enable = true;
      # NFSv3 requires server to have fixed ports
      # fixed rpc.statd port; for firewall
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      extraNfsdConfig = '''';

      # exports below exposes specific shares to 2 local ips 56->proxmox 54->think
      # /export         192.168.1.56(rw,fsid=0,no_subtree_check) 192.168.1.54(rw,fsid=0,no_subtree_check)
      # /export/kotomi  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)
      # /export/mafuyu  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)
      # /export/tomoyo  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)

      # this exposes to the entire local network?
      exports = ''
        /export         192.168.1.0/24(rw,fsid=0,no_subtree_check)
        /export/kotomi  192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
        /export/mafuyu  192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
        /export/tomoyo  192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
      '';
      # rw = allow both read and write requests on this NFS subvolume, default is disallow any
      # nohide = children of an explicitly mounted parent filesystem is automatically visible
      # insecure = allows clients with NFS implementations that don't use a reserved port for NFS
      # no_subtree_check = don't bother checking if the accessed file is in the apporporiate filesystem and it is in the exported tree
    };

    # testing the bind-mount approach from https://nixos.wiki/wiki/NFS
    fileSystems."/export/mafuyu" = {
      device = "/mnt/mafuyu";
      options = [ "bind" ];
    };

    fileSystems."/export/sen" = {
      device = "/mnt/sen";
      options = [ "bind" ];
    };

    fileSystems."/export/tomoyo" = {
      device = "/mnt/tomoyo";
      options = [ "bind" ];
    };

    fileSystems."/export/kotomi" = {
      device = "/mnt/kotomi";
      options = [ "bind" ];
    };

    # with firewall active, NFS needs open ports for NFSv4
    # for NFSv3; additional TCP and UDP ports are required
    networking.firewall.allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    networking.firewall.allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };
}
