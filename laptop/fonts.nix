{ pkgs, lib, ... }:
with pkgs;

let

  i3statusIcons = fetchurl {
    url = "https://gist.githubusercontent.com/draoncc/3c20d8d4262892ccd2e227eefeafa8ef/raw/3e6e12c213fba1ec28aaa26430c3606874754c30/MaterialIcons-Regular-for-inline.ttf";
    sha256 = "sha256:107sl6zyiasxnf86pi0gwmj1dnwn9wy6phva4vjacpqqgl9bzv46";
  };

  i3StatusBarFont = runCommand "i3status-icons" {}
  ''
    mkdir -p $out/share/fonts/truetype/
    cp ${i3statusIcons} $out/share/fonts/truetype/
  '';

in
{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts =
      [ i3StatusBarFont ]
      ++
      (with pkgs; [
        #nerdfonts
        mononoki
        corefonts
        inconsolata
        liberation_ttf
        dejavu_fonts
        bakoma_ttf
        gentium
        ubuntu_font_family
        terminus_font
        font-awesome
        font-awesome_5
        powerline-fonts
      ]);
  };
}
