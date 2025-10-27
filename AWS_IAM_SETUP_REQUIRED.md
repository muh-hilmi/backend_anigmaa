# AWS IAM Setup Required for Deployment

**Current Status**: ❌ **User `server102` lacks deployment permissions**

## Problem

User `server102` is restricted and cannot:
- Create VPC resources (EC2 API blocked)
- Create databases (RDS API blocked)
- Deploy Lambda functions (Lambda API blocked)
- Create API Gateway (API Gateway API blocked)
- Manage IAM roles (IAM API blocked)

## Solution

### Method 1: Use AWS Management Console (No AWS CLI Needed)

1. **Login to AWS Console** as account owner or admin user
2. **Go to IAM** → Users → `server102`
3. **Attach Policy**:
   - Click "Add Permissions" → "Attach Policies Directly"
   - Search and select: **`PowerUserAccess`**
   - Click "Add Permissions"

4. **Verify**: PowerUserAccess includes all needed permissions except IAM

5. **For IAM permissions**, also attach: **`IAMFullAccess`** (or create custom policy)

### Method 2: Create Custom Policy (More Secure)

1. **Go to IAM** → Policies → Create Policy
2. **Choose JSON tab** and paste this policy:

```json
{
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
        "iam:GetRole",
        "iam:PassRole",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "logs:*",
        "ssm:PutParameter",
        "ssm:GetParameter",
        "cloudwatch:*",
        "sns:CreateTopic",
        "sns:PublishMetricAlarm",
        "sqs:CreateQueue"
      ],
      "Resource": "*"
    }
  ]
}
```

3. **Name it**: `AnigmaaDeploymentPolicy`
4. **Go to Users** → `server102` → **Attach Policies**
5. **Select** `AnigmaaDeploymentPolicy`

### Method 3: Use AWS CLI (If You Have Admin Access)

```bash
# Option A: Attach managed policy
aws iam attach-user-policy \
  --user-name server102 \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# Option B: Create and attach custom policy
aws iam put-user-policy \
  --user-name server102 \
  --policy-name AnigmaaDeploymentPolicy \
  --policy-document file://policy.json
```

## Deployment Checklist

After updating permissions:

```bash
# 1. Verify permissions are working
aws sts get-caller-identity
# Should return: User, Account (442612105165), Arn

# 2. Test EC2 access
aws ec2 describe-regions --region ap-southeast-1
# Should return list of regions

# 3. Test Lambda access
aws lambda list-functions --region ap-southeast-1
# Should return (possibly empty)

# 4. Now deploy
cd /home/hilmi/backend_anigmaa/aws/terraform
terraform plan -out=tfplan
terraform apply tfplan
```

## Timeline

- **Updated permissions**: ⏱️ Instant in AWS Console
- **Terraform plan**: ⏱️ 2-3 minutes
- **Terraform apply**: ⏱️ 15-20 minutes (RDS is slowest)
- **Total deployment**: ⏱️ ~25 minutes

## Post-Deployment

Once terraform completes:

```bash
# 1. Get the API endpoint
cd aws/terraform
terraform output lambda_api_endpoint

# 2. Configure Cloudflare DNS
# Go to: https://dash.cloudflare.com/muhhilmi.site
# Add CNAME: api → [output_from_above]

# 3. Test the API
curl https://api.muhhilmi.site/health

# 4. Update environment variables (if needed)
aws ssm put-parameter \
  --name /anigmaa/DB_PASSWORD \
  --value "your-secure-password" \
  --type SecureString
```

## Reference Commands

### Verify Current User
```bash
aws iam get-user
# Shows: server102 details and ARN
```

### Check Attached Policies
```bash
aws iam list-user-policies --user-name server102
aws iam list-attached-user-policies --user-name server102
```

### Cleanup (When No Longer Needed)
```bash
# Detach policy
aws iam detach-user-policy \
  --user-name server102 \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# Or delete custom policy
aws iam delete-user-policy \
  --user-name server102 \
  --policy-name AnigmaaDeploymentPolicy
```

## Troubleshooting

### Q: Still getting "UnauthorizedOperation"?
**A**: Policies may take 5-10 seconds to propagate. Wait and try again.

### Q: How do I know if it worked?
**A**: Run: `aws ec2 describe-regions --region ap-southeast-1`
If it returns regions list without error, you're good!

### Q: Can I use a different user?
**A**: Yes! If you have another IAM user with `AdministratorAccess`, use:
```bash
export AWS_PROFILE=admin_user_name
# Then run terraform commands
```

### Q: What if I don't have admin access?
**A**: Contact your AWS account owner and ask them to:
1. Go to IAM → Users → server102
2. Click "Add Permissions" → "Attach Policies Directly"
3. Select "PowerUserAccess"
4. Click "Add Permissions"

---

**Once permissions are updated**: Return to `AWS_DEPLOYMENT_STATUS.md` and follow "Deployment Steps" section.
