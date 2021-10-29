{ lib, ... }:
{

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  networking = {
    enableIPv6 = false;
    useDHCP = false;
    usePredictableInterfaceNames = false;

    # enable NAT
    nat.enable = true;
    nat.externalInterface = "eth0";

    domain = "chikhaoui.org";
    hostName = "linode";

    defaultGateway = "50.116.57.1";
    nameservers = [ "8.8.8.8" "1.1.1.1" ];

    interfaces = {
      eth0.ipv4.addresses = [
        { address = "50.116.57.221";
          prefixLength = 24;
        }
      ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
      allowedTCPPorts = [ 80 443 ];
    };
  };

}
