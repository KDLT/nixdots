{ ... }:
{
  # Tailscale runs as a system daemon on every Darwin host -- it is how the
  # machines reach each other. Auto-starts on boot; no GUI app or login
  # session needed. One-time per machine after first switch:
  #   sudo tailscale up --ssh
  services.tailscale.enable = true;
}
