{ config, pkgs, ... }:
{
  sops.secrets.tailnet-hostname = {
    owner = "grafana";
  };

  sops.secrets.watchdog-tailscale-ip = {};

  systemd.services.grafana.serviceConfig = {
    EnvironmentFile = "/run/secrets/tailnet-hostname";
  };

  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };

  systemd.services.httpd.serviceConfig = {
    EnvironmentFile = [
      "/run/secrets/tailnet-hostname"
      "/run/secrets/watchdog-tailscale-ip"
    ];
  };

  # Nginx doesn't seem to support environment variables ??
  # switching back to httpd to be able to inject "secrets" at runtime
  services.httpd =
    {
      enable = true;
      logPerVirtualHost = true;

      adminAddr = "amine@chikhaoui.org";

      virtualHosts."\${GF_SERVER_DOMAIN}" = {
        listen = [
          { ip = "127.0.0.1"; port = 80; }
          { ip = "\${TAILSCALE_IP}"; port = 443; ssl = true; }
        ];

        # Do I even need SSL with Tailscale tho' ?
        forceSSL = true;

        sslServerCert =
          "/var/lib/tailscale/certs/\${GF_SERVER_DOMAIN}.crt";
        sslServerKey =
          "/var/lib/tailscale/certs/\${GF_SERVER_DOMAIN}.key";

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}/";
          #proxyWebsockets = true;
        };

      };
    };

  services.prometheus = {
    enable = true;
    port = 9001;
    extraFlags = [
      "--storage.tsdb.retention=${toString (30 * 24)}h"
    ];
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 9002;
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
            labels.role = "watchdog";
          }
          { targets = [ "linode:9002" ];
            labels.role = "linode";
          }
        ];
      }
    ];
  };

  services.loki = {
    enable = true;
    configFile = ./loki-local-config.yaml;
  };

  systemd.services.promtail = {
    description = "Promtail service for Loki";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.grafana-loki}/bin/promtail --config.file ${./promtail.yaml}
      '';
    };
  };
}
