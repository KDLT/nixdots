{
  mylib,
  lib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  config = {
    kdlt.development.virtualization = {
      docker.enable = lib.mkDefault false;
      k8s.enable = lib.mkDefault false;
      hypervisor.enable = lib.mkDefault false;
    };
  };
}
