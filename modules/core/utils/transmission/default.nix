{ pkgs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      # version 4 does not have declarative configuration
      # transmission_4-gtk
      # transmission_4-qt

      # these are version 3, supports declarative configs
      transmission-gtk
      # transmission-qt # opt for gtk
    ];

    ## these are nixos wiki defaults, pending setup
    # services.transmission = {
    #   enable = true; # enable transmission daemon
    #   openRPCPort = true; # open firewall for rpc
    #   settings = {
    #     rpc-bind-address = "0.0.0.0"; # bind to own ip
    #     rpc-whitelist = "127.0.0.1,192.168.1.57,192.168.1.38"; # whitelist local device access
    #   };
    # };
  };
}
