{
  username,
  userfullname,
  lib,
  ...
}:
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

  # My main machine: everything on.
  kdlt.darwin.bundles = {
    interface.enable = true;
    proton.enable = true;
    creative.enable = true;
    printing3d.enable = true;
    chat.enable = true;
    dev.enable = true;
  };

  homebrew.casks = [
    "docker-desktop" # docker engine (K-MBA uses the CLI formula instead)

    # not yet sorted into a bundle -- K-MBP-only for now
    "google-gemini"
    "shottr" # screenshot tool
    "superwhisper" # AI voice dictation
  ];

  # keeping the Mac App Store Tailscale alongside the daemon (networking module)
  homebrew.masApps = {
    Tailscale = 1475387142; # v1.78.1 -- newer versions do nothing
  };
}
