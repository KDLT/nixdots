{ lib, ... }:
{
	# modules/darwin/nix/default.nix
  # Necessary for using flakes on this system.
  nix.settings = {
    experimental-features = "nix-command flakes";
    # Disable auto-optimise-store due to issue:
    # https://github.com/NixOS/nix/issues/7273
    # cannot link '/nix/store/.tmp-link'...
		auto-optimise-store = false;
  };

	# Auto upgrade nix package and the daemon service.
	services.nix-daemon.enable = true;
	# If the daemon service shouldn't be auto managed, uncomment this
	#nix.useDaemon = true;

	# do garbage collection weekly to keep disk usage low
	nix.gc = {
		automatic = lib.mkDefault true;
		options = lib.mkDefault "--delete-older-than 7d";
	};

	# Allow Unfree packages
	nixpkgs.config.allowUnfree = true;
}
