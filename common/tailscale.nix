tailscaleUnstable:

{ pkgs, lib, ... }:
{
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  services.tailscale = {
    enable = true;
    package = tailscaleUnstable;
  };
}
