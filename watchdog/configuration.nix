unstablePkgs:

{ pkgs, ... }:
{
  nixpkgs.system = "aarch64-linux";

  imports = [
    ./hardware-configuration.nix
    (import ../common/tailscale.nix unstablePkgs.tailscale)

    ../common/hardening.nix
    ../common/users.nix

    ./grafana.nix
  ];

  environment.systemPackages =
    with pkgs; [ vim file bind mtr ];

  boot.cleanTmpDir = true;

  networking.hostName = "watchdog";

}
