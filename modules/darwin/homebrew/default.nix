{username, ...}:
{
  homebrew = {
    enable = true;

    onActivation.autoUpdate = false;
    onActivation.cleanup = "zap"; # 'zap': uninstalls all formulae(and related files) not listed here.

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # proton-pass-password-manager = 6443490629;
    };

    taps = [
      "homebrew/services"
    ];

    # `brew install`
    brews = [
      # Usage:
      #  https://github.com/tailscale/tailscale/wiki/Tailscaled-on-macOS#run-the-tailscaled-daemon
      # 1. `sudo tailscaled install-system-daemon`
      # 2. `tailscale up --accept-routes`
      "tailscale" # tailscale
      "mas" # mac app store utility

      "wget" # https, http, ftp file retrieval
      "curl" # cli tool for retrieving file with url syntax
      "aria2" # A lightweight multi-protocol & multi-source command-line download utility
      "httpie" # user friendly curl replacement

      # https://github.com/rgcr/m-cli
      "m-cli" #  Swiss Army Knife for macOS
      # "proxychains-ng" # proxy to obfuscate internet traffic, yet to learn

      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"
    ];

    # `brew install --cask` are GUI apps
    casks = [
      "karabiner-elements" # sane remaps for ANSI keyboard
      # { # testing what happens when home-manager AND homebrew installs kitty
      #   name = "kitty";
      #   args = { appdir = "~/Applications"; };
      # }
      "firefox" # my preferred browser
      # "google-chrome" # give me reason
      # "visual-studio-code" # give me a reason, too
      "zed" # zed editor, i'm zed curious
      "nikitabobko/tap/aerospace" # an i3-like tiling window manager for macOS
      "hot" # menu bar app to display cpu temps

      # https://joplinapp.org/help/
      # "joplin" # note taking app

      # IM & audio & remote desktop & meeting
      "telegram" # messaging app allegedly focused on speed and security
      "discord" # desktop app might be too RAM crazy, on probation
      "moonlight" # open source game streaming client https://moonlight-stream.org
      "rustdesk" # fast open-source remote access software https://rustdesk.com

      # Misc
      # "shadowsocksx-ng" # proxy tool
      "blender@lts" # 3D creation suite
      "iina" # video player
      "raycast" # (HotKey: alt/option + space)search, calculate and run scripts(with many plugins)
      "stats" # beautiful system status monitor in menu bar
      # "reaper"  # audio editor
      # "sonic-pi" # music programming
      # "tencent-lemon" # macOS cleaner
      # "neteasemusic" # music

      # Development
      # "mitmproxy" # HTTP/HTTPS traffic inspector
      # "insomnia" # REST client
      # "wireshark" # network analyzer
      # "jdk-mission-control" # Java Mission Control
      # "google-cloud-sdk" # Google Cloud SDK
      # "miniforge" # Miniconda's community-driven distribution
    ];
  };

  # add this to .zprofile
  # eval "$(/opt/homebrew/bin/brew shellenv)"

  home-manager.users.${username} = {
    programs.zsh.initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

}
