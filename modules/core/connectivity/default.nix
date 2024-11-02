{
  mylib,
  ...
}:
{
  imports = mylib.scanPaths ./.;
}
# {...}: {
#   imports = [
#     ./systemd
#     ./wireless
#     ./printing
#   ];
# }
