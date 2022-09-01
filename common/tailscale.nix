tailscaleUnstable:

{ pkgs, lib, ... }:

let

  goArchs = {
    x86_64-linux = "amd64";
    aarch64-linux = "arm64";
  };

  tailscaleFromBin = releaseType:
    let
      platform = goArchs."${pkgs.system}";
      checksums = {
        amd64 = "sha256-hmA4ennVOYOPAy4MvmIMskHuPwY2/YlCJ103yjj0Vv0=";
        arm64 = "sha256-A9q75K8+QLIUrmxG7jtoqDfsXjjITSZxoZjt3Fxxa0k=";
      };
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "tailscale";
      version = "1.30.0";

      src = pkgs.fetchurl {
        url = "https://pkgs.tailscale.com/${releaseType}/${pname}_${version}_${platform}.tgz";
        sha256 = checksums."${platform}";
      };

      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out

        install -Dm755 ./tailscale $out/bin/tailscale
        install -Dm755 ./tailscaled $out/bin/tailscaled

        wrapProgram $out/bin/tailscaled --prefix PATH : ${lib.makeBinPath [ pkgs.iproute2 pkgs.iptables ]}
        wrapProgram $out/bin/tailscale --suffix PATH : ${lib.makeBinPath [ pkgs.procps ]}

        sed -i -e "s#/usr/sbin#$out/bin#" -e "/^EnvironmentFile/d" ./systemd/tailscaled.service
        install -D -m0444 -t $out/lib/systemd/system ./systemd/tailscaled.service
      '';
    };

in
{
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  services.tailscale = {
    enable = true;
    package = tailscaleFromBin "stable";
  };
}
