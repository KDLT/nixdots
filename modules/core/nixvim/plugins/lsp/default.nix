{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./lsp.nix
  #   ./conform.nix
  # ];
}
