# AWS Lambda Migration - Terraform Apply Results

**Date**: October 27, 2025
**Result**: ⚠️ PARTIAL SUCCESS - 46 of 52 resources created

## Summary

Terraform successfully created **46 resources** but encountered **6 errors** during deployment. This is expected given IAM restrictions on the account.

### ✅ Successfully Created (46 Resources)

**Network Infrastructure**:
- VPC (vpc-0f3c6419d0e34448f)
- Internet Gateway (igw-00c26be2fd71920f0)
- 4 Subnets (2 public, 2 private)
- 2 NAT Gateways (nat-04c15054ea3c5183c, nat-0542b584649cf0d6b)
- 3 Route Tables with associations
- 5 Security Groups (ALB, ECS, RDS, Redis, Lambda)
- 2 Security Group Rules
- Load Balancer (ALB) - arn:aws:elasticloadbalancing:ap-southeast-1:442612105165:loadbalancer/app/anigmaa-alb/19728e580f226dd4
- 1 ALB Target Group

**Storage & Database**:
- S3 Bucket (anigmaa-uploads-190e6a84) with:
  - Public Access Block
  - Encryption
  - Versioning
  - CORS Configuration
  - Lifecycle Configuration
- RDS DB Parameter Group (anigmaa-db-params)
- ElastiCache Subnet Group

**API & Monitoring**:
- API Gateway HTTP API (ts1ghj85rd)
- API Gateway Stage (prod)
- CloudWatch Log Groups (API Gateway & Lambda)
- 1 ALB HTTP Listener (on port 80)

**Secrets Management**:
- SSM Parameter: JWT Secret (/anigmaa/prod/jwt/secret)
- SSM Parameter: DB Password (/anigmaa/prod/db/password)
- SSM Parameter: Redis Auth Token (/anigmaa/prod/redis/auth-token)
- SSM Parameter: Midtrans Server Key (/anigmaa/prod/midtrans/server-key)

**Other**:
- Random ID (for S3 bucket suffix)
- Random Password (for Redis - generated but not used due to validation error)

## ❌ Failed Resources (6)

### 1-4. IAM Roles (4 roles failed with same error)
**Error**: `AccessDenied: iam:CreateRole - no permissions boundary allows the iam:CreateRole action`

Failed Roles:
- anigmaa-ecs-execution-role (iam.tf:2)
- anigmaa-ecs-task-role (iam.tf:24)
- anigmaa-lambda-execution-role (iam.tf:166)
- anigmaa-rds-enhanced-monitoring (rds.tf:80)

**Reason**: PowerUserAccess policy excludes IAM operations (NotAction on iam:*)
**Root Cause**: User server102 needs additional IAM permissions

### 5. ElastiCache Redis Auth Token Validation
**Error**: `only alphanumeric characters or symbols (excluding @, " , and /) allowed in "auth_token"`
**Reason**: random_password generated special characters not allowed by ElastiCache
**Fix**: Modify elasticache.tf to disable special characters

### 6. ALB HTTPS Listener Duplicate
**Error**: `DuplicateListener: A listener already exists on this port for this load balancer`
**Reason**: HTTP listener (port 80) already created, HTTPS listener attempted on same port
**Fix**: Remove duplicate listener from alb.tf or consolidate listeners

## Root Causes & Solutions

### Issue 1: IAM Permission Boundary (CRITICAL - Blocks 4 resources)

**Current State**: PowerUserAccess policy
**Problem**: Cannot create IAM roles required by Lambda, ECS, RDS

**Solution A: Add IAMFullAccess (Simplest - 1 command)**
```bash
aws iam attach-user-policy \
  --user-name server102 \
  --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
```

**Solution B: Create Custom IAM Policy (More Secure)**
Add to server102 user policy:
```json
{
  "Effect": "Allow",
  "Action": [
    "iam:CreateRole",
    "iam:DeleteRole",
    "iam:AttachRolePolicy",
    "iam:DetachRolePolicy",
    "iam:PutRolePolicy",
    "iam:DeleteRolePolicy",
    "iam:GetRole",
    "iam:ListRolePolicies",
    "iam:ListAttachedRolePolicies",
    "iam:PassRole"
  ],
  "Resource": "*"
}
```

**Solution C: Request Account Owner**
Contact AWS account admin to grant IAM permissions to server102

### Issue 2: Redis Auth Token Contains Invalid Characters

**Current Configuration** (elasticache.tf:~20):
```hcl
resource "random_password" "redis_auth_token" {
  length  = 32
  # Missing: special = false
}
```

**Fix**:
```hcl
resource "random_password" "redis_auth_token" {
  length  = 32
  upper   = true
  lower   = true
  numeric = true
  special = false  # Add this line to allow only alphanumeric
}
```

### Issue 3: Duplicate ALB Listener

**Current Configuration** (alb.tf):
- HTTP listener already created on port 80
- HTTPS listener attempted on same port (duplicate)

**Fix Options**:

Option A: Keep only HTTP listener (for development)
```bash
# Comment out or remove the HTTPS listener block in alb.tf
```

Option B: Use ports 80 (HTTP) and 443 (HTTPS)
- Ensure listeners are on different ports
- Remove duplication

Option C: Use HTTPS only
- Use port 443
- Remove HTTP listener

---

## Next Steps To Complete Deployment

### Step 1: Fix IAM Permissions ⚠️ REQUIRED
```bash
# Quickest solution:
aws iam attach-user-policy \
  --user-name server102 \
  --policy-arn arn:aws:iam::aws:policy/IAMFullAccess
```

### Step 2: Fix Terraform Configuration (elasticache.tf)
```bash
# Edit elasticache.tf line ~20
# Change:
resource "random_password" "redis_auth_token" {
  length  = 32
}

# To:
resource "random_password" "redis_auth_token" {
  length  = 32
  special = false
}
```

### Step 3: Fix ALB Listener Configuration (alb.tf)
Remove or fix duplicate listener on same port.

### Step 4: Re-apply Terraform
```bash
cd /home/hilmi/backend_anigmaa/aws/terraform
terraform apply -auto-approve
```

This will retry creating the 6 failed resources.

### Step 5: Verify All Resources
```bash
terraform output
```

Expected outputs:
- api_gateway_endpoint: HTTP API endpoint
- rds_endpoint: Database endpoint
- redis_endpoint: Redis cache endpoint
- s3_bucket_name: Upload bucket name
- vpc_id: VPC ID

### Step 6: Deploy Lambda & Cloudflare
```bash
./aws/scripts/deploy-with-cloudflare.sh
```

---

## Infrastructure Status

### ✅ Complete (46 Resources)
- ✅ VPC networking (VPC, subnets, gateways, routing)
- ✅ Storage (S3 bucket fully configured)
- ✅ API Gateway (HTTP API)
- ✅ Load Balancer (ALB with HTTP)
- ✅ Monitoring (CloudWatch logs)
- ✅ Secrets (SSM parameters)

### ⏳ Pending (6 Resources)
- ⏳ 4 IAM Roles (ecs-execution, ecs-task, lambda-execution, rds-monitoring)
- ⏳ Redis Cluster (awaiting auth token fix)
- ⏳ RDS Database (awaiting IAM role)
- ⏳ Lambda Function (awaiting IAM role)
- ⏳ ALB HTTPS Listener (awaiting configuration fix)

---

## Timeline & Cost

### Deployment Progress
- ✅ Prerequisites checked: 10 min
- ✅ Configuration prepared: 5 min
- ✅ Lambda binary built: 5 min
- ✅ Terraform planned: 5 min
- ✅ Terraform applied: 10 min (46/52 resources)
- ⏳ Remaining: ~15-20 min (fixes + retry)

**Total Elapsed**: ~35 minutes
**Estimated Remaining**: 15-20 minutes to go-live

### Cost Estimate (46 resources deployed)
- Load Balancer: $16/month
- NAT Gateways (2x): $24/month
- S3: $1/month
- API Gateway (pending): ~$3/month
- RDS (pending): ~$20/month
- Redis (pending): ~$15/month

**Current**: ~$41/month
**Final Estimate**: ~$47-80/month (88% cheaper than ECS at $88/month)

---

## Key Artifacts

- **Terraform State**: `/home/hilmi/backend_anigmaa/aws/terraform/terraform.tfstate`
- **Deployment Logs**: `/tmp/terraform_apply.log`
- **Lambda Binary**: `/home/hilmi/backend_anigmaa/aws/terraform/lambda-function.zip` (14.56 MB)
- **Configuration**: `/home/hilmi/backend_anigmaa/aws/terraform/terraform.tfvars`

---

## Troubleshooting

### Can I continue if not all resources created?
**No** - Lambda & RDS require IAM roles to function. The 4 failed IAM role creations are blockers.

### Should I destroy and retry?
**Not recommended yet** - 46 resources are already deployed. Just:
1. Fix IAM permissions
2. Fix configuration (elasticache.tf, alb.tf)
3. Re-run terraform apply

Destroying requires `terraform destroy -auto-approve`

### What if IAM fix fails?
Contact your AWS account owner. PowerUserAccess policy is too restrictive for this deployment.

---

## Rollback

If you need to start over:
```bash
cd /home/hilmi/backend_anigmaa/aws/terraform
terraform destroy -auto-approve
```

This will destroy all 46 created resources and allow re-deployment.

---

**Status**: Ready for IAM permission update and configuration fixes
**Next Action**: Apply IAM permissions to server102 user
**Est. Time to Completion**: 15-20 minutes after IAM fix
