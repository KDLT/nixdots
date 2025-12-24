{ username, lib, ... }:
{
  homebrew = {
    enable = true;

    onActivation.autoUpdate = false;
    onActivation.cleanup = "zap"; # 'zap': uninstalls all formulae(and related files) not listed here.

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    # `mas search "app name"` -> use the 10-digit code from the first column
    masApps = {
      Tailscale = 1475387142; # this is version 1.78.1 because the more recent on does nothing
      "Proton Pass for Safari" = 6502835663;
      # "Proton Pass" = 6443490629; # no native mac app store version, cask cannot autofill so manual install
      "DaVinci Resolve" = 571213070; # free version, version 19.1.2, 1.94GB
      # "CapCut - Photo & Video Editor" = 1500855883; # temporarily disable
    };

    taps = [
      # "homebrew/services" # deprecated, now included in brew
      "nikitabobko/tap" # this tap declaration here allows the aerospace cask to be "found"
    ];

    # `brew install`
    brews = [
      # Usage:
      #  https://github.com/tailscale/tailscale/wiki/Tailscaled-on-macOS#run-the-tailscaled-daemon
      # 1. `sudo tailscaled install-system-daemon`
      # 2. `tailscale up --accept-routes`
      # "tailscale" # tailscale # i prefer the official app

      "mas" # mac app store utility
      "gemini-cli" # gemini-cli

      # https://github.com/rgcr/m-cli
      "m-cli" #  Swiss Army Knife for macOS
      # "proxychains-ng" # proxy to obfuscate internet traffic, yet to learn

      # "colima" # for containers--requires docker cask for macOS -> moved to darwin/development/default.nix
      "terminal-notifier" # send macOS notifications from command line
    ];

    # `brew install --cask` are GUI apps
    casks = [
      "aldente" # menu bar tool to limit battery charging percentage
      "affinity" # affinity studio for MacOS

      # proton
      "proton-mail"
      "proton-drive"
      "protonvpn"
      # "proton-pass" # no native mac app store version, cask cannot autofill so manual install

      # macOS sanity
      "karabiner-elements" # sane remaps for ANSI keyboard
      "firefox" # my preferred browser
      "backdrop" # test animated wallpapers

      # IM & audio & remote desktop & meeting
      "telegram" # messaging app allegedly focused on speed and security
      "discord" # desktop app might be too RAM crazy, on probation
      "moonlight" # open source game streaming client https://moonlight-stream.org
      "rustdesk" # fast open-source remote access software https://rustdesk.com

      # Misc
      # "shadowsocksx-ng" # proxy tool
      "blender@lts" # 3D creation suite
      "iina" # video player

      # manually add these to login items for auto-start
      # System Settings > General > Login Items & Extensions
      "raycast" # (HotKey: alt/option + space)search, calculate and run scripts(with many plugins)
      "stats" # beautiful system status monitor in menu bar
      "aerospace" # this is an unknown cask, nikitabobko/tap has to be declared for this to work

      # 3D Printing
      "orcaslicer"
      "superslicer"
      "autodesk-fusion"

      # "reaper"  # audio editor
      # "sonic-pi" # music programming
      # "neteasemusic" # music

      # Development
      "docker-desktop" # previously docker
      "claude-code" # i prefer brew install over npm
      # "mitmproxy" # HTTP/HTTPS traffic inspector
      # "insomnia" # REST client
      # "wireshark" # network analyzer
    ];
  };

  # add this to .zprofile
  # eval "$(/opt/homebrew/bin/brew shellenv)"

  home-manager.users.${username} = {
    # programs.zsh.initExtra = ''
    programs.zsh.initContent = lib.mkOrder 1000 ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

}
