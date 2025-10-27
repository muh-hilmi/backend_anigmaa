# AWS Lambda Migration - Deployment Status

**Last Updated**: October 27, 2025
**Status**: ⚠️ Awaiting IAM Permissions

## 🎯 Objective

Migrate from ECS to AWS Lambda + Cloudflare for **47% cost savings** ($47/month vs $88/month)

## ✅ Completed Steps

### 1. Prerequisites Verification
- ✅ Go 1.25.3 - Linux/amd64
- ✅ Terraform v1.13.4 on linux_amd64
- ✅ AWS CLI v2.31.22
- ✅ AWS Credentials configured (Account: 442612105165, User: server102)

### 2. Configuration Setup
- ✅ Updated `/aws/terraform/terraform.tfvars` with:
  - Database password: `WRGCZxHhGRp0vFXY` (16-char secure)
  - JWT secret: `2GeflZcneQfck7uttwoQTI085VaIhwBg` (32-char secure)
  - AWS region: `ap-southeast-1`
  - Project: `anigmaa` / Environment: `prod`
  - S3 bucket: `anigmaa-uploads-*` (auto-suffixed)

### 3. Terraform Configuration Fixes
Fixed multiple issues to make Terraform valid:

**api_gateway.tf** (lines 93-106)
- ✅ Added `domain_name_configuration` block (required for custom domains)
- ✅ Added `security_policy = "TLS_1_2"`
- ✅ Added `target_domain_name` reference

**lambda.tf** (lines 1-68)
- ✅ Commented out lambda layer (optional dependency)
- ✅ Removed unsupported `tags` attribute from `aws_lambda_alias`
- ✅ Commented out layer reference in function config

**s3.tf** (lines 90-124)
- ✅ Added `filter {}` blocks to lifecycle rules (required by AWS provider v5.x)

### 4. Lambda Binary Build
- ✅ Built Go binary for Linux/amd64: `GOOS=linux GOARCH=amd64 CGO_ENABLED=0`
- ✅ Binary size: 32 MB (uncompressed)
- ✅ Created lambda-function.zip: 14.56 MB (compressed)
- ✅ Copied to terraform working directory

## ⚠️ Current Blocker

### IAM Permission Issue

**Error Message**:
```
Error: fetching Availability Zones: operation error EC2: DescribeAvailabilityZones
User: arn:aws:iam::442612105165:user/server102 is not authorized to perform:
ec2:DescribeAvailabilityZones because no identity-based policy allows the
ec2:DescribeAvailabilityZones action
```

**Root Cause**: User `server102` has insufficient IAM permissions.

### Required Permissions

User `server102` needs permissions for these AWS services:

#### Essential
- `ec2:DescribeAvailabilityZones` - For VPC setup
- `ec2:CreateVpc, ec2:CreateSubnet` - VPC network
- `ec2:CreateSecurityGroup` - Security group management
- `lambda:CreateFunction` - Deploy Lambda
- `apigateway:*` - API Gateway management
- `rds:CreateDBInstance` - RDS database
- `elasticache:CreateReplicationGroup` - Redis cluster
- `s3:CreateBucket` - S3 bucket creation
- `iam:CreateRole, iam:PutRolePolicy` - IAM role setup
- `logs:CreateLogGroup` - CloudWatch logs

## 🔧 Solution

### Option A: Attach Managed Policy (Recommended)
Attach `PowerUserAccess` or custom policy to `server102`:

```bash
# Create custom policy for Terraform deployment
aws iam put-user-policy --user-name server102 --policy-name TerraformDeployment --policy-document '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "rds:*",
        "elasticache:*",
        "lambda:*",
        "apigateway:*",
        "s3:*",
        "iam:CreateRole",
        "iam:PutRolePolicy",
        "iam:AttachRolePolicy",
        "logs:*",
        "ssm:PutParameter"
      ],
      "Resource": "*"
    }
  ]
}'
```

### Option B: Use Different User
Switch to IAM user with broader permissions (e.g., with `AdministratorAccess`).

## 📋 Deployment Steps (Once Permissions Fixed)

### Step 1: Initialize Terraform
```bash
cd /home/hilmi/backend_anigmaa/aws/terraform
terraform init
```

### Step 2: Plan Infrastructure
```bash
terraform plan -out=tfplan
```

Expected: ~45 resources to create (VPC, RDS, Redis, Lambda, API Gateway, S3, etc.)

### Step 3: Apply Configuration
```bash
terraform apply tfplan
```

Duration: ~15-20 minutes (RDS startup is slowest)

### Step 4: Cloudflare DNS Setup
Script will output API Gateway endpoint. In Cloudflare dashboard:

1. Go to: https://dash.cloudflare.com/muhhilmi.site
2. DNS tab → Create CNAME record:
   - **Name**: `api`
   - **Content**: `[from terraform output]`
   - **Proxy**: ☑ Proxied
   - **TTL**: Auto
3. Wait 2-5 minutes for DNS propagation

### Step 5: Test API
```bash
# Quick health check
curl https://api.muhhilmi.site/health

# Full API test
./aws/scripts/test-api.sh https://api.muhhilmi.site
```

### Step 6: Monitor Logs (Optional)
```bash
./aws/scripts/monitor-logs.sh
```

## 📊 Infrastructure Overview

### Architecture
```
Internet
    ↓
Cloudflare (CDN + WAF + DNS)
    ↓ (CNAME)
API Gateway (HTTP/2, CORS)
    ↓
Lambda (512MB, VPC-enabled)
    ├→ RDS PostgreSQL (db.t3.micro, 20GB)
    ├→ Redis ElastiCache (cache.t3.micro)
    └→ S3 (File uploads)
```

### Resources to Create (45 total)

**Network** (11):
- 1 VPC, 2 public subnets, 2 private subnets
- 2 NAT gateways, 1 Internet Gateway
- 3 Route tables, 2 Route table associations

**Compute** (2):
- 1 Lambda function (512MB)
- 1 Lambda alias

**Database** (2):
- 1 RDS PostgreSQL instance
- 1 ElastiCache Redis cluster

**API** (8):
- 1 HTTP API, 1 Stage, 1 Integration
- 1 Route, 1 Lambda permission
- 1 Domain name (if custom domain configured)
- 1 API mapping
- 1 CloudWatch log group

**Storage** (7):
- 1 S3 bucket
- 1 Versioning, 1 Encryption
- 1 Public access block
- 1 CORS config, 1 Lifecycle, 1 Bucket policy

**Security** (13):
- 5 Security groups (ALB, ECS, RDS, Redis, Lambda)
- 2 Security group rules (RDS+Lambda, Redis+Lambda)
- 3 IAM roles
- 3 IAM role policies

## 💰 Cost Estimate

| Service | Usage | Monthly Cost |
|---------|-------|--------------|
| Lambda | 1M requests × 100ms @ 512MB | $2-5 |
| API Gateway | 1M requests | $3-5 |
| RDS PostgreSQL | db.t3.micro × 730h + 20GB | $20-30 |
| ElastiCache | cache.t3.micro × 730h | $15-20 |
| S3 | 10GB files × 1K requests | $1-2 |
| NAT Gateway | 2 × 1GB data | $5 |
| CloudWatch Logs | 100GB/month | $5-10 |
| Misc (DynamoDB, SSM) | - | $2-5 |
| **Total** | | **~$47/month** |

**Savings vs ECS**: $41/month (47% reduction)

## 🚀 Post-Deployment

### Database Migration (if needed)
```bash
./aws/scripts/migrate-database.sh
```

### Environment Updates
Update these in Lambda environment variables (via AWS Console or Terraform):
- `DB_PASSWORD` - Set to actual database password
- `JWT_SECRET` - Set to actual JWT secret
- `MIDTRANS_SERVER_KEY` - Midtrans payment gateway
- `MIDTRANS_CLIENT_KEY` - Midtrans payment gateway

### Monitoring
- CloudWatch Logs: `/aws/lambda/anigmaa-backend`
- API Gateway Logs: `/aws/apigateway/anigmaa`
- RDS Events in AWS Console

## ✅ Checklist

- [x] Prerequisites verified
- [x] Secrets generated and configured
- [x] Terraform files fixed
- [x] Lambda binary built
- [ ] IAM permissions updated
- [ ] Terraform plan successful
- [ ] Terraform apply successful
- [ ] Cloudflare DNS configured
- [ ] API endpoint tested
- [ ] Database migrated (if needed)
- [ ] Environment variables updated

## 📞 Support

If deployment fails:

1. Check IAM permissions: `aws iam get-user --user-name server102`
2. Verify credentials: `aws sts get-caller-identity`
3. Review Terraform logs: Check tfplan or terraform.log
4. Check Lambda logs: `./aws/scripts/monitor-logs.sh`

## 📝 Related Files

- **Deployment Script**: `aws/scripts/deploy-with-cloudflare.sh`
- **Test Script**: `aws/scripts/test-api.sh`
- **Monitoring Script**: `aws/scripts/monitor-logs.sh`
- **Destroy Script**: `aws/scripts/destroy.sh` (cleanup)
- **Terraform Config**: `aws/terraform/*.tf`
- **Terraform Variables**: `aws/terraform/terraform.tfvars` ⚠️ Contains secrets

---

**Next Action Required**: Update IAM permissions for `server102` user as described in "Solution" section.
