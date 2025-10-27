# Cloudflare Setup (Singkat)

## Step 1: Sebelum Deploy

Pastikan muhhilmi.site sudah pointing ke Cloudflare nameservers.

## Step 2: Deploy AWS

```bash
cd /home/hilmi/backend_anigmaa
./aws/scripts/deploy-with-cloudflare.sh
```

Script akan output API endpoint (contoh: `d-xxxxx.execute-api.ap-southeast-1.amazonaws.com`)

## Step 3: Setup Cloudflare DNS

1. Login: https://dash.cloudflare.com/muhhilmi.site
2. DNS tab → Add Record:
   - Type: CNAME
   - Name: api
   - Content: d-xxxxx.execute-api.ap-southeast-1.amazonaws.com (dari output)
   - Proxy: ☑ Proxied (Orange Cloud)
   - Save

3. SSL/TLS tab → Set Mode: Full atau Full (strict)

Done! Wait 2-5 minutes untuk DNS propagate.

## Test

```bash
curl https://api.muhhilmi.site/health
```

## Troubleshoot

DNS not resolving?
```bash
nslookup api.muhhilmi.site
```

API error (502/503)?
```bash
./aws/scripts/monitor-logs.sh --lambda-logs
```
