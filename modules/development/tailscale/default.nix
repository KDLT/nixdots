{
  pkgs,
  lib,
  config,
  ...
}:
let
  userName = config.kdlt.username;
  tailscale = config.kdlt.development.tailscale;
  dataPrefix = config.kdlt.storage.dataPrefix;
  impermanence = config.kdlt.storage.impermanence;
in
with lib;
{
  options = {
    kdlt.development = {
      tailscale.enable = mkEnableOption "Tailscale";
    };
  };

  config = mkIf tailscale.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;

    environment.persistence."${dataPrefix}".directories = lib.mkIf impermanence.enable [
      "/var/lib/tailscale/"
    ];

    boot.kernel.sysctl = {
      # enable ipv4 forwarding
      "net.ipv4.ip_forward" = 1;
      # enable ipv6 forwarding
      "net.ipv6.conf.all.forwarding" = 1;
      # optional: enable forwarding for specific ipv6 interfaces
      "net.ipv6.conf.default.forwarding" = 1;
    };

    networking.firewall = {
      # checkReversePath = false; # allow routed traffic
      ## allow traffic for proxmox host via webUI on HTTP/HTTPS ports
      extraCommands = ''
        # ## allow forwarding from tailscale0 to proxmox host on port 8006 (TCP)
        # iptables -A FORWARD -i tailscale0 -d 192.168.1.56 -p tcp --dport 8006 -j ACCEPT
        #
        # ## allow replies from proxmox host back to tailscale0
        # iptables -A FORWARD -o tailscale0 -s 192.168.1.56 -p tcp --sport 8006 -j ACCEPT
        #
        # ## allow forwarding for all related and established conections
        # iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
        #
        # iptables -A FORWARD -i tailscale0 -d 192.168.1.56 -p tcp --dport 22 -j ACCEPT
        # iptables -A FORWARD -i tailscale0 -o wlp3s0 -j ACCEPT
        #
        # ## allow ICMP (ping) forwarding from tailscale0 to proxmox
        # iptables -A FORWARD -i tailscale0 -d 192.168.1.56 -p icmp -j ACCEPT
        # iptables -A FORWARD -o tailscale0 -s 192.168.1.56 -p icmp -j ACCEPT
      '';
    };
  };
}
