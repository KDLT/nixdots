{ pkgs, username, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # enable touch id authentication
  security.pam.enableSudoTouchIdAuth = true;

  # MacOS System preferences
  system.defaults = {
		dock.autohide = true;
		dock.mru-spaces = false; # do not rearranged spaces based on most recent

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # columns view
      _FXShowPosixPathInTitle = true;  # show full path in finder title
      FXEnableExtensionChangeWarning = false;  # disable warning when changing file extension
      QuitMenuItem = true;  # enable quit menu item
      ShowPathbar = true;  # show path bar
      ShowStatusBar = true;  # show status bar
    };

		loginwindow.LoginwindowText = "Behold, Betlog.";

		screencapture.location = "~/Pictures/screenshots";
		screensaver.askForPasswordDelay = 10;
  };

  # create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.users.${username}.shell = pkgs.zsh; # explicitly set zsh as default shell

	# karabiner is broken as a system service in darwin, use homebrew
	# services.karabiner-elements.enable = false;

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "CommitMono"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };

	environment.shellAliases = {
		v = "nvim";
	};

  environment.variables = {
    EDITOR = "nvim";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # these packages are available to all users
  environment.systemPackages = with pkgs;
    [
      obsidian # the last note taking app
      btop # system monitoring

      # archives
      zip
      xz
      unzip
      p7zip

      disfetch # less complex fetching program
      bat # better cat
      just # save & run project specific commands

      wget
      git

      # utils
      ripgrep # recursively searches directories for regex
      fzf # cli fuzzy finder
      jq # lightweight cli JSON processor
      yq-go # yaml processor

      aria2 # lightweight multi-protocol & multi-source cli download util
      socat # replacement of openbsd-netcat
      nmap # for network discovery, security auditing

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      caddy
      gnupg

      # productivity
      glow # markdown preview in terminal
    ];
}
