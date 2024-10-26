# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./persistence.nix
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

  networking = {
    hostName = "Link"; # Define your hostname.
    hostId = "765c4d0e"; # head -c 8 /etc/machine-id
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/kba/dotfiles"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # /data does not get rolled back on boot
  environment.etc = {
    # persistence for network connections
    "NetworkManager/system-connections" = {
      source = "/data/etc/NetworkManager/system-connections/";
    };
  };

  # persistence for ssh keys
  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/data/ssh/ssh_host_K-Link_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/data/ssh/ssh_host_K-Link_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
  # persistence for bluetooth devices
  systemd.tmpfiles.rules = [
    # L creates symlink, from target path to destination?
    "L /var/lib/bluetooth - - - - /data/var/lib/bluetooth"
  ];

  programs.git.enable = true;

  programs.fuse.userAllowOther = true;
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      kba =
        { ... }:
        {
          programs.home-manager.enable = true;

          xdg = {
            enable = true;
            userDirs.enable = true;
            userDirs.createDirectories = true;
          };

          home = {
            stateVersion = "24.05";
            packages =
              with pkgs;
              [
                onefetch
                disfetch
                zoxide
                zsh
              ]
              ++ [
                inputs.nixvim.packages.${pkgs.system}.default
              ];
            sessionVariables = {
              EDITOR = "nvim";
            };
          };

          programs.git = {
            enable = true;
            userEmail = "aguirrekenneth@gmail.com";
            userName = "kba";
            extraConfig = {
              init.defaultBranch = "main";
            };
          };

          programs.zoxide.enable = true;
          programs.zsh.enable = true;
        };

      root = _: {
        home.stateVersion = "24.05";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kba = {
    isNormalUser = true;
    home = "/home/kba";
    description = "Kenneth B. Aguirre";
    initialPassword = "123456";
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      bat
      btop
      zsh
      zoxide
    ];
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Manila";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.printing.enable = true;

  hardware = {
    # Enable sound.
    pulseaudio.enable = false;
    # pulseaudio.enable = true;

    # enable bluetooth
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

  # bluetooth control
  services.blueman.enable = true;

  # more sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.playerctld.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    yazi
    git
    kitty
    firefox
    wget
    pavucontrol
  ];

  programs.neovim.defaultEditor = true;
}
