{
  lib,
  mylib,
  ...
}:
with lib;
{
  imports = mylib.scanPaths ./.;

  config = {
    kdlt.development = {
      ansible.enable = mkDefault false;
      aws-cli.enable = mkDefault false;
      git.enable = mkDefault true;
      lua.enable = mkDefault true;
      go.enable = mkDefault true;
      nodejs.enable = mkDefault false;
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
