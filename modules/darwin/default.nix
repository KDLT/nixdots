{ config, username, ... }:
{
  imports = [
    ./bundles
    ./home
    ./homebrew
    ./networking
    ./nix
    ./system
  ];
}
