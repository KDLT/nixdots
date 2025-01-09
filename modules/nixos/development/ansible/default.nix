# ~/dotfiles/modules/development/ansible/default.nix
{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  options = {
    kdlt.development = {
      ansible.enable = lib.mkEnableOption "Ansible";
    };
  };

  config = lib.mkIf config.kdlt.development.ansible.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = with pkgs; [
        ansible
        ansible-builder
        ansible-lint
      ];
    };
  };
}
