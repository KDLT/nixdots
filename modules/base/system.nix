{
  lib,
  pkgs,
  ...
}:
{
  options = {
    kdlt.stateVersion = lib.mkOption {
      example = "24.05";
    };
  };

  config = {
    time.timeZone = "Asia/Manila";

    # these packages are used by BOTH nixos and nix-darwin
    environment.systemPackages = with pkgs; [
      # core tools
      neovim # default editor (vanilla neovim)
      # kitty # openGL based terminal emulator
      fastfetch # info rich fetch
      just # justfile
      zsh # the shell i use
      # nushell # nushell, i don't use nushell
      git # used by nix flakes
      git-lfs # used by huggingface models
      yazi # fast af file explorer
      bat # better cat
      eza # modern ls
      just # save & run project specific commands

      # system tools
      pciutils # lspci

      # archives
      zip # creating, modifying zip files
      xz # general purpose data compression
      zstd # z standard real time compression algorithm
      unzipNLS # extraction utility for files in zip
      # unzip # same definition as unzipNLS, just commenting this out
      p7zip # p7zip fork with additional codecs

      # Text Processing
      # Docs: https://github.com/learnbyexample/Command-line-text-processing
      gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
      gnused # GNU sed, very powerful(mainly for replacing text in files)
      gawk # GNU awk, a pattern scanning and processing language
      jq # A lightweight and flexible command-line JSON processor

      # networking tools
      mtr # A network diagnostic tool
      iperf3 # tool to measure ip bandwidth
      ldns # replacement of `dig`, it provide the command `drill`
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      # ipcalc # it is a calculator for the IPv4/v6 addresses # depends on ruby, gives error on rebuild

      # system monitoring
      iftop # display an interface's bandwidth usage
      btop # resource monitor. C++ version and continuation of bashtop and bpytop
      sysbench # system performance benchmark tool

      # system call monitoring
      tcpdump # command line packet analyzer
      lsof # utility to list open files

      # misc
      file # show type of files
      findutils # gnu find utilities: find, xarg, locate, updatedb
      which # show full path of command
      tree # depth indented directory listing
      gnutar # gnu implementation of tar archiver
      rsync # fast incremental file transfer utility

      coreutils # gnu core utilities
      moreutils # collection of unix tools nobody thought to write long ago when unix was young
      util-linux # set of system utilities for linux
      direnv # shell extension that manages your environment
      whois # intelligent whois client from debian
      sops # editor of encrypted files, for secrets management
      fastfetch # like neofetch but much faster because written in C
      tlrc # official tldr client written in rust
      yq # yaml, json, xml, csv and properties documents from the CLI
      openssl # cryptographic library that implements the ssl and tls protocols

      # moved over from homebrew
      gh # github CLI
      unar # unarchiver
      wget # file retrieval
      curl # url file transfer
      aria2 # download utility
      httpie # user-friendly curl
      fswatch # file system monitor
      yt-dlp # youtube downloader
      ffmpeg # media processing

      # development
      # python3 # python
      nodejs # brew: node
      bun # Incredibly fast JavaScript runtime, bundler, transpiler and package manager
    ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

  };
}
