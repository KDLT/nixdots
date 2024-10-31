{ mylib, ... }: # looks like the triple dot syntax is required
{
  imports = mylib.scanPaths ./.;
}
