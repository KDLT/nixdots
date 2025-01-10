{
  config,
  lib,
  stateVersion,
  pkgs,
  ...
}:
let
  laptop = config.kdlt.core.laptop;
  server = config.kdlt.core.server;
in
{
  config = {
    system = {
      stateVersion = stateVersion;
      # autoUpgrade = {
      #   enable = lib.mkDefault true;
      #   flake = "github:KDLT/dotfiles";
      #   dates = "01/04:00";
      #   randomizedDelaySec = "15min";
      # };
    };

    environment.variables = {
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
    };

    # these packages are ONLY compatible with nixos
    environment.systemPackages = with pkgs; [
      # ============== nixos ONLY base packages start ==============
      firefox # web browser i use
      disfetch # less complex fetching program
      age # modern encryption tool with small explicit keys LINUX only
      jdk # open source java development kit LINUX only
      lshw # provide detailed info on hardware config of machine LINUX only
      ssh-to-age # convertsssh private keys in ed25519 format to age keys LINUX only
      ventoy # endgame bootable usb

      # networking tools
      dnsutils # `dig` + `nslookup`
      wget # https, http, ftp file retrieval
      curl # cli tool for retrieving file with url syntax
      aria2 # A lightweight multi-protocol & multi-source command-line download utility

      # system monitoring
      sysstat # performance monitoring tools for linux

      # system tools
      usbutils # lsusb

      ## system call monitoring
      ltrace # library call tracer LINUX only
      strace # diagnostcic, instructional and debuggin tool for linux kernel

      # ebpf tools, run sandboxed programs in privileged context
      # https://github.com/bpftrace/bpftrace
      bpftrace # high level tracing language for linux eBPF
      bpftop # dynamic real time view of running eBPF programs
      bpfmon # BPF based visual packet rate monitor

      ## system monitoring
      iotop # tool to find the processes doing the most IO
      nmon # AIX & Linux performance monitoring tool

      # systemtools
      psmisc # killall/pstree/prtstat/fuser etc.
      udiskie # removable disk automounter for udisks
      lm_sensors # tool for reading hardware sensors
      ethtool # network drivers Utility
      hdparm # diskperformance
      dmidecode # reads info about system hardware
      parted # create, resize, destroy, check, copy, disk partitions
      # ============== nixos ONLY base packages end ==============

      # inputs.nixvim.packages.x86_64-linux.default
    ];

    # declared in ../../../base/system.nix
    # time.timeZone = "Asia/Manila";

    security = {
      sudo.enable = true;
      doas = {
        enable = true;
        extraRules = [
          {
            # these users would not be required to enter passwords
            users = [ "${config.kdlt.username}" ];
            noPass = true;
          }
        ];
      };
      polkit.enable = true;
    };

    # laptop behavior when interacting with lid and switch
    services.logind = lib.mkIf laptop {
      lidSwitch = if server then "ignore" else "halt"; # not plugged in
      lidSwitchDocked = if server then "ignore" else "suspend"; # when external display is connected
      lidSwitchExternalPower = if server then "ignore" else "lock"; # when plugged in
      powerKey = "ignore";
      powerKeyLongPress = "reboot";
    };

    # dbus services that allows applications to update firmware
    services.fwupd.enable = true;

    i18n = {
      defaultLocale = "en_PH.UTF-8";
      extraLocaleSettings = {
        LC_ALL = "en_US.UTF-8";
        LANGUAGE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };
  };
}
