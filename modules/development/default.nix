{
  lib,
  mylib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./ansible
  #   ./aws-cli
  #   ./git
  #   ./go
  #   ./lua
  #   ./powershell
  #   ./python
  #   ./virtualization
  #   ./yaml
  # ];

  # wonder what happens when the packages enable options are already declared here
  options = {
    kdlt.development = {
      # ansible.enable = mkEnableOption "Ansible";
      # aws-cli.enable = mkEnableOption "Aws-cli";
      # azure-cli.enable = mkEnableOption "Azure-cli";
      # git.enable = mkEnableOption "Git";
      # go.enable = mkEnableOption "Go";
      # powershell.enable = mkEnableOption "Powershell";
      # python.enable = mkEnableOption "Python312";
      # virtualization = {
      #   docker.enable = mkEnableOption "Docker";
      #   hypervisor.enable = mkEnableOption "Libvirt/KVM";
      #   k8s.enable = mkEnableOption "k8s tooling";
      # };
      # yamlls.enable = mkEnableOption "Yaml";
    };
  };

  config = {
    kdlt.development = {
      ansible.enable = mkDefault false;
      aws-cli.enable = mkDefault false;
      git.enable = mkDefault true;
      lua.enable = mkDefault true;
      go.enable = mkDefault true;
      powershell.enable = mkDefault false;
      python.enable = mkDefault true;
      yamlls.enable = mkDefault true;
      virtualization = {
        docker.enable = mkDefault false;
        k8s.enable = mkDefault false;
        hypervisor.enable = mkDefault false;
      };
    };
  };
}
