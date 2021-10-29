{ pkgs, ... }:
{
  services.thelounge = {
    enable = true;
    private = true;
    extraConfig = {
      reverseProxy = true;
    };
  };
}
