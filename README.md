# Godaddy DNS Challenge Hook for Snappy NextCloud

## What is this?

One can install [Snappy Nextcloud](https://github.com/nextcloud/nextcloud-snap)
in a server behind a NAT or firewall to the Internet and provide service via
[frpc](https://github.com/fatedier/frp) or similar proxy services. But the
certbot requires port 80/443 of the proxy server to complete http challenge for
the HTTPS certificates, which is sometimes impossible for shared proxy servers.

This project offers a set of hooks that use [Godaddy](https://godaddy.com/)
API, DNS challenge and certbot's manual plugin to obtain Let's Encrypt
certificates when the default webroot cannot work in proxied scenarios.

## Prerequisites

* domain provider must be Godaddy and A/CNAME record of the domain for
  nextcloud service must be correctly created
* Snappy Nextcloud installed, domains to be used for service are added to
  `trusted_domains` of `/var/snap/nextcloud/current/nextcloud/config/config.php`
* use default snap root path and data path, i.e. `/snap` and `/var/snap`
  respectively

## Usage

1. login the nextcloud server via SSH
2. clone or download this project
3. copy the hook folder to nextcloud data dir:
  `sudo cp -r dns-challenge /var/snap/nextcloud/common/`
4. create the secrets file by making a copy of example:
  `sudo cp /var/snap/nextcloud/common/dns-challenge/secrets.example /var/snap/nextcloud/common/dns-challenge/secrets`
4. create a pair of godaddy API key and secret on
  [https://developer.godaddy.com/](https://developer.godaddy.com/)
  then edit `/var/snap/nextcloud/common/dns-challenge/secrets` to set the
  `GODADDY_API_KEY` and `GODADDY_API_SECRET` accordingly
5. run the installer:
  `sudo /var/snap/nextcloud/common/dns-challenge/install.sh`, input your
  email address and domain name (or subdomain name) for the nextcloud service
  when asked
6. execute `sudo nextcloud.enable-https lets-encrypt`, use the exactly same
  email and domain name as last step to activate HTTPS.
