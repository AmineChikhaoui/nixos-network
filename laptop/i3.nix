{ config, lib, pkgs, ... }:

rec {
  environment.systemPackages =
    with pkgs; [
      i3status
      i3status-rust
      i3lock
      dmenu
      sakura
      rofi # dmenu alternative
      compton # X compositor
      alacritty
    ];

  services.xserver =
    { enable = true;
      dpi = 220;
      layout = "us";
      displayManager = {
        defaultSession = "none+i3";
        lightdm.enable = true;
#        sessionCommands = ''
#          ${pkgs.xorg.xset}/bin/xset r rate 200 40
#        '';
      };
      windowManager.i3 = {
        enable = true;
        configFile = "/home/amine/nixos-network/laptop/i3config.conf";
      };
    };

  hardware.video.hidpi.enable = true;
}
