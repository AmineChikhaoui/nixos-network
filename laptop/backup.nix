{ pkgs, config, lib, ... }:
{
  sops.secrets = {
    borg-passphrase = {
      owner = "amine";
    };
    borg-healthcheck = {};
  };

  services.borgbackup.jobs = {
    borgbase = {
      paths = [
        "/home/amine"
        "/etc/nixos"
        "/etc/i3"
      ];
      exclude = map (d: "/home/amine/" + d) [
        "src"
        "github"
        "bitbucket"
        ".cache"
        ".local"
        "serenity"
        ".config/BraveSoftware"
        ".config/Microsoft"
        ".config/Code"
        ".config/chromium"
        ".rustup"
        "stsclient"
        ".sbt"
        ".vscode"
        ".gradle"
        ".mozilla"
        ".ivy2"
        ".IdeaIC*"
        ".IntelliJ*"
        "go"
        ".npm"
        ".sbtix"
        ".wine"
        ".jdks"
        ".thunderbird"
        "spark*"
        ".m2"
        ".eclipse"
      ];
      repo = "safl1o8s@safl1o8s.repo.borgbase.com:repo";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat ${config.sops.secrets.borg-passphrase.path}";
      };
      environment = {
        BORG_RSH = "ssh -i /home/amine/borgbackup/ssh_key";
      };
      # Extra layer of notification alerts on top of borgbase's notifications
      postHook = ''
        url="https://hc-ping.com/$(cat ${config.sops.secrets.borg-healthcheck.path})"

        if [[ "$exitStatus" == "0" ]]; then
          ${pkgs.curl}/bin/curl -XPOST -fsS --retry 3 "$url"
        else
          ${pkgs.curl}/bin/curl -XPOST -fsS --retry 3 "$url"/fail
        fi
      '';
      compression = "auto,lzma";
      startAt = "13:00:00";

      prune.keep = {
        within = "30d";
      };
    };
  };
}
