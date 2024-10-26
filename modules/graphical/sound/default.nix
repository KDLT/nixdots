{
  config,
  lib,
  pkgs,
  ...
}: let
  username = config.kdlt.username;
in {
  options = {
    kdlt = {
      graphical.sound = lib.mkEnableOption "Sound On?";
    };
  };

  config = lib.mkIf config.kdlt.graphical.sound {
    security.rtkit.enable = true;

    # my guess is this creates a custom module that can be found in
    # /etc/wireplumber/bluetooth.lua.d/51-bluez-config.lua
    environment.etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
        }
      '';
    };

    hardware = {
      pulseaudio.enable = false; # true in the lifted config
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Control,Gateway,Headset,Media,Sink,Socket,Source";
            MultiProfile = "multiple";
          };
        };
      };
    };
    services.blueman.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # jack.enable = true;
      # media-session.enable = true;
    };

    services.playerctld.enable = true;

    home-manager.users."${username}" = {...}: {
      home.packages = with pkgs; [
        pavucontrol # pulse audio volume control
        playerctl # cli for MPRIS
        pulsemixer # cli and curses for pulseaudio
        imv # cli image viewer for tiling window managers

        nvtopPackages.full # neat videocard top

        cava # console based audio visualizer for alsa
        libva-utils # collection of utilities for libva api
        vdpauinfo
        vulkan-tools
        glxinfo
      ];

      programs = {
        mpv = {
          enable = true;
          defaultProfiles = ["gpu-hq"];
          scripts = [pkgs.mpvScripts.mpris];
        };
      };
    };
  };
}
