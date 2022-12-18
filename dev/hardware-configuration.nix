{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub = {
    efiSupport = true;
    configurationLimit = 0;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D058-E526";
      fsType = "vfat";
    };

  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" =
    { device = "/dev/sda1";
      fsType = "ext4";
    };
}
