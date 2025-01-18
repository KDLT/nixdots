{ config, username, ... }:
let
  defaultIdentity = "~/.ssh/id_ed25519";
in
{
  config = {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        userKnownHostsFile = "~/.ssh/known_hosts";
        hashKnownHosts = false; # hashes the known contents of know_hosts file
        addKeysToAgent = "yes";

        # matchBlocks is per Host settings similar to how ~/.ssh/config is
        # Since I am setting this up for multiple machines, I am going for
        # a standard identityFile naming scheme: id-kba-ed25519
        matchBlocks = {
          "git@github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = defaultIdentity;
          };
          NeoVaderon = {
            hostname = "192.168.1.34";
            user = "pi";
            identityFile = defaultIdentity;
          };
          K-Think = {
            hostname = "192.168.1.54";
            user = username;
            identityFile = defaultIdentity;
          };
          K-Link = {
            hostname = "192.168.1.40";
            user = username;
            identityFile = defaultIdentity;
          };
          K-Mac = {
            hostname = "192.168.1.59";
            user = username;
            identityFile = defaultIdentity;
          };
          A-Mac = {
            hostname = "192.168.1.44";
            user = "a";
            identityFile = defaultIdentity;
          };
        };
      };

      # aarch64-darwin not compatible with ssh-agent
      # services.ssh-agent = {
      #   enable = true;
      # };
    };
  };
}
