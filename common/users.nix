let
  pubKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLj6b2NxWaTh2epvC7DynHu//LKb8HOoXW03o2Q1DW8 amine@nixos
  '';
in
{

  users.extraUsers = {
    amine = {
      isNormalUser = true;
      name = "amine";
      uid = 1000;
      extraGroups = [ "wheel" ];
      createHome = true;
      home = "/home/amine";
      shell = "/run/current-system/sw/bin/bash";
      openssh.authorizedKeys.keys = [ pubKey ];
    };
    root.openssh.authorizedKeys.keys = [ pubKey ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix.trustedUsers = [ "amine" ];

}
