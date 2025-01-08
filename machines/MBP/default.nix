{ username, userfullname, lib, ...}:
let
  hostname = "K-MBP";
in
{
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  # User has to be defined before any of the darwin settings
  users.users.${username} = {
    home = "/Users/${username}";
    description = userfullname;
  };
}
