{ config, lib, pkgs, ... }:

rec {
  environment.systemPackages =
    with pkgs; [
      i3status
      i3lock
      dmenu
      sakura
      rofi # dmenu alternative
      compton # X compositor
    ];

  programs.light.enable = true;
  programs.kbdlight.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  services.xserver =
    { enable = true;
      synaptics.enable = true;
      layout = "us";
      displayManager.sddm.enable = true;
      windowManager.i3 = {
        enable = true;
        configFile = "/etc/nixos/i3config.conf";
      };
    };

  hardware.video.hidpi.enable = true;
}
