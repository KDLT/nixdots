{
  config,
  lib,
  ...
}:
let
  username = config.kdlt.username;
in
# dataPrefix = "${config.kdlt.dataPrefix}";
{
  config = {
    home-manager.users.${username} = {
      programs.ssh =
        let
          defaultIdentity = "~/.ssh/id-${username}-ed25519";
        in
        {
          enable = true;
          userKnownHostsFile = "/home/${username}/.ssh/known_hosts";
          hashKnownHosts = false; # hashes the known contents of know_hosts file

          extraOptionOverrides = {
            AddKeysToAgent = "yes";
            IdentityFile = defaultIdentity;
          };

          # matchBlocks is per Host settings similar to how ~/.ssh/config is
          # Since I am setting this up for multiple machines, I am going for
          # a standard identityFile naming scheme: id-kba-ed25519
          matchBlocks = {
            "git@github.com" = {
              hostname = "github.com";
              user = "git";
              identityFile = "~/.ssh/id-${username}-github";
            };
            K-Thinkpad = {
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
          };
        };

      services.ssh-agent = {
        enable = true;
      };
    };
  };
}
