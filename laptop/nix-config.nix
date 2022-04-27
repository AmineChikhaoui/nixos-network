{ config, pkgs, lib, ... }:

{
  nix  = {
    useSandbox = "relaxed";
    extraOptions = ''
      experimental-features = flakes nix-command
      include logicblox.conf
    '';
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
