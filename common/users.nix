{ config, lib, ... }:
let
  cfg = config.my.users;

  pubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLj6b2NxWaTh2epvC7DynHu//LKb8HOoXW03o2Q1DW8 amine@nixos"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIev7NbkBmKhpF1p2esFG0T+LXuQKCDv+XgE+XpOiB7n"
  ];
in
{
  options = {
    my.users = {
      extraGroups = lib.mkOption {
        default = [];
        type = with lib; types.listOf types.str;
      };

      allowRootPKAccess = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = {
    users.extraUsers = {
      amine = {
        isNormalUser = true;
        name = "amine";
        uid = 1000;
        extraGroups = [ "wheel" ] ++ cfg.extraGroups;
        createHome = true;
        home = "/home/amine";
        shell = "/run/current-system/sw/bin/bash";
        openssh.authorizedKeys.keys = pubKeys;
      };

      root.openssh.authorizedKeys.keys =
        lib.mkIf cfg.allowRootPKAccess pubKeys;
    };

    security.sudo.wheelNeedsPassword = false;

    nix.trustedUsers = [ "amine" ];
  };
}
