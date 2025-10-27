# Next Steps - AWS Lambda Migration

## ⚡ Quick Start (5 minutes to fix, then deploy)

### Step 1: Fix IAM Permissions (5 min)

User `server102` needs deployment permissions. **Choose one**:

#### Option A: AWS Console (Easiest)
1. Login to AWS Console: https://console.aws.amazon.com/
2. Go to **IAM** → **Users** → **server102**
3. Click **Add Permissions** → **Attach Policies Directly**
4. Search for **`PowerUserAccess`** and select it
5. Click **Add Permissions**
6. Done! ✅

#### Option B: AWS CLI (If you have admin)
```bash
aws iam attach-user-policy \
  --user-name server102 \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess
```

#### Option C: Ask Account Owner
Send them this:
> "Please add PowerUserAccess policy to IAM user server102 in account 442612105165"

### Step 2: Verify Permissions (1 min)
```bash
aws ec2 describe-regions --region ap-southeast-1
# If you see regions list → permissions are fixed ✅
# If you see error → permissions not yet fixed yet ❌
```

### Step 3: Deploy to AWS (20 min)
```bash
cd /home/hilmi/backend_anigmaa/aws/terraform

# Initialize Terraform (1 min)
terraform init

# Plan deployment (2 min)
terraform plan -out=tfplan

# Apply configuration (15 min) - LONGEST STEP
terraform apply tfplan
```

### Step 4: Setup Cloudflare DNS (2 min)
```bash
# Get the API endpoint
cd /home/hilmi/backend_anigmaa/aws/terraform
terraform output -raw api_gateway_endpoint
# This outputs something like: d1234.execute-api.ap-southeast-1.amazonaws.com
```

Then in Cloudflare:
1. Go to: https://dash.cloudflare.com/muhhilmi.site
2. DNS tab → Add Record
3. Create CNAME:
   - **Name**: `api`
   - **Content**: `[paste output from above]`
   - **Proxy**: ☑ Proxied (orange cloud)
   - Click Save
4. Wait 2-5 minutes

### Step 5: Test API (1 min)
```bash
curl https://api.muhhilmi.site/health

# Should return: {"status":"ok"}
```

## 📊 What Gets Created

| Resource | Purpose | Cost |
|----------|---------|------|
| Lambda | API backend | $2-5/mo |
| API Gateway | HTTP endpoint | $3-5/mo |
| RDS PostgreSQL | Database | $20-30/mo |
| ElastiCache Redis | Cache | $15-20/mo |
| S3 | File uploads | $1-2/mo |
| Networking | VPC, NAT, etc | $5-10/mo |
| **Total** | | **~$47/mo** |

**Savings**: 47% cheaper than ECS ($88/mo)

## ✅ Completion Checklist

- [ ] IAM permissions fixed
- [ ] `terraform plan` successful
- [ ] `terraform apply` successful
- [ ] Cloudflare DNS configured
- [ ] API health check working
- [ ] Database populated (if needed)

## 🔧 Current Status

**What's already done**:
- ✅ Prerequisites installed (Go, Terraform, AWS CLI)
- ✅ Secrets configured
- ✅ Lambda binary built
- ✅ Terraform files fixed
- ✅ Configuration ready to deploy

**What you need to do**:
1. ⏳ Fix IAM permissions (Step 1)
2. ⏳ Run terraform deploy (Step 3)
3. ⏳ Configure Cloudflare DNS (Step 4)
4. ⏳ Test API (Step 5)

## 📞 Troubleshooting

### "UnauthorizedOperation" error?
- Permissions need 5-10 seconds to take effect after applying
- Wait a bit and retry: `terraform plan`

### "No regions available"?
- Might be wrong AWS credentials configured
- Check: `aws sts get-caller-identity`
- Should show user: `server102`, Account: `442612105165`

### Terraform stuck creating RDS?
- Normal - RDS takes 10-15 minutes
- Check CloudFormation in AWS Console for progress

### API test returns 503?
- Lambda needs 1-2 minutes to boot after deployment
- Wait 2 minutes and retry: `curl https://api.muhhilmi.site/health`

## 📝 Important Files

- **Deployment status**: `AWS_DEPLOYMENT_STATUS.md` - Full details
- **IAM setup**: `AWS_IAM_SETUP_REQUIRED.md` - Permission instructions
- **This file**: `DEPLOY_NEXT_STEPS.md` - Quick guide
- **Terraform config**: `aws/terraform/terraform.tfvars` - Secrets ⚠️

## 🚀 After Deployment

```bash
# Monitor logs in real-time
./aws/scripts/monitor-logs.sh

# Run full API test suite
./aws/scripts/test-api.sh https://api.muhhilmi.site

# Get all outputs
cd aws/terraform
terraform output

# If you need to rollback
./aws/scripts/destroy.sh  # ⚠️ Deletes everything
```

---

**Ready?** Start with **Step 1** above (fixing IAM permissions).

Need help? Check `AWS_IAM_SETUP_REQUIRED.md` for detailed instructions.
