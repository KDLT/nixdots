{
  lib,
  pkgs,
  config,
  ...
}:
let
  samba = config.kdlt.storage.share.samba;
  impermanence = config.kdlt.storage.impermanence;
  dataPrefix = config.kdlt.storage.dataPrefix;
  userName = config.kdlt.username;
  mountPath = "/mnt/samba";
in
{
  options.kdlt.storage = {
    share.samba.enable = lib.mkEnableOption "Samba server";
  };

  # lifted from wiki https://nixos.wiki/wiki/Samba
  # example config for public guest share called `public` and private share called `private`
  config = lib.mkIf samba.enable {
    users.users."${userName}".extraGroups = [ "nogroup" ];

    environment.systemPackages = [
      pkgs.samba
      pkgs.samba4Full
    ];

    # bind-mount approach adopted from https://nixos.wiki/wiki/NFS
    # this would be the default method if NOT using impermanence
    fileSystems = lib.mkIf (!impermanence.enable) {
      ${mountPath} = {
        # directory below will be created by the system if it did not exist prior to declaration here
        device = mountPath;
        # will default to root:root ownership
        options = [ "bind" ];
      };
    };

    # persist directory as needed
    # user and group will match only if the directory is declaratively created here
    # otherwise, manually chown it
    environment.persistence."${dataPrefix}".directories = lib.mkIf impermanence.enable [
      {
        # this resolves to a hardlink to /data/mnt/samba
        directory = mountPath;
        user = "nobody";
        group = "nogroup";
        mode = "2770";
      }
      (mountPath + "/public")
      (mountPath + "/private")
      (mountPath + "/backup")
      (mountPath + "/backup/timemachine")
      (mountPath + "/backup/think")
    ];

    services.samba = {
      enable = true;
      # securityType = "user"; # replaced with services.samba.settings.global.security
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.1. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };

        # public accounts can be accessed by guests
        # guests default to username nobody
        # chown -R nobody:nogroup /mnt/Samba/Public
        "public" = {
          ## this directory must be created manually, though
          ## my approach is either via fileSystems or impermanence
          "path" = "/mnt/samba/public";
          "browseable" = "yes";
          # even though "force user" is not set, NON-guest access is still read only. WHY?
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644"; # files:-rw-r--r-- directories:drw-r--r--
          "directory mask" = "0755"; # files:-rwxr-xr-x directories:drwxr-xr-x
        };

        # private has "guest ok" set to "no"
        # this needs a local user account from the host machine
        # this is configured to user kba
        # password is set using `smbpasswd -a kba`, kba must be an existing user in the host machine
        # this is the password needed when accessing from the remote machine
        "private" = {
          "path" = "/mnt/samba/private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # this user, in this case `kba`, must exist beforehand in the host system
          "force user" = userName;
          # to add password to a user called kba use `sudo smbpasswd -a kba`
          "force group" = "nogroup";
        };

        # Apple time machine
        "tm_share" = {
          "path" = "/mnt/samba/timemachine";
          "valid users" = "kba";
          "public" = "no";
          "writeable" = "yes";
          "force user" = "kba";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };
    };

    # samba web services dynamic discovery host daemon
    # enables samba hosts like local nas device to be found by windows
    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
