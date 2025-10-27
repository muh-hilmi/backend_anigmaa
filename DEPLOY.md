# Deploy ke AWS Lambda + Cloudflare

## Setup (5 menit)

```bash
aws configure  # Setup AWS credentials

cd aws/terraform
# Edit terraform.tfvars - update:
# db_password = "YOUR_SECURE_PASSWORD"
# jwt_secret = "YOUR_SECRET_KEY"
nano terraform.tfvars
```

## Deploy (20 menit)

```bash
./aws/scripts/deploy-with-cloudflare.sh
```

Script akan:
- Deploy AWS infrastructure
- Build & deploy Lambda
- Tampilkan Cloudflare setup instructions

## Cloudflare Setup (5 menit)

1. Login: https://dash.cloudflare.com/muhhilmi.site
2. DNS tab → Create CNAME:
   - Name: `api`
   - Content: `[from_script_output]`
   - Proxy: ☑ Proxied
3. Wait 2-5 minutes

## Test

```bash
curl https://api.muhhilmi.site/health

./aws/scripts/test-api.sh https://api.muhhilmi.site
```

## Troubleshoot

```bash
./aws/scripts/monitor-logs.sh
```

Done!
