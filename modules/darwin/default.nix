{ config, username, ... }:
{
  imports = [
    ./bundles
    ./development
    ./home
    ./homebrew
    ./nix
    ./system
  ];
}
