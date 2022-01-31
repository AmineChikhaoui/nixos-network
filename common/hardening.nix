{ config, lib, ...}:
let
  cfg = config.my.openssh;
in
{
  options = {
    my.openssh.listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config =
    let
      isServerMode =
        if cfg.listenAddress != "" then false
        else true;
    in
    {
      services.fail2ban.enable = lib.mkIf isServerMode true;

      security.auditd.enable = lib.mkIf isServerMode true;
      security.audit = lib.mkIf isServerMode {
        enable = true;
        rules = [
          "-a exit,always -F arch=b64 -S execve"
        ];
      };

      services.openssh = {
        enable = true;
        listenAddresses = lib.mkIf (!isServerMode) [
          { addr = cfg.listenAddress;
            port = 22;
          }
        ];
        passwordAuthentication = false;
        allowSFTP = false;
        challengeResponseAuthentication = false;
        extraConfig = ''
          AllowTcpForwarding yes
          X11Forwarding no
          AllowAgentForwarding no
          AllowStreamLocalForwarding no
          AuthenticationMethods publickey
        '';
      };
    };
}
