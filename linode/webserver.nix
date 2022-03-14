{ config, lib, ... }:
{

  sops.secrets = {
    tailnet-domain = { };
    tailscale-ips = { };
  };

  security.acme = {
    acceptTerms = true;
    email = "amine.chikhaoui91@gmail.com";
  };

  systemd.services.httpd.serviceConfig = {
    EnvironmentFile = [
      "/run/secrets/tailnet-domain"
      "/run/secrets/tailscale-ips"
    ];
  };

  services.httpd = {
    enable = true;
    logPerVirtualHost = true;

    extraModules = [ "userdir" ];

    adminAddr = "amine.chikhaoui91@gmail.com";

    virtualHosts =
      {
        "linode.\${TAILNET_DOMAIN}" = {
          listen = [
            { ip = "\${LINODE_IP}"; port = 443; ssl = true; }
            { ip = "127.0.0.1"; port = 80; }
          ];

          # locations."/.well-known/keybase.txt" = {
          #   alias = "/var/www/amine/docs/keybase.txt";
          # };
          # enableACME = true;

          forceSSL = true;

          sslServerCert =
            "/var/lib/tailscale/certs/linode.\${TAILNET_DOMAIN}.crt";
          sslServerKey =
            "/var/lib/tailscale/certs/linode.\${TAILNET_DOMAIN}.key";


          # Mostly thelounge/irc config
          # TODO: expose only through tailscale
          extraConfig =
            ''
              Header always set Strict-Transport-Security "max-age=15552000"
              SSLProtocol All -SSLv2 -SSLv3
              SSLCipherSuite HIGH:!aNULL:!MD5:!EXP
              SSLHonorCipherOrder on

              RewriteEngine On
              RewriteRule ^/irc$ /irc/ [R]
              RewriteCond %{REQUEST_URI}  ^/irc/socket.io        [NC]
              RewriteCond %{QUERY_STRING} transport=websocket    [NC]
              RewriteRule /irc/(.*)       ws://127.0.0.1:9000/$1 [P,L]

              RewriteCond %{HTTP_HOST} ^www\.(.+)$ [NC]
              RewriteRule ^ http://%1%{REQUEST_URI} [R=301,L]

              RedirectMatch ^/$ /~amine/

              ProxyVia On
              ProxyRequests Off
              ProxyPass /irc/ http://127.0.0.1:9000/
              ProxyPassReverse /irc/ http://127.0.0.1:9000/

              # By default Apache times out connections after one minute
              ProxyTimeout 86400
            '';
        };
      };
   };
}
