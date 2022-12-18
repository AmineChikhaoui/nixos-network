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
      { hostName = "dev"; # requires tailscale managing resolv.conf
        maxJobs = 4;
        sshKey = "/home/amine/.ssh/oracle";
        sshUser = "root";
        system = "aarch64-linux";
      }
    ];
  };
}
