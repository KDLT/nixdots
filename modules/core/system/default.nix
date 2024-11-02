{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Where most declarations from configuration.nix reside, e.g., timezone, system packages
  options = {
    kdlt = {
      stateVersion = lib.mkOption {
        example = "24.05";
      };
      # these are declared in ../storage/
      # dataPrefix = lib.mkOption {
      #   example = "/data";
      # };
      # cachePrefix = lib.mkOption {
      #   example = "/cache";
      # };
    };
  };

  config = {
    system = {
      stateVersion = config.kdlt.stateVersion;
      # autoUpgrade = {
      #   enable = lib.mkDefault true;
      #   flake = "github:KDLT/dotfiles";
      #   dates = "01/04:00";
      #   randomizedDelaySec = "15min";
      # };
    };

    environment = {
      systemPackages = with pkgs; [
        # ============== nixos ONLY base packages start ==============
        neovim # default editor
        kitty # openGL based terminal emulator
        disfetch # less complex fetching program
        yazi # file explorer
        zsh # shell
        bat # better cat
        eza # modern ls
        just # save & run project specific commands

        ## system call monitoring
        strace
        ltrace
        tcpdump
        lsof

        # ebpf tools, run sandboxed programs in privileged context
        # https://github.com/bpftrace/bpftrace
        bpftrace
        bpftop
        bpfmon

        ## system monitoring
        sysstat
        iotop
        iftop
        btop
        nmon
        sysbench

        # systemtools
        psmisc # killall/pstree/prtstat/fuser etc.
        udiskie # removable disk automounter for udisks
        lm_sensors # tool for reading hardware sensors
        ethtool # network drivers Utility
        pciutils # lspci
        usbutils # lsusb
        hdparm # diskperformance
        dmidecode # reads info about system hardware
        parted # create, resize, destroy, check, copy, disk partitions
        # ============== nixos ONLY base packages end ==============

        # ============== linux base packages start ==============
        # base packages can be used by BOTH nixos and darwin
        git # git

        # archiving
        zip # creating, modifying zip files
        xz # general purpose data compression
        zstd # z standard real time compression algorithm
        unzipNLS # extraction utility for files in zip
        p7zip # p7zip fork with additional codecs

        # text processing
        gnugrep # gnu implementation of unix grep command
        gnused # gnu sed, batch stream editor
        gawk # gnu awk, pattern scanning and processing language
        jq # lightweight, flexible command line JSON processor

        # networking tools
        mtr # network diagnostic tool
        iperf3 # tool to measure ip bandwidth
        dnsutils # domain name server, `dig` + `nslookup`
        ldns # replacement of `dig`, provides command `drill`
        wget # https, http, ftp file retrieval
        curl # cli tool for retrieving file with url syntax
        aria2 # lightweight multi-protocol command line download utility
        socat # bidirectional transfer between 2 independent data channels
        nmap # utility for network discovery and security auditing
        ipcalc # calculator for ipv4/v6 addressess

        # misc
        file # show type of files
        findutils # gnu find utilities, `find`, `xarg`, `locate`, `updatedb`
        which # show full path of command
        tree # depth indented directory listing
        gnutar # gnu implementation of tar archiver
        rsync # fast incremental file transfer utility
        # ============== base modules end ==============

        coreutils
        moreutils
        util-linux
        direnv
        lshw
        whois
        unzip
        age
        sops
        ssh-to-age
        fastfetch
        tlrc
        jdk
        yq
        openssl

        # inputs.nixvim.packages.x86_64-linux.default
      ];

      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
      };
    };

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

    # dbus services that allows applications to update firmware
    services.fwupd.enable = true;

    time.timeZone = "Asia/Manila";

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
