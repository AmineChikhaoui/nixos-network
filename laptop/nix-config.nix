nixUnstable:

{ config, pkgs, lib, ... }:

{
  nix  = {
    package = nixUnstable;

    useSandbox = "relaxed";
    extraOptions = ''
      experimental-features = flakes nix-command
      include logicblox.conf
    '';
    trustedUsers = [ "amine" ];

    buildMachines = [
      # aarch64 Oracle Cloud box
      { hostName = "watchdog"; # requires tailscale managing resolv.conf
        maxJobs = 4;
        sshKey = "/home/amine/.ssh/id_ed25519";
        sshUser = "root";
        system = "aarch64-linux";
      }
    ];
  };
}
