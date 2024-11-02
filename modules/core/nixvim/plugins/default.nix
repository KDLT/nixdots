{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./cmp
  #   ./editor
  #   ./git
  #   ./lsp
  #   ./themes
  #   ./ui
  #   ./utils
  # ];
}
