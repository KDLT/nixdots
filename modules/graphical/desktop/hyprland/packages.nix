{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  hyprlandConfig = config.kdlt.graphical.hyprland;
  username = config.kdlt.username;
in {
  config = mkIf hyprlandConfig.enable {
    environment.systemPackages = with pkgs; [
      egl-wayland

      polkit-kde-agent # popup when an app wants elevated privilege

      # qt compatibility, note: dc-tec has these in home.packages
      qt5.qtwayland
      qt6.qtwayland
    ];

    home-manager.users.${username} = {...}: {
      home.packages = with pkgs; [
        waybar # status bar
        #swaybg # wallpaper
        swww # wallpaper
        swayidle # idle timeout
        swaylock # screen lock
        wlogout # logout menu
        hyprpicker # color picker
        wl-clipboard # copy, paste

        hyprshot # screenshot
        grim # full screenshot, too?
        slurp # region screenshot
        wf-recorder # screen recording

        mako # notification daemon, dunst alt
        yad # gui dialog for shell scripts

        # audio
        alsa-utils # provides alsamixer
        mpd # system sounds
        mpc-cli # command line mpd client
        ncmpcpp # mpd client with ui
        networkmanagerapplet # gui app for gnome?! nm-connection-editor
      ];
    };
  };
}
