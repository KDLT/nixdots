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
  userName = config.kdlt.username;
in
{
  options.kdlt.storage = {
    share.nfs.enable = lib.mkEnableOption "NFS server";
  };

  # Config reference: https://nixos.wiki/wiki/NFS
  config = lib.mkIf nfs.enable {
    users.users."${userName}".extraGroups = [ "nogroup" ];

    environment.systemPackages = [ pkgs.nfs-utils ];

    # bind-mount approach from https://nixos.wiki/wiki/NFS
    # this would be the default method if NOT using impermanence
    fileSystems = lib.mkIf (!impermanence.enable) {
      "/mnt/nfs" = {
        # directory below will be created by the system if it did not exist prior to declaration here
        device = "/mnt/nfs";
        # will default to root:root ownership
        options = [ "bind" ];
      };
    };

    # explicitly add directory to persist if it's a top level directory
    # user and group will match only if the directory is declaratively created here
    # otherwise, manually chown it
    environment.persistence."${dataPrefix}".directories = lib.mkIf impermanence.enable [
      {
        directory = "/mnt/nfs";
        user = "nobody";
        group = "nogroup";
        mode = "2770";
      }
      "/mnt/nfs/public"
      "/mnt/nfs/backup"
      "/mnt/nfs/backup/proxmox"
      "/mnt/nfs/backup/think"
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
      # exported directories must exist beforehand, these won't be created by the NFS share
      exports = ''
        /mnt/nfs/public          192.168.1.0/24(rw,fsid=0,no_subtree_check)
        /mnt/nfs/backup/proxmox  192.168.1.56(rw,nohide,insecure,no_subtree_check) # only proxmox host can access this
        /mnt/nfs/backup/think    192.168.1.54(rw,nohide,insecure,no_subtree_check) # only thinkpad host can access this
      '';

      # rw = allow both read and write requests on this NFS subvolume, default is disallow any
      # nohide = children of an explicitly mounted parent filesystem is automatically visible
      # insecure = allows clients with NFS implementations that don't use a reserved port for NFS
      # no_subtree_check = don't bother checking if the accessed file is in the apporporiate filesystem and it is in the exported tree

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
