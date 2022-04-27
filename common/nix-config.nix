nixUnstable:

{ config, pkgs, lib, ... }:

{
  nix  = {
    package = nixUnstable;

    extraOptions = ''
      experimental-features = flakes nix-command
    '';

    trustedUsers = [ "amine" ];
  };
}
