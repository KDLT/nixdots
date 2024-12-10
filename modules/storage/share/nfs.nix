{
  lib,
  pkgs,
  config,
  ...
}:
let
  nfs = config.kdlt.storage.share.nfs;
  impermanence = config.kdlt.storage.impermanence;
  dataPrefix = config.kdlt.storage.dataPrefix;
in
{
  options.kdlt.storage = {
    share.nfs.enable = lib.mkEnableOption "NFS server";
  };
  config = lib.mkIf nfs.enable {
    environment.systemPackages = [ pkgs.nfs-utils ];

    # must explicitly add directory to persist if it's a top level sibling
    # this case it's /export
    environment.persistence."${dataPrefix}".directories = lib.mkIf impermanence.enable [
      # NOTE: user and group declaration will only take effect if
      # the directory is created declaratively through here
      {
        directory = "/export";
        mode = "2770";
        user = "nobody";
        group = "nogroup";
      }
      {
        directory = "/export/backup";
        # user and group aren't automatically inherited from parent
        user = "nobody";
        group = "nogroup";
      }
    ];

    services.nfs.server = {
      enable = true;
      # NFSv3 requires server to have fixed ports
      # fixed rpc.statd port; for firewall
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
      extraNfsdConfig = '''';

      # 192.168.1.0/24 exposes these directories to the local network
      # these would not be automatically created if these did not exist pre-declaration
      exports = ''
        /export         192.168.1.0/24(rw,fsid=0,no_subtree_check)
        /export/backup  192.168.1.0/24(rw,nohide,insecure,no_subtree_check)
      '';

      # rw = allow both read and write requests on this NFS subvolume, default is disallow any
      # nohide = children of an explicitly mounted parent filesystem is automatically visible
      # insecure = allows clients with NFS implementations that don't use a reserved port for NFS
      # no_subtree_check = don't bother checking if the accessed file is in the apporporiate filesystem and it is in the exported tree

      # exports below exposes specific shares to 2 local ips 56->proxmox 54->think
      # /export         192.168.1.56(rw,fsid=0,no_subtree_check) 192.168.1.54(rw,fsid=0,no_subtree_check)
      # /export/kotomi  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)
      # /export/mafuyu  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)
      # /export/tomoyo  192.168.1.56(rw,nohide,insecure,no_subtree_check) 192.168.1.54(rw,nohide,insecure,no_subtree_check)
    };

    # testing the bind-mount approach from https://nixos.wiki/wiki/NFS
    fileSystems."/export/tomoyo" = {
      # directory below will be created by the system if it did not exist prior to declaration here
      device = "/mnt/tomoyo";
      # will default to root:root ownership
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
