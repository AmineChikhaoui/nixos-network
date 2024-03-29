{ pkgs, lib, ... }:

{

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 7700 8000 ];

    enableIPv6 = true;

    #resolvconf.extraOptions = [ "rotate" ];

    nameservers = lib.mkOverride 0 [
      "8.8.8.8" # Google
      "100.100.100.100" # Tailscale
      "1.1.1.1" # Cloudflare
    ];

    firewall.checkReversePath = false;
  };
}
