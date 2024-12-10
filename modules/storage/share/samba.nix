{
  lib,
  pkgs,
  config,
  ...
}:
let
  samba = config.kdlt.storage.share.samba;
in
{
  options.kdlt.storage = {
    share.samba.enable = lib.mkEnableOption "Samba server";
  };

  # lifted from wiki https://nixos.wiki/wiki/Samba
  # example config for public guest share called `public` and private share called `private`
  config = {
    environment.systemPackages = [
      pkgs.samba
      pkgs.samba4Full
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
        # chown -R nobody:nogroup /mnt/Shares/Public
        "public" = {
          "path" = "/mnt/Shares/Public";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644"; # files:-rw-r--r-- directories:drw-r--r--
          "directory mask" = "0755"; # files:-rwxr-xr-x directories:drwxr-xr-x
          "force user" = "nobody"; # map all connections to the specified user
          "force group" = "nogroup"; # map all connections to the specified group
        };

        # private has guest ok set to no
        # this needs a local user account from the host machine
        # this is configured to user kba
        # password is set using `smbpasswd -a kba`, kba must be an existing user in the host machine
        # this is the password needed when accessing from the remote machine
        "private" = {
          "path" = "/mnt/Shares/Private";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "kba";
          "force group" = "users";
        };

        # Apple time machine
        "tm_share" = {
          "path" = "/mnt/Shares/tm_share";
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
