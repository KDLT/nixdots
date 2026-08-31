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

  # --- K-MBA's own Homebrew list ---
  # Keep Homebrew management on (unlike a full opt-out) so the interface
  # (Aerospace, Kitty, jankyborders, GUI defaults) stays identical to K-MBP.
  # This machine runs primarily headless/remote though, so it gets its own
  # explicit, fully-confirmed brews/casks/masApps/taps -- not K-MBP's list
  # minus some exclusions. Nothing here is inherited by accident; every
  # entry below was explicitly named to stay.
  homebrew.taps = lib.mkForce [
    {
      name = "nikitabobko/tap"; # required for the aerospace cask
      trusted = true;
    }
  ];

  homebrew.brews = lib.mkForce [
    "mas" # mac app store utility -- required for masApps below to install
    "gemini-cli"
    "m-cli" # swiss army knife for macOS
    "terminal-notifier" # send macOS notifications from command line

    # pre-existing on this machine, kept explicitly
    "docker" # CLI/daemon formula (not the docker-desktop GUI cask)
    "transmission-cli"
    # NOTE: brew's "tailscale" formula was dropped in favor of
    # services.tailscale.enable below (nix-managed daemon, auto-starts on
    # boot) -- keeping both would just be two competing tailscaled installs.
  ];

  homebrew.casks = lib.mkForce [
    # proton suite
    "proton-mail"
    "proton-drive"
    "protonvpn"

    # interface parity with K-MBP
    "karabiner-elements"
    "aerospace"

    # productivity
    "raycast"
    "stats"

    # AI assist
    "claude"
    "claude-code"
    "antigravity"
    "antigravity-cli"

    "firefox"

    # utilities
    "vorssaint"
    "aldente"
  ];

  # Explicit, not just inherited from K-MBP's base module: since the list
  # above is now complete and intentional for this machine, let cleanup
  # actually remove/deep-clean anything not in it.
  homebrew.onActivation.cleanup = "zap";

  homebrew.masApps = lib.mkForce {
    Tailscale = 1475387142;
    "Proton Pass for Safari" = 6502835663;
    "Dark Reader for Safari" = 1438243180;
  };

  # --- Remote access ---
  # This machine runs unattended, left at work. Run tailscaled as a proper
  # background LaunchDaemon (auto-starts on boot, no GUI app/login session
  # needed to keep it alive) rather than relying on the Mac App Store
  # Tailscale.app, which is sandboxed and depends on staying logged into a
  # GUI session. Matches how Super/Think/Link already run Tailscale.
  # One-time setup after this switches: `sudo tailscale up --ssh`.
  services.tailscale.enable = true;
}
