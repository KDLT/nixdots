{ mylib, ...}:
{
  imports = mylib.scanPaths ./.;
}
