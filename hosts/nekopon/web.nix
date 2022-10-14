{
  config,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;

    serverNamesHashBucketSize = 96;

    virtualHosts = {
      "nekopon.pl" = {
        listenAddresses = ["127.0.0.1"];
        serverAliases = ["www.nekopon.pl" "nekoponmvppnutba7awvelxayxoutkolpplmmp7mxmfrobswqkbi5kad.onion"];
        root = "/var/www/htdocs/nekopon.pl";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ =404";
          };
          "/assets/img/gravatar.png" = {
            proxyPass = "https://secure.gravatar.com/avatar/b1ba96bc4847f45193a62856d3592063";
            extraConfig = ''
              proxy_pass_request_headers off;
              proxy_ignore_headers Cache-Control;
              proxy_ignore_headers Expires;
              proxy_hide_header Cache-Control;
              proxy_hide_header Expires;
              proxy_buffering on;
            '';
          };
        };

        extraConfig = ''
          add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "no-referrer" always;
          add_header Cross-Origin-Opener-Policy "same-origin" always;
          add_header Cross-Origin-Embedder-Policy "require-corp" always;
          add_header X-Download-Options "noopen" always;
          add_header X-Permitted-Cross-Domain-Policies "none" always;
          add_header Origin-Agent-Cluster "?1" always;
          add_header X-Frame-Options "DENY" always;

          # obsolete when client system time is correct
          add_header Expect-CT "enforce, max-age=63072000" always;

          # obsolete, unsafe and replaced with strong Content-Security-Policy
          add_header X-XSS-Protection "0" always;
          add_header Cross-Origin-Resource-Policy "cross-origin" always;
          add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), autoplay=(), battery=(), camera=(), clipboard-read=(), clipboard-write=(), display-capture=(), document-domain=(), encrypted-media=(), fullscreen=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), serial=(), sync-xhr=(), xr-spatial-tracking=()" always;
          # Google's web.dev/measure, Lighthouse and scrapers won't be able to use robots.txt with connect-src 'none'. Sad.
          add_header Content-Security-Policy "default-src 'none'; child-src 'none'; connect-src 'self'; font-src 'none'; img-src 'self'; manifest-src 'none'; script-src 'self'; style-src 'self'; form-action 'none'; frame-ancestors 'none'; block-all-mixed-content; base-uri 'none'" always;

          add_header Onion-Location http://nekoponmvppnutba7awvelxayxoutkolpplmmp7mxmfrobswqkbi5kad.onion$request_uri;
        '';
      };

      "natalia.ovh" = {
        listenAddresses = ["127.0.0.1"];
        serverAliases = ["www.natalia.ovh"];
        root = "/var/www/htdocs/natalia.ovh";
        locations."/".tryFiles = "$uri $uri/ =404";

        extraConfig = ''
          add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "no-referrer" always;
          add_header Cross-Origin-Opener-Policy "same-origin" always;
          add_header Cross-Origin-Embedder-Policy "require-corp" always;
          add_header X-Download-Options "noopen" always;
          add_header X-Permitted-Cross-Domain-Policies "none" always;
          add_header Origin-Agent-Cluster "?1" always;
          add_header X-Frame-Options "DENY" always;

          # obsolete when client system time is correct
          add_header Expect-CT "enforce, max-age=63072000" always;

          # obsolete, unsafe and replaced with strong Content-Security-Policy
          add_header X-XSS-Protection "0" always;
          add_header Cross-Origin-Resource-Policy "same-origin" always;
          add_header Permissions-Policy "accelerometer=(), ambient-light-sensor=(), autoplay=(), battery=(), camera=(), clipboard-read=(), clipboard-write=(), display-capture=(), document-domain=(), encrypted-media=(), fullscreen=(), geolocation=(), gyroscope=(), hid=(), idle-detection=(), interest-cohort=(), magnetometer=(), microphone=(), midi=(), payment=(), picture-in-picture=(), publickey-credentials-get=(), screen-wake-lock=(), serial=(), sync-xhr=(), xr-spatial-tracking=()" always;
          add_header Content-Security-Policy "default-src 'none'; child-src 'none'; connect-src 'none'; font-src 'none'; img-src 'self'; manifest-src 'none'; script-src 'none'; style-src 'none'; form-action 'none'; frame-ancestors 'none'; block-all-mixed-content; base-uri 'none'" always;
          add_header X-Frame-Options "DENY" always;
        '';
      };
    };
  };

  services.tor = {
    enable = true;
    enableGeoIP = false;
    relay.onionServices.nekopon = {
      version = 3;
      map = [
        {
          port = 80;
          target = {
            addr = "127.0.0.1";
            port = 80;
          };
        }
      ];
    };
  };

  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = {};

  environment.etc."cloudflared.yml" = {
    mode = "0440";
    user = "cloudflared";
    group = "cloudflared";
    text = ''
      credentials-file: /var/cloudflared/5df5c73c-497a-4acd-82ca-1aa9318e4402.json
      tunnel: 5df5c73c-497a-4acd-82ca-1aa9318e4402

      ingress:
       - hostname: nekopon.pl
         service: http://127.0.0.1:80
       - hostname: www.nekopon.pl
         service: http://127.0.0.1:80
       - hostname: natalia.ovh
         service: http://127.0.0.1:80
       - hostname: www.natalia.ovh
         service: http://127.0.0.1:80
       - service: http_status:404
    '';
  };

  systemd.services.cloudflared = {
    wantedBy = ["multi-user.target"];
    after = ["network.target" "dhcpcd.service"];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config /etc/cloudflared.yml --no-autoupdate run";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
