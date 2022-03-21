unstablePkgs:

{ pkgs, ... }:
{
  nixpkgs.system = "aarch64-linux";

  imports = [
    ./hardware-configuration.nix
    (import ../common/tailscale.nix unstablePkgs.tailscale)

    ../common/hardening.nix
    ../common/users.nix
    ../common/prometheus.nix

    ./grafana.nix
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2015-12.com.oracleiaas:b6ebb177-c78e-419e-a0d0-cea7de74324d";
  };

  environment.systemPackages =
    with pkgs; [ vim file bind mtr htop ];

  boot.cleanTmpDir = true;

  nix = {
    package = unstablePkgs.nixUnstable;

    extraOptions = ''
      experimental-features = flakes nix-command
    '';
  };

  networking.hostName = "watchdog";

}
