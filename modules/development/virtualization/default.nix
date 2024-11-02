{
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./docker.nix
  #   ./hypervisor.nix
  #   ./k8s.nix
  # ];
}
