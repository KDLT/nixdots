{ pkgs, username, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # enable touch id authentication
  # security.pam.enableSudoTouchIdAuth = true; # deprecated syntax
  security.pam.services.sudo_local.touchIdAuth = true;

  # new declaration to continue using system defaults
  system.primaryUser = "kba";

  # MacOS System preferences
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false; # do not show recent apps in dock
      mru-spaces = false; # do not rearrange spaces based on most recent
      expose-group-apps = true; # prevents aerospace from having tiny mission control windows
    };

    controlcenter = {
      AirDrop = false;
      Bluetooth = false;
      Display = false;
      FocusModes = false;
      NowPlaying = false;
      Sound = false;
    };

    finder = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv"; # columns view
      _FXShowPosixPathInTitle = true; # show full path in finder title
      FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
      QuitMenuItem = true; # enable quit menu item
      ShowPathbar = true; # show path bar
      ShowStatusBar = true; # show status bar
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true; # folders will be the first items listed
      FXDefaultSearchScope = "SCcf"; # finder will default to searching within current directory
    };

    NSGlobalDomain = {
      # defaults
      "com.apple.keyboard.fnState" = true; # trigger f1, f2, etc. by default

      # Appearance
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3; # 3 is full control allegedly
      ApplePressAndHoldEnabled = true; # enable press and hold

      # how long key has to be held before starting to repeat
      InitialKeyRepeat = 15; # default 15 (225 ms)
      # sets how fast the repetition happens
      KeyRepeat = 3; # default 3, i want it fast

      NSAutomaticCapitalizationEnabled = false; # disable auto capitalization
      NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution
      NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution
      NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution
      NSAutomaticSpellingCorrectionEnabled = false; # disable auto spelling correction
      NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    # settings that nix-darwin cannot modify directly
    # this uses macOS `defaults` commands:
    # https://github.com/yannbertrand/macos-defaults
    CustomUserPreferences = {
      ".GlobalPreferences" = {
        # automatically switch to a new space when switching to the application
        AppleSpacesSwitchOnActivate = true;
      };

      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
      };

      "com.apple.desktopservices" = {
        # avoid creating .DS_Store files on network or USB volumes
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };
    };

    # CustomSystemPreferences = {
    #   "com.apple.controlcenter" = {
    #     "NSStatusItem Visible WiFi" = 1;
    #     "NSStatusItem Visible Sound" = 1;
    #     "NSStatusItem Visible NowPlaying" = 1;
    #     "NSStatusItem Visible Facetime" = 1;
    #     "NSStatusItem Visible Clock" = 1;
    #     "NSStatusItem Visible Bluetooth" = 1;
    #     "NSStatusItem Visible BentoBox" = 1;
    #     "NSStatusItem Visible Battery" = 1;
    #     "NSStatusItem Visible AudioVideoModule" = 1;
    #   };
    # };

    screencapture = {
      location = "~/Pictures/screenshots"; # this won't create the directory for you
      type = "png";
      disable-shadow = true; # default is false, i don't like drop shadow on screenshots
    };

    screensaver.askForPassword = true;
    screensaver.askForPasswordDelay = 10; # number of seconds in screensaver before having to reenter password

    spaces.spans-displays = false; # true means one space spans across all physical displays
    # i set it to false because i want to retain the menu bar in the built-in display

    WindowManager = {
      HideDesktop = false;
      StandardHideWidgets = true; # i don't like widgets
      StandardHideDesktopIcons = false;
      EnableStandardClickToShowDesktop = false; # click wallpaper to reveal desktop, disabled
    };

    loginwindow.LoginwindowText = "Behold, Betlog.";
  };

  # create /etc/zshrc that loads the nix-darwin environment
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.users.${username}.shell = pkgs.zsh; # explicitly set zsh as default shell

  # karabiner is broken as a system service in darwin, use homebrew
  # services.karabiner-elements.enable = false;

  # Fonts
  fonts.packages = with pkgs; [
    # icon fonts
    material-design-icons
    font-awesome

    # new nerdfonts (darwin 25.05)
    nerd-fonts.fira-code
    nerd-fonts.commit-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka

    # nerdfonts
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/pkgs/data/fonts/nerdfonts/shas.nix
    # (nerdfonts.override {
    #   fonts = [
    #     # symbols icon only
    #     "NerdFontsSymbolsOnly"
    #     # Characters
    #     "FiraCode"
    #     "CommitMono"
    #     "JetBrainsMono"
    #     "Iosevka"
    #   ];
    # })
  ];

  services.jankyborders = {
    enable = true;
    style = "round";
    hidpi = true;
    blur_radius = 5.0;
    # active_color = "0xff4C99F4";
    active_color = "0xCC4C99F4"; # 50% alpha is CC
    inactive_color = "0xff414550";
  };

  environment.shellAliases = {
    v = "nvim";
    ta = "tmux a";
    aero = "cat ~/.config/aerospace/aerospace.toml";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # List packages installed in MacOS system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # these packages are available to all users
  environment.systemPackages = with pkgs; [
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

    git

    # utils
    ripgrep # recursively searches directories for regex
    fzf # cli fuzzy finder
    jq # lightweight cli JSON processor
    yq-go # yaml processor

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
