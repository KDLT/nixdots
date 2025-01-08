{ config, username, ... }:
{
  imports = [
    ./development
    ./home
    ./homebrew
    ./nix
    ./system
  ];
}
