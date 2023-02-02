unstablePkgs:
{ lib, ...}:
{
  imports = [
    ../../common/users.nix

    (import ../../common/nix-config.nix unstablePkgs.nixUnstable)
    (import ../../common/tailscale.nix null)
    ../../laptop/i3.nix
    ../../laptop/fonts.nix

  ];
  programs.command-not-found.enable = true;
  services.lorri.enable = true;

  time.timeZone = "America/NewYork";

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "0";
  boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config = {
    allowUnsupportedSystem = true;
    allowUnfree = true;
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  networking.nameservers = [ "8.8.8.8" ];

  networking.useDHCP = false;
  networking.interfaces.ens160.useDHCP = true;

  users.extraUsers.amine.shell = lib.mkForce "${unstablePkgs.fish}/bin/fish";
  my.users.extraGroups = [ "docker" ];

  disabledModules = [ "virtualisation/vmware-guest.nix" ];

  virtualisation = {
    vmware.guest.enable = true;
    docker.enable = true;
  };
  fileSystems."/host" = {
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    device = ".host:/";
    options = [
    "umask=22"
    "uid=1000"
    "gid=1000"
    "allow_other"
    "auto_unmount"
    "defaults"
    ];
  };

  system.stateVersion = "21.11";
}
