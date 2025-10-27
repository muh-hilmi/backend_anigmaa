# AWS Lambda + Cloudflare Deployment Guide

**Status:** ✅ Ready to Deploy

## 1-Minute Summary

```bash
# Prerequisites
aws configure
terraform --version
go version

# Update secrets
cd aws/terraform
nano terraform.tfvars  # Edit db_password & jwt_secret

# Deploy (automatic)
cd /home/hilmi/backend_anigmaa
./aws/scripts/deploy-with-cloudflare.sh

# Manual Cloudflare setup (2 minutes)
# Login to https://dash.cloudflare.com/muhhilmi.site
# Add CNAME: api → [output_from_script]

# Test
curl https://api.muhhilmi.site/health
```

## Files

- **DEPLOY.md** - Quick deployment steps
- **aws/CLOUDFLARE.md** - Cloudflare setup
- **aws/terraform/terraform.tfvars** - Configuration (UPDATE REQUIRED)
- **aws/scripts/deploy-with-cloudflare.sh** - Main deployment script
- **aws/scripts/test-api.sh** - API testing
- **aws/scripts/monitor-logs.sh** - Log monitoring

## Cost Comparison

| Item | ECS | Lambda |
|------|-----|--------|
| Compute | $30-50 | $2-5 |
| Load Balancer | $20-25 | - |
| **Total** | **$88/mo** | **$47/mo** |
| **Savings** | - | **47% cheaper** ✓ |

## Architecture

```
Mobile Apps → Cloudflare → API Gateway → Lambda → RDS/Redis/S3
```

## Next Steps

1. Install prerequisites (Go 1.21+, Terraform, AWS CLI)
2. Run `aws configure`
3. Update `aws/terraform/terraform.tfvars`
4. Run `./aws/scripts/deploy-with-cloudflare.sh`
5. Setup Cloudflare DNS (manual)
6. Test with `curl https://api.muhhilmi.site/health`

Done! 🚀
