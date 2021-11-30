{ pkgs, lib, ... }:
{
  hardware.sane.enable = true;
  hardware.facetimehd.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  boot.extraModprobeConfig = ''
      options hid_apple iso_layout=0
  '';

  services.udev = {
    extraRules = ''
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="brcmfmac", KERNEL=="wlp3s0", RUN="${pkgs.wirelesstools}/bin/iwconfig wlp3s0 power off"
    '';
  };

  time.timeZone = "America/New_York";

  services.xserver = {
    xkbVariant = "mac";
    xkbOptions = "terminate:ctrl_alt_bksp,grp:alt_space_toggle";
  };

  # Fix font sizes in X
  services.xserver.dpi = 160;
  # fonts.fontconfig.dpi = 160;

  services.xserver.synaptics.tapButtons = true;
  services.xserver.synaptics.fingersMap = [ 0 0 0 ];
  services.xserver.synaptics.buttonsMap = [ 1 3 2 ];
  services.xserver.synaptics.twoFingerScroll = true;
}
