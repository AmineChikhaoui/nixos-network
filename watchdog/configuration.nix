unstablePkgs:

{ pkgs, lib, ... }:
{
  nixpkgs.system = "aarch64-linux";

  imports = [
    ./hardware-configuration.nix
    (import ../common/tailscale.nix unstablePkgs.tailscale)
    (import ../common/nix-config.nix unstablePkgs.nixUnstable)

    ../common/hardening.nix
    ../common/users.nix
    ../common/prometheus.nix

    ./grafana.nix
  ];

  services.openssh.enable = lib.mkForce false;

  services.openiscsi = {
    enable = true;
    name = "iqn.2015-12.com.oracleiaas:b6ebb177-c78e-419e-a0d0-cea7de74324d";
  };

  environment.systemPackages =
    with pkgs; [ vim file bind mtr htop ];

  boot.cleanTmpDir = true;

  networking.hostName = "watchdog";

}
