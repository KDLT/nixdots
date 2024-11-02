{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./lazygit.nix
  #   ./gitsigns.nix
  # ];
}
