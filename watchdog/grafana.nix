{ config, pkgs, ... }:
{
  sops.secrets = {
    tailnet-domain = {
      owner = "grafana";
    };
    tailscale-ips = { };
  };

  systemd.services.grafana.serviceConfig = {
    EnvironmentFile = "/run/secrets/tailnet-domain";
  };

  services.grafana = {
    enable = true;
    port = 2342;
    addr = "127.0.0.1";
  };

  systemd.services.httpd.serviceConfig = {
    EnvironmentFile = [
      "/run/secrets/tailnet-domain"
      "/run/secrets/tailscale-ips"
    ];
  };

  # Nginx doesn't seem to support environment variables ??
  # switching back to httpd to be able to inject "secrets" at runtime
  services.httpd =
    {
      enable = true;
      logPerVirtualHost = true;

      adminAddr = "amine@chikhaoui.org";

      virtualHosts."watchdog.\${TAILNET_DOMAIN}" = {
        listen = [
          { ip = "127.0.0.1"; port = 80; }
          { ip = "\${WATCHDOG_IP}"; port = 443; ssl = true; }
        ];

        # Do I even need SSL with Tailscale tho' ?
        forceSSL = true;

        sslServerCert =
          "/var/lib/tailscale/certs/watchdog.\${TAILNET_DOMAIN}.crt";
        sslServerKey =
          "/var/lib/tailscale/certs/watchdog.\${TAILNET_DOMAIN}.key";

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
          { targets = [ "nixos:9002" ];
            labels.role = "macbook";
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
