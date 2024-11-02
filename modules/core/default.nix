{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./connectivity
  #   ./font
  #   ./home-manager
  #   ./nix
  #   ./nixvim
  #   ./shells
  #   ./sops
  #   ./system
  #   ./users
  #   ./utils
  # ];
}
