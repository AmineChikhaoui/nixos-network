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
  };
}
