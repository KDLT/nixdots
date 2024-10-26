# ~/dotfiles/modules/core/sops/default.nix
{config, ...}: let
  username = config.kdlt.username;
  userhome = "/home/" + config.kdlt.username;
  hostname = config.networking.hostName;
in {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml"; # YAML is the default

    age = {
      keyFile = userhome + "/.config/sops/age/keys.txt";
      sshKeyPaths = [
        # "/data/etc/ssh/ssh_host_ed25519_key"
        (userhome + "/.ssh/id_25519_K-Super")
      ];
      generateKey = true;
    };

    secrets = {};
  };
}
# _: {
#   age = {
#     keyFile = "/home/roelc/.config/sops/age/keys.txt";
#     sshKeyPaths = [
#       "/data/etc/ssh/ssh_host_ed25519_key"
#     ];
#     generateKey = true;
#   };
#
#   secrets = {
#     "users/roelc" = {
#       neededForUsers = true;
#     };
#
#     "users/root" = {
#       neededForUsers = true;
#     };
#
#     wireless = {};
#
#     "authorized_keys/root" = {
#       path = "/root/.ssh/authorized_keys";
#     };
#
#     "authorized_keys/roelc" = {
#       path = "/home/roelc/.ssh/authorized_keys";
#       owner = "roelc";
#     };
#   };
# }

