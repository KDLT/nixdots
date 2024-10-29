{
  config,
  lib,
  pkgs,
  hyprlandFlake,
  ...
}:
with lib;
let
  username = config.kdlt.username;
  hyprland = config.kdlt.graphical.hyprland;
  wallpaper = config.kdlt.graphical.wallpaper;
in
{
  options = {
    kdlt.graphical.hyprland.display = mkOption {
      default = "HDMI-A-1, 3840x2160@119.88, 0x0, 1";
      type = types.str;
    };
  };

  config = mkIf hyprland.enable {
    home-manager.users."${username}" =
      { ... }:
      {
        services.cliphist.enable = true;

        wayland.windowManager.hyprland = {
          enable = true;
          # TODO-COMPLETE: check if this would work uncommented, it does but zlogin must be correct
          package = hyprlandFlake.hyprland;
          xwayland.enable = true;
          systemd = {
            enable = true;
            enableXdgAutostart = true;
            # extraCommands = [ ];
          };
          settings = {
            "$mod" = "SUPER"; # GUI key = pinky
            # uncertain if the ${pkgs} is necessary
            "$terminal" = "${pkgs.kitty}/bin/kitty";
            "$browser" = "${pkgs.firefox}/bin/firefox";

            # HID inputs: kb, mouse, touchpad
            input = {
              kb_layout = "us";
              follow_mouse = true;
              touchpad = {
                natural_scroll = true;
              };
              accel_profile = "flat";
              sensitivity = 0;
            };

            # gapss, screen tearing is on allegedly for latencty, jitter reduction
            general = {
              gaps_in = 6;
              gaps_out = 21;
              border_size = 2;
              layout = "dwindle";
              allow_tearing = true;
            };

            cursor = {
              no_hardware_cursors = true; # nvidia hyprland requirement
              enable_hyprcursor = false; # i don't like this cursor
            };

            dwindle = {
              pseudotile = true;
              preserve_split = true;
              # no_gaps_when_only = 0;
              smart_split = false;
              smart_resizing = false;
            };

            # "monitor" = "name,resolution,position,scale";
            # use `hyprctl monitors` for definition
            monitor = [
              # "HDMI-A-1, 3840x2160@119.88, 0x0, 1"
              hyprland.display
            ];

            xwayland.force_zero_scaling = true;

            # decor lifted from dc-tec config
            decoration = {
              rounding = 15;
              active_opacity = 1;
              inactive_opacity = 0.99;
              fullscreen_opacity = 1;

              blur = {
                enabled = true;
                xray = true;
                special = false;
                new_optimizations = true;
                size = 4;
                passes = 1;
                brightness = 1;
                noise = 1.0e-2;
                contrast = 1;
                popups = true;
                popups_ignorealpha = 0.6;
                ignore_opacity = false;
              };

              drop_shadow = true;
              shadow_ignore_window = true;
              shadow_range = 20;
              shadow_offset = "0 2";
              shadow_render_power = 4;
            };

            # animations lifted from dc-tec config
            animations = {
              enabled = true;
              bezier = [
                "linear, 0, 0, 1, 1"
                "md3_standard, 0.2, 0, 0, 1"
                "md3_decel, 0.05, 0.7, 0.1, 1"
                "md3_accel, 0.3, 0, 0.8, 0.15"
                "overshot, 0.05, 0.9, 0.1, 1.1"
                "crazyshot, 0.1, 1.5, 0.76, 0.92"
                "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                "menu_decel, 0.1, 1, 0, 1"
                "menu_accel, 0.38, 0.04, 1, 0.07"
                "easeInOutCirc, 0.85, 0, 0.15, 1"
                "easeOutCirc, 0, 0.55, 0.45, 1"
                "easeOutExpo, 0.16, 1, 0.3, 1"
                "softAcDecel, 0.26, 0.26, 0.15, 1"
                "md2, 0.4, 0, 0.2, 1"
              ];
              animation = [
                "windows, 1, 3, md3_decel, popin 60%"
                "windowsIn, 1, 3, md3_decel, popin 60%"
                "windowsOut, 1, 3, md3_accel, popin 60%"
                "border, 1, 10, default"
                "fade, 1, 3, md3_decel"
                "layersIn, 1, 3, menu_decel, slide"
                "layersOut, 1, 1.6, menu_accel"
                "fadeLayersIn, 1, 2, menu_decel"
                "fadeLayersOut, 1, 4.5, menu_accel"
                "workspaces, 1, 7, menu_decel, slide"
                "specialWorkspace, 1, 3, md3_decel, slidevert"
              ];
            };

            bind = [
              "$mod ALT, Delete, exit"
              "$mod SHIFT, f, exec, $browser"
              "$mod, RETURN, exec, $terminal"
              "$mod ALT, c, killactive"
              "$mod, v, togglefloating"
              "$mod, r, exec, menu"
              "$mod, p, pseudo, # dwindle"
              # "$mod, J, togglesplit, # dwindle"

              # change stack, not working
              # "$mod, z, alterzorder, bottom, activewindow"

              # splitratio, not working
              # "$mod SHIFT, r, splitratio, 70.0"

              # centerwindow
              "$mod SHIFT, b, centerwindow, 1"

              # full screen 0 for entire screen, 1 for retained gaps
              "$mod ALT, f, fullscreen, 1"

              # move focus with hjkl;
              "$mod, h, movefocus, l"
              "$mod, l, movefocus, r"
              "$mod, k, movefocus, u"
              "$mod, j, movefocus, d"

              # swap window
              "$mod ALT, h, swapwindow, l"
              "$mod ALT, l, swapwindow, r"
              "$mod ALT, k, swapwindow, u"
              "$mod ALT, j, swapwindow, d"

              # Screen resize
              "$mod SHIFT, h, resizeactive, -50 0"
              "$mod SHIFT, l, resizeactive, 50 0"
              "$mod SHIFT, k, resizeactive, 0 -30"
              "$mod SHIFT, j, resizeactive, 0 30"

              # switch workspaces
              "$mod, 1, workspace, 1"
              "$mod, 2, workspace, 2"
              "$mod, 3, workspace, 3"
              "$mod, 4, workspace, 4"
              "$mod, 5, workspace, 5"
              "$mod, 6, workspace, 6"
              "$mod, 7, workspace, 7"
              "$mod, 8, workspace, 8"
              "$mod, 9, workspace,9"
              "$mod, 0, workspace, 0"

              # Move to workspaces
              "$mod ALT, 1, movetoworkspace, 1"
              "$mod ALT, 2, movetoworkspace, 2"
              "$mod ALT, 3, movetoworkspace, 3"
              "$mod ALT, 4, movetoworkspace, 4"
              "$mod ALT, 5, movetoworkspace, 5"
              "$mod ALT, 6, movetoworkspace, 6"
              "$mod ALT, 7, movetoworkspace, 7"
              "$mod ALT, 8, movetoworkspace, 8"
              "$mod ALT, 9, movetoworkspace, 9"
              "$mod ALT, 0, movetoworkspace, 0"

              # fuzzel, application search
              "$mod, u, exec, pkill fuzzel || ${pkgs.fuzzel}/bin/fuzzel"

              # # thunar file explorer
              # "$mod ALT, e, exec, [float; center 1; size 50% 50%] ${pkgs.xfce.thunar}/bin/thunar"
              # bind = SUPER, E, exec, [workspace 2 silent; float; move 0 0] kitty

              # yazi file explorer
              # "$mod ALT, e, exec, [float; center 1; size 50% 50%] $terminal --hold -e ${pkgs.yazi}/bin/yazi"
              "$mod ALT, e, exec, [float; center 1; size 50% 50%] $terminal -e ${pkgs.yazi}/bin/yazi"

              # clipboard search
              "$mod ALT, v, exec, pkill fuzzel || cliphist list | fuzzel --match-mode=fzf --dmenu | cliphist decode | wl-copy"

              # screencap entire screen
              "$mod SHIFT, s, exec, ${pkgs.grim}/bin/grim | wl-copy"
              # "$mod SHIFT+ALT, s, exec, ${pkgs.grim}/bin/grim -g ${pkgs.slurp} - | ${pkgs.swappy}/bin/swappy -f -" # fucking broken

              # screencap region, autocopied to clipboard
              "$mod SHIFT, 4, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
            ];

            bindm = [
              "$mod, mouse:272, movewindow"
              "$mod, mouse:273, resizewindow"
            ];

            env = [
              "NIXOS_OZONE_WL,1"
              "MOZ_ENABLE_WAYLAND,1"
              "MOZ_WEBRENDER,1"
              "_JAVA_AWT_WM_NONREPARENTING,1"
              "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
              "QT_QPA_PLATFORM,wayland"
              "SDL_VIDEODRIVER,wayland"
              "GDK_BACKEND,wayland"
              "XDG_SESSION_DESKTOP,Hyprland"
              "XDG_CURRENT_DESKTOP,Hyprland"
            ];

            exec-once = [
              # commented because it doubles with the enable
              # "${pkgs.waybar}/bin/waybar"

              "${pkgs.swww}/bin/swww-daemon"
              "${pkgs.swww}/bin/swww img ${wallpaper}"

              "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"

              # open a kitty and firefox
              "${pkgs.kitty}/bin/kitty"
              "${pkgs.firefox}/bin/firefox"
            ];
          };

          plugins = [
            # hyprlock
            # hyprlandPlugins.hyprbars
            # hyprlandPlugins.hyprexpo
            # hyprlandPlugins.borders-plus-plus
            # hyprlandPlugins.hyprwinwrap
          ];
        };
      };
  };
}
