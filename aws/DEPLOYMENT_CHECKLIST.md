# Lambda Deployment Checklist

## Pre-Deployment Checks

### 1. Code Preparation
- [ ] Go code compiles without errors
  ```bash
  go build
  ```
- [ ] All tests pass
  ```bash
  go test ./...
  ```
- [ ] No hardcoded credentials or secrets
- [ ] Environment variables properly used
- [ ] Health check endpoint responds to `/health`

### 2. Binary Preparation
- [ ] Build Linux binary
  ```bash
  GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap .
  ```
- [ ] Binary size reasonable (< 100MB)
  ```bash
  ls -lh bootstrap
  ```
- [ ] Zip created successfully
  ```bash
  zip lambda-function.zip bootstrap
  ```

### 3. AWS Credentials
- [ ] AWS credentials configured
  ```bash
  aws sts get-caller-identity
  ```
- [ ] Correct AWS account (verify Account ID)
- [ ] Correct region set (ap-southeast-1)
  ```bash
  aws configure get region
  ```
- [ ] IAM user/role has required permissions

### 4. Terraform Configuration
- [ ] Terraform initialized
  ```bash
  cd aws/terraform
  terraform init
  ```
- [ ] No syntax errors
  ```bash
  terraform validate
  ```
- [ ] All variables set or have defaults
- [ ] terraform.tfvars created with sensitive variables
  ```bash
  # terraform.tfvars should contain:
  # db_password = "..."
  # jwt_secret = "..."
  # (DO NOT commit to git)
  ```

### 5. AWS Infrastructure Ready
- [ ] RDS database exists and is running
  ```bash
  aws rds describe-db-instances --db-instance-identifier anigmaa
  ```
- [ ] ElastiCache Redis running
  ```bash
  aws elasticache describe-replication-groups
  ```
- [ ] S3 bucket exists
  ```bash
  aws s3 ls | grep anigmaa
  ```
- [ ] SSM parameters exist (if using external secrets management)

---

## Terraform Deployment

### Step 1: Plan Deployment
```bash
cd aws/terraform

terraform plan \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET" \
  -out=tfplan

# Review the plan output carefully
# Verify:
# - Lambda function is created
# - API Gateway is created
# - Security groups are properly configured
# - No resources are being destroyed
```

- [ ] Plan reviewed and approved
- [ ] No unexpected deletions
- [ ] All new resources properly configured

### Step 2: Apply Configuration
```bash
terraform apply tfplan

# Or interactively
terraform apply \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"
```

- [ ] Apply completed successfully
- [ ] No errors in output
- [ ] Lambda function created
- [ ] API Gateway created
- [ ] Security groups configured

### Step 3: Verify Terraform Outputs
```bash
terraform output

# Key outputs to note:
terraform output -raw api_gateway_endpoint
terraform output -raw lambda_function_name
terraform output -raw lambda_function_arn
```

- [ ] api_gateway_endpoint exists and is valid
- [ ] lambda_function_name created
- [ ] lambda_function_arn created
- [ ] lambda_role_arn created

---

## Post-Deployment Testing

### Step 1: Lambda Function Test
```bash
# Test Lambda directly
aws lambda invoke \
  --function-name anigmaa-backend \
  --region ap-southeast-1 \
  --payload '{"requestContext":{"http":{"method":"GET","path":"/health"}},"body":""}' \
  response.json

cat response.json
```

- [ ] Lambda invocation succeeds
- [ ] Response payload is valid JSON
- [ ] No errors in response

### Step 2: API Gateway Health Check
```bash
# Get API endpoint
API_ENDPOINT=$(terraform output -raw api_gateway_endpoint)

# Test health endpoint
curl "${API_ENDPOINT}/health"

# Should return: {"status":"ok"} or similar
```

- [ ] Health endpoint responds with 200 status
- [ ] Response body is valid
- [ ] No 502/503/504 errors

### Step 3: Database Connectivity
```bash
# Check Lambda logs for database connection
aws logs tail /aws/lambda/anigmaa-backend --follow

# Make API call that uses database
curl "${API_ENDPOINT}/api/v1/users" \
  -H "Authorization: Bearer $TEST_TOKEN"

# Check logs for:
# - No database connection errors
# - No timeout errors
# - Successful query execution
```

- [ ] Database connection successful
- [ ] No connection timeout errors
- [ ] Queries execute properly

### Step 4: Redis/Cache Connectivity
```bash
# Make API call that uses cache (if applicable)
curl "${API_ENDPOINT}/api/v1/cached-endpoint"

# Check logs:
aws logs tail /aws/lambda/anigmaa-backend --follow
```

- [ ] Redis connection successful
- [ ] Cache reads/writes working
- [ ] No timeout errors

### Step 5: S3 Access Test
```bash
# Make API call that uses S3 (if applicable, e.g., file upload)
curl -X POST "${API_ENDPOINT}/api/v1/upload" \
  -F "file=@test-file.txt"

# Check logs and verify file in S3
aws s3 ls s3://anigmaa-uploads/
```

- [ ] S3 upload successful
- [ ] File accessible via S3
- [ ] No permission errors in logs

### Step 6: API Gateway Logging
```bash
# Verify API Gateway logs are being written
aws logs tail /aws/apigateway/anigmaa --follow

# Make test request
curl "${API_ENDPOINT}/health"

# Should see request logged
```

- [ ] API Gateway logs created
- [ ] Requests being logged
- [ ] No logging errors

---

## Performance & Load Testing

### Step 1: Cold Start Test
```bash
# First invocation (cold start)
time curl "${API_ENDPOINT}/health"

# Expected: 1-2 seconds

# Second invocation (warm start)
time curl "${API_ENDPOINT}/health"

# Expected: <100ms
```

- [ ] Cold start acceptable (~1-2 sec)
- [ ] Warm start fast (<200ms)
- [ ] Lambda memory sufficient

### Step 2: Concurrent Request Test
```bash
# Test with multiple concurrent requests
ab -n 100 -c 10 "${API_ENDPOINT}/health"

# or using Apache Bench

# Check for:
# - No 429 errors (too many requests)
# - Response time acceptable
# - No Lambda timeout errors
```

- [ ] No errors under load
- [ ] Concurrent requests handled
- [ ] No throttling

### Step 3: Duration Monitoring
```bash
# Check Lambda execution duration
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Duration \
  --dimensions Name=FunctionName,Value=anigmaa-backend \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 300 \
  --statistics Average,Maximum
```

- [ ] Average duration < 500ms
- [ ] Max duration < 5 seconds
- [ ] No timeouts (30 sec limit)

---

## Configuration Verification

### Step 1: Environment Variables
```bash
aws lambda get-function-configuration \
  --function-name anigmaa-backend \
  --query 'Environment.Variables'

# Verify:
# - DB_HOST points to RDS
# - REDIS_HOST points to ElastiCache
# - AWS_BUCKET points to S3
# - All required variables present
```

- [ ] All environment variables set
- [ ] No hardcoded sensitive values
- [ ] Correct database/cache endpoints

### Step 2: VPC Configuration
```bash
aws lambda get-function-configuration \
  --function-name anigmaa-backend \
  --query 'VpcConfig'

# Verify:
# - Subnets include private subnets
# - Security groups include lambda_sg
```

- [ ] VPC properly configured
- [ ] Correct subnets assigned
- [ ] Correct security group assigned

### Step 3: IAM Permissions
```bash
aws iam get-role-policy \
  --role-name anigmaa-lambda-execution-role \
  --policy-name anigmaa-lambda-s3-policy

# Verify:
# - S3 permissions include bucket
# - SSM permissions for secrets
# - CloudWatch logs permissions
```

- [ ] S3 permissions configured
- [ ] SSM permissions configured
- [ ] CloudWatch logs permissions configured

### Step 4: Security Group Rules
```bash
aws ec2 describe-security-groups \
  --group-ids sg-xxxxx \
  --query 'SecurityGroups[0].IpPermissions'

# Verify:
# - No ingress (Lambda uses internal invocation)
# - Egress allows database/Redis/S3 traffic
```

- [ ] Security group ingress empty (correct)
- [ ] Egress allows database traffic
- [ ] Egress allows Redis traffic

---

## Rollback Plan (If Needed)

### Option A: Quick Rollback (Revert to Previous Lambda Version)
```bash
# Get previous function version
aws lambda list-versions-by-function \
  --function-name anigmaa-backend

# If previous version exists, point alias to it
aws lambda update-alias \
  --function-name anigmaa-backend \
  --name live \
  --function-version <PREVIOUS_VERSION>
```

- [ ] Previous version verified working
- [ ] Alias updated to previous version
- [ ] API responding correctly

### Option B: Full Rollback to ECS/Fargate
```bash
# Uncomment all ECS resources in terraform
# Then apply

terraform apply \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"

# Destroy Lambda (optional)
terraform destroy \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"
```

- [ ] ECS resources restored
- [ ] ECS service updated
- [ ] Application responding from ALB
- [ ] Lambda resources removed (if desired)

---

## Monitoring Setup

### Step 1: CloudWatch Alarms
```bash
# Create alarm for Lambda errors
aws cloudwatch put-metric-alarm \
  --alarm-name anigmaa-lambda-errors \
  --namespace AWS/Lambda \
  --metric-name Errors \
  --dimensions Name=FunctionName,Value=anigmaa-backend \
  --statistic Sum \
  --period 300 \
  --evaluation-periods 1 \
  --threshold 5 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions arn:aws:sns:ap-southeast-1:ACCOUNT_ID:alerts

# Create alarm for Lambda duration
aws cloudwatch put-metric-alarm \
  --alarm-name anigmaa-lambda-duration \
  --namespace AWS/Lambda \
  --metric-name Duration \
  --dimensions Name=FunctionName,Value=anigmaa-backend \
  --statistic Maximum \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 10000 \
  --comparison-operator GreaterThanThreshold \
  --alarm-actions arn:aws:sns:ap-southeast-1:ACCOUNT_ID:alerts
```

- [ ] Error alarm created
- [ ] Duration alarm created
- [ ] Notification configured

### Step 2: Log Insights Queries
```bash
# Save useful log queries

# Query 1: Errors in last 1 hour
fields @timestamp, @message, @duration, @error
| filter @message like /error|Error|ERROR/
| stats count() as error_count by @error

# Query 2: Execution duration statistics
fields @duration
| stats avg(@duration), max(@duration), pct(@duration, 99)

# Query 3: Database connection issues
fields @timestamp, @message
| filter @message like /database|connection|timeout/
```

- [ ] Log Insights queries created
- [ ] Queries saved for monitoring
- [ ] Team aware of query locations

---

## Documentation & Handoff

- [ ] All team members have access to AWS account
- [ ] CI/CD updated to use Lambda deployment workflow
- [ ] Frontend team updated with new API endpoint
- [ ] API documentation updated (if applicable)
- [ ] Runbook created for common issues
- [ ] Escalation contacts documented
- [ ] Backup & recovery procedures documented

---

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| DevOps Engineer | | | |
| Backend Lead | | | |
| Infrastructure Lead | | | |

---

## Notes

```
[Space for any additional notes or observations]
```

---

## Appendix: Useful Commands

```bash
# Get Lambda function info
aws lambda get-function --function-name anigmaa-backend

# Get Lambda configuration
aws lambda get-function-configuration --function-name anigmaa-backend

# Tail Lambda logs
aws logs tail /aws/lambda/anigmaa-backend --follow

# List all Lambda versions
aws lambda list-versions-by-function --function-name anigmaa-backend

# Invoke Lambda with test payload
aws lambda invoke \
  --function-name anigmaa-backend \
  --payload file://test-payload.json \
  response.json

# Get API Gateway info
aws apigatewayv2 get-apis --query 'Items[?Name==`anigmaa-backend-api`]'

# Get API Gateway stage
aws apigatewayv2 get-stage --api-id <API_ID> --stage-name prod

# Test API endpoint
curl https://<api-id>.execute-api.ap-southeast-1.amazonaws.com/prod/health
```

---

**Document Version:** 1.0
**Last Updated:** 2024
**Status:** Ready for Use
