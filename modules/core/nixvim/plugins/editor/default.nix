{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
}