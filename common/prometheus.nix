{ pkgs, lib, config, ... }:
{
  services.prometheus =
    {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
        process = {
          enable = true;
          settings.process_names = [
            # Remove nix store path from process name
            { name = "{{.Matches.Wrapped}} {{ .Matches.Args }}";
              cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*) (?P<Args>.*)"];
            }
          ];
        };
      };
    };
}
