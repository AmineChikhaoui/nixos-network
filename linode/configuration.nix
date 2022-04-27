unstablePkgs:

{ config, pkgs, ... }:

{
  imports =
    [ (import ../common/tailscale.nix unstablePkgs.tailscale)
      (import ../common/nix-config.nix unstablePkgs.nixUnstable)

      ../common/hardening.nix
      ../common/users.nix

      ./hardware-configuration.nix
      ../common/prometheus.nix
      ./thelounge.nix

      # self hosted kubernetes experiments
      # ./kubernetes.nix

      ./networking.nix
      ./webserver.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.timeout = 10;

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    wget vim inetutils
    mtr sysstat lsof
  ];

  system.stateVersion = "18.09";

}
