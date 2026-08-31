{
  username,
  userfullname,
  lib,
  ...
}:
let
  hostname = "K-MBA";
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

  # --- First-bring-up safety net for this machine only ---
  # This machine had pre-existing, non-nix-managed dotfiles (zsh, kitty,
  # aerospace) before adopting nixdots. Rather than failing activation on
  # collision, rename the existing file aside instead of erroring out.
  # Check ~/.config/{zsh,kitty,aerospace}/*.hm-bak after first switch and
  # delete them once you've confirmed you don't need anything from them.
  home-manager.backupFileExtension = "hm-bak";

  # This machine's Nix was installed via the Determinate installer, which runs
  # its own daemon (determinate-nixd) to manage the Nix install. nix-darwin
  # refuses to activate if it also thinks it owns the install (its default),
  # so hand that management fully to Determinate. K-MBP wasn't installed via
  # Determinate, so it doesn't need this override.
  # Side effect: modules/darwin/nix/default.nix's `nix.settings`/`nix.gc`
  # become no-ops here (nix-darwin no longer writes /etc/nix/nix.conf) --
  # Determinate already ships flakes+nix-command enabled by default, but
  # scheduled garbage collection isn't set up; run `nix-collect-garbage -d`
  # manually now and then, or configure it via Determinate's own tooling.
  nix.enable = false;

  # nix-darwin asserts nix.gc.automatic requires nix.enable, and
  # modules/darwin/nix/default.nix turns gc.automatic on by default.
  # Run `nix-collect-garbage -d` by hand periodically instead (or set up gc
  # through Determinate's own tooling).
  nix.gc.automatic = lib.mkForce false;

  # --- Bundles ---
  # Primarily headless/remote, but keeps interface parity with K-MBP so it
  # is usable when sat in front of. No creative / printing3d / chat here.
  kdlt.darwin.bundles = {
    interface.enable = true;
    proton.enable = true;
    dev.enable = true;
  };

  # --- This machine's extra Homebrew, on top of the always-on layer and the
  # bundles above. Every entry is deliberate. ---
  homebrew.brews = [
    "docker" # docker engine as the CLI formula (K-MBP uses docker-desktop)
    "transmission-cli"
  ];

  homebrew.casks = [
    # AI assist beyond the always-on claude-code
    "claude"
    "antigravity"
    "antigravity-cli"
  ];

  # --- Remote access ---
  # tailscaled runs as a LaunchDaemon via modules/darwin/networking (shared by
  # all Darwin hosts). No Mac App Store Tailscale.app here -- it is sandboxed
  # and needs a live GUI login session, which a headless machine will not have.
  # One-time setup after first switch: `sudo tailscale up --ssh`.
}
