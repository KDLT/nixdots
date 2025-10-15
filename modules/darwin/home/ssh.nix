{ config, username, ... }:
let
  defaultIdentity = "~/.ssh/id_ed25519";
in
{
  config = {
    home-manager.users.${username} = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false; # set to false in anticipation since it will soon be disabled
        # hashKnownHosts = false; # hashes the known contents of know_hosts file, deprecated
        # addKeysToAgent = "yes";

        # matchBlocks is per Host settings similar to how ~/.ssh/config is
        # Since I am setting this up for multiple machines, I am going for
        # a standard identityFile naming scheme: id-kba-ed25519
        matchBlocks = {
          "git@github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = defaultIdentity;
            userKnownHostsFile = "~/.ssh/known_hosts";
            addKeysToAgent = "yes";
          };
          NeoVaderon = {
            hostname = "192.168.1.34";
            user = "pi";
            identityFile = defaultIdentity;
            userKnownHostsFile = "~/.ssh/known_hosts";
            addKeysToAgent = "yes";
          };
          K-Think = {
            hostname = "192.168.1.54";
            user = username;
            identityFile = defaultIdentity;
            userKnownHostsFile = "~/.ssh/known_hosts";
            addKeysToAgent = "yes";
          };
          K-Mac = {
            hostname = "192.168.1.59";
            user = username;
            identityFile = defaultIdentity;
            userKnownHostsFile = "~/.ssh/known_hosts";
            addKeysToAgent = "yes";
          };
          A-Mac = {
            hostname = "192.168.1.44";
            user = "a";
            identityFile = defaultIdentity;
            userKnownHostsFile = "~/.ssh/known_hosts";
            addKeysToAgent = "yes";
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
