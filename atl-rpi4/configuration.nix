unstablePkgs:

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../common/tailscale.nix unstablePkgs.tailscale)
      ../common/users.nix
    ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [ "console=ttyAMA0,115200" "console=tty1" ];

  boot.supportedFilesystems = [ "exfat" ];

  hardware.enableRedistributableFirmware = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "atl-rpi4";

  networking.interfaces = {
    "wlan0" = {
      ipv4.addresses = [ { address = "192.168.86.40"; prefixLength = 24; } ];
    };
  };

  sops.secrets.wifi-password = {};

  systemd.services.wpa_supplicant-wlan0.serviceConfig = {
    EnvironmentFile = "${config.sops.secrets.wifi-password.path}";
  };

  networking.wireless = {
    enable = true;
    networks = {
      Chikhaoui.psk = "@PSK_HOME@";
    };
  };

  # Set your time zone.
  time.timeZone = "America/NewYork";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;


  environment.systemPackages = with pkgs; [
     wget vim wpa_supplicant firefox htop
     bind
  ];

  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.03"; # Did you read the comment?

}

