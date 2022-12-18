{ config, pkgs, lib, ... }:

{
  sops.secrets = {
    "logicblox.conf" = {
      owner = "amine";
      path = "/etc/nix/logicblox.conf";
    };

#    "logicblox-hologram.json" = {};

    s3-binary-cache = {};
  };

  nix = {
    # Disable due to the sops-nix hackery
    checkConfig = false;

    sandboxPaths = [ "/usr/bin" (toString pkgs.coreutils)];
  };

  systemd.services.nix-daemon.serviceConfig = {
    EnvironmentFile = "${config.sops.secrets.s3-binary-cache.path}";
  };

  # services.hologram-agent = {
  #   enable = true;
  # };

  # systemd.services.hologram-agent.serviceConfig = {
  #   ExecStart = lib.mkForce "${pkgs.hologram}/bin/hologram-agent --debug --conf /run/secrets/logicblox-hologram.json --port ${config.services.hologram-agent.httpPort}";
  # };

}
