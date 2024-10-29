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
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.core.persistence.enable {
    #     homeDataLinks = [
    #       {
    #         directory = ".ssh";
    #         mode = "0700";
    #       }
    #     ];
    #     systemDataLinks = [
    #       {
    #         directory = "/root/.ssh/";
    #         mode = "0700";
    #       }
    #     ];
    #   })
    #   (lib.mkIf (!config.kdlt.core.persistence.enable))
    # ];

    home-manager.users.${username} = {
      programs.ssh =
        let
          defaultIdentity = "~/.ssh/id-${username}-ed25519";
        in
        {
          enable = true;
          userKnownHostsFile = "${username}/home/.ssh/known_hosts";
          hashKnownHosts = true; # hashes the known contents of know_hosts file

          extraOptionOverrides = {
            AddKeysToAgent = "yes";
            IdentityFile = defaultIdentity;
          };

          # i think these are unnecessary whether or not impermanence is activated
          # on account of how, on my config by default, the ~/.ssh directory persists
          # IdentityFile =
          #   if
          #     config.kdlt.storage.impermanence.enable
          #   # then "${dataPrefix}/home/${username}/.ssh/id_ed25519"
          #   then
          #     "${dataPrefix}/home/${username}/.ssh/id_ed25519_K-Super"
          #   # else "${username}/home/.ssh/id_rsa_K-Super";
          #   else
          #     "${username}/home/.ssh/id_ed25519_K-Super";

          # matchBlocks is per Host settings similar to how ~/.ssh/config is
          # Since I am setting this up for multiple machines, I am going for
          # a standard identityFile naming scheme: id-kba-ed25519
          matchBlocks = {
            "git@github.com" = {
              hostname = "github.com";
              user = "git";
              identityFile = "~/.ssh/id-${username}-github";
            };
            K-Nixpad = {
              hostname = "192.168.1.54";
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
