{ pkgs, lib, ...}:
{
  services.hydra-dev.enable = true;
  # (import /home/amine/src/github.com/hydra {}).build; ?
  services.hydra-dev.hydraURL = "http://localhost:3000";
  services.hydra-dev.notificationSender = "amine@chikhaoui.org";
  services.hydra-dev.buildMachinesFiles = [ "/etc/nix/machines" ];
  services.hydra-dev.useSubstitutes = true;
  services.hydra-dev.extraConfig = ''
  '';
  users.users.hydra.extraGroups = [ "users" ];
  /*  <runcommand>
       command = echo Amine:done
    </runcommand>
  */
}
