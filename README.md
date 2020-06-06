# certbot-dns-pddyandex
PDD Yandex DNS API for certbot --manual-auth-hook --manual-cleanup-hook

Install and renew Let's encrypt wildcard ssl certificate for domain *.site.com using PDD Yandex DNS API:

#### 1) Clone this repo and set the API key
```bash
git clone https://github.com/actionm/certbot-dns-pddyandex/ && cd ./certbot-dns-pddyandex
```

#### 2) Set API KEY

Get your PDD Yandex API key from https://tech.yandex.ru/pdd/doc/concepts/access-docpage/ )

```bash
nano ./config.sh
```

#### 3) Install CertBot from git
```bash
cd ../ && git clone https://github.com/certbot/certbot && cd certbot
```

#### 4) Generate wildcard
```bash
./letsencrypt-auto certonly --manual-public-ip-logging-ok --agree-tos --email info@site.com --renew-by-default -d site.com -d *.site.com --manual --manual-auth-hook ../certbot-dns-pddyandex/authenticator.sh --manual-cleanup-hook ../certbot-dns-pddyandex/cleanup.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

#### 5) Force Renew
```bash
./letsencrypt-auto renew --force-renew --manual --manual-auth-hook ../certbot-dns-pddyandex/authenticator.sh --manual-cleanup-hook ../certbot-dns-pddyandex/cleanup.sh --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
```

Предполагается, что сертификат будет выпускаться минимум для 2 доменов (example.com и *.example.com). Для одного домена может не работать

Большая задержка после вставки DNS-записи связана с тем, что Яндекс не сразу отдает обновленные данные серверу Let's encrypt-a.. приходится ждать
