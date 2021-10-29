{ pkgs, lib, ...}:

{

  networking = {
    networkmanager.enable = true;

    resolvconf.extraOptions = [ "rotate" ];

    search = [
      "logicblox.com"
      "predictix.com"
      "dev.retail.infor.com"
    ];

    nameservers = lib.mkOverride 0  [
      "8.8.8.8" # Google
      "100.100.100.100" # Tailscale
      "1.1.1.1" # Cloudflare
    ];

    firewall.checkReversePath = false;
  };
}
