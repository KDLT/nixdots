{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.kdlt.darwin.bundles.interface;
in
{
  options.kdlt.darwin.bundles.interface.enable = lib.mkEnableOption ''
    macOS desktop interface layer: aerospace tiling WM (+ its config),
    kitty, karabiner-elements, raycast, stats, jankyborders, and the
    window/space `system.defaults` those depend on'';

  config = lib.mkIf cfg.enable {
    homebrew = {
      taps = [
        {
          name = "nikitabobko/tap"; # required for the aerospace cask
          trusted = true; # required since Homebrew 6.0.0's HOMEBREW_REQUIRE_TAP_TRUST default
        }
      ];
      casks = [
        "karabiner-elements" # sane remaps for ANSI keyboard
        "raycast" # launcher (HotKey: alt/option + space)
        "stats" # menu-bar system monitor
        "aerospace" # tiling WM -- unknown cask, needs nikitabobko/tap
      ];
    };

    # aerospace border highlighter
    services.jankyborders = {
      enable = true;
      style = "round";
      hidpi = true;
      blur_radius = 5.0;
      active_color = "0xCC4C99F4"; # 50% alpha is CC
      inactive_color = "0xff414550";
    };

    # config aerospace via home-manager + homebrew, not the nix-darwin service
    services.aerospace.enable = false;

    # system defaults that exist for aerospace / tiling
    system.defaults = {
      dock.expose-group-apps = true; # prevents aerospace tiny mission-control windows
      spaces.spans-displays = false; # keep the menu bar on the built-in display
      CustomUserPreferences.".GlobalPreferences" = {
        AppleSpacesSwitchOnActivate = true; # follow an app to its space on activate
      };
    };

    environment.shellAliases.aero = "cat ~/.config/aerospace/aerospace.toml";

    home-manager.users.${username} = {
      xdg.configFile."aerospace" = {
        source = ./aerospace.toml;
        target = "aerospace/aerospace.toml"; # relative to $XDG_CONFIG_HOME
      };

      programs.kitty = {
        enable = true;
        font.name = "CommitMono Nerd Font";
        # theme list: https://github.com/kovidgoyal/kitty-themes/tree/master/themes
        themeFile = "Catppuccin-Mocha";
        settings = {
          font_size = 20;
          window_padding_width = 12;
          background_opacity = "0.95";
          background_blur = 20;
          hide_window_decorations = "titlebar-only";
          # darker than stock Catppuccin-Mocha (#1E1E2E)
          background = "#14141F";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
        };
      };
    };
  };
}
