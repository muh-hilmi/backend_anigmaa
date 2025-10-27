# AWS Deployment Guide for Anigmaa Backend

This guide provides step-by-step instructions to deploy your Anigmaa backend application to AWS using **AWS Lambda**, **API Gateway**, **RDS PostgreSQL**, and **ElastiCache Redis**.

> **⚠️ Note:** Infrastructure has been migrated from ECS/Fargate to Lambda. See [LAMBDA_MIGRATION.md](./LAMBDA_MIGRATION.md) for details.

## Architecture Overview

The deployment creates the following AWS resources:
- **VPC** with public and private subnets across 2 AZs
- **Lambda Function** for serverless compute (replaces ECS Fargate)
- **API Gateway v2** (HTTP API) for REST endpoint (replaces ALB)
- **RDS PostgreSQL** for the database
- **ElastiCache Redis** for caching
- **S3 bucket** for file storage
- **IAM roles** and security groups
- **CloudWatch** for logging and monitoring

## Prerequisites

Before starting, ensure you have:

1. **AWS CLI** installed and configured
   ```bash
   aws configure
   ```

2. **Terraform** installed (version >= 1.0)
   ```bash
   # Install via package manager or download from https://terraform.io
   ```

3. **Go installed** (version >= 1.17)
   ```bash
   go version
   ```

4. **Domain and SSL certificate** (optional but recommended)
   - Register a domain name
   - Create an SSL certificate in AWS Certificate Manager

## Deployment Steps

### 1. Clone and Prepare

```bash
cd backend_anigmaa
```

### 2. Configure Environment Variables

Copy the Terraform variables template:

```bash
cp aws/terraform/terraform.tfvars.example aws/terraform/terraform.tfvars
```

Edit `aws/terraform/terraform.tfvars` with your values:

```hcl
# AWS Configuration
aws_region = "ap-southeast-1"

# Project Configuration
project_name = "anigmaa"
environment  = "prod"

# Database Configuration
db_password = "your-secure-database-password"

# Application Configuration
jwt_secret = "your-super-secret-jwt-key"
midtrans_server_key = "your-midtrans-server-key"
midtrans_client_key = "your-midtrans-client-key"
allowed_origins = "https://yourdomain.com"

# Domain Configuration (optional)
domain_name = "api.yourdomain.com"
certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"
```

### 3. Deploy Infrastructure with Terraform

```bash
cd aws/terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"

# Apply the configuration
terraform apply \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"
```

### 4. Build and Deploy Application Code

```bash
# Build Go binary for Lambda
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap .

# Package binary
zip lambda-function.zip bootstrap

# Upload to Lambda
aws lambda update-function-code \
  --function-name anigmaa-backend \
  --zip-file fileb://lambda-function.zip \
  --region ap-southeast-1
```

### 5. Verify Deployment

Check if your application is running:

```bash
# Get API Gateway endpoint
cd aws/terraform
API_ENDPOINT=$(terraform output -raw api_gateway_endpoint)

# Test health endpoint
curl "$API_ENDPOINT/health"

# You should get a response like: {"status":"ok"}
```

## Environment Variables

The application uses the following environment variables in AWS:

### Database
- `DB_HOST` - RDS endpoint (auto-configured)
- `DB_PORT` - Database port (5432)
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password (stored in SSM Parameter Store)
- `DB_NAME` - Database name
- `DB_SSLMODE` - SSL mode (require for RDS)

### Redis
- `REDIS_HOST` - ElastiCache endpoint (auto-configured)
- `REDIS_PORT` - Redis port (6379)
- `REDIS_PASSWORD` - Redis auth token (stored in SSM Parameter Store)

### Storage
- `STORAGE_TYPE` - Set to "s3"
- `AWS_REGION` - AWS region
- `AWS_BUCKET` - S3 bucket name (auto-configured)

### Application
- `PORT` - Application port (8080)
- `ENV` - Environment (production)
- `JWT_SECRET` - JWT secret key (stored in SSM Parameter Store)
- `ALLOWED_ORIGINS` - CORS allowed origins

### Payment
- `MIDTRANS_SERVER_KEY` - Midtrans server key (stored in SSM Parameter Store)
- `MIDTRANS_CLIENT_KEY` - Midtrans client key
- `MIDTRANS_IS_PRODUCTION` - Set to true

## Management Commands

### View Application Logs

```bash
# Tail Lambda logs in real-time
aws logs tail /aws/lambda/anigmaa-backend --follow --region ap-southeast-1

# Or use CloudWatch Logs Insights
aws logs start-query \
  --log-group-name /aws/lambda/anigmaa-backend \
  --start-time $(date -d '1 hour ago' +%s) \
  --end-time $(date +%s) \
  --query-string 'fields @timestamp, @duration, @error | stats count() as error_count'
```

### Scale Lambda

Lambda automatically scales based on traffic. To adjust memory or concurrency:

```bash
# Increase memory for better performance
terraform apply -var="lambda_memory=1024"

# Or set reserved concurrent executions
aws lambda put-function-concurrency \
  --function-name anigmaa-backend \
  --reserved-concurrent-executions 100
```

### Update Application

```bash
# Build Go binary
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o bootstrap .
zip lambda-function.zip bootstrap

# Upload new version
aws lambda update-function-code \
  --function-name anigmaa-backend \
  --zip-file fileb://lambda-function.zip \
  --region ap-southeast-1

# Verify update
aws lambda get-function-configuration --function-name anigmaa-backend
```

### Connect to Database

```bash
# Get database endpoint
cd aws/terraform
DB_HOST=$(terraform output -raw rds_endpoint)

# Connect using psql
psql postgresql://postgres:PASSWORD@$DB_HOST:5432/anigmaa
```

### Access S3 Bucket

```bash
# List files
aws s3 ls s3://your-bucket-name/

# Sync files
aws s3 sync ./local-folder s3://your-bucket-name/folder/
```

## Monitoring and Alerts

### CloudWatch Dashboards

Access monitoring dashboards:
- ECS: https://console.aws.amazon.com/ecs/home?region=ap-southeast-1
- RDS: https://console.aws.amazon.com/rds/home?region=ap-southeast-1
- CloudWatch: https://console.aws.amazon.com/cloudwatch/home?region=ap-southeast-1

### Set Up Alerts

Create CloudWatch alarms for:
- High CPU usage (>80%)
- High memory usage (>80%)
- Database connection errors
- Application errors (5xx responses)

## Security Best Practices

### Implemented Security Features

✅ **Network Security**
- VPC with private subnets for database and Redis
- Security groups with minimal required access
- NAT gateways for outbound internet access

✅ **Data Security**
- RDS encryption at rest
- Redis encryption in transit and at rest
- S3 bucket encryption
- SSL/TLS termination at load balancer

✅ **Access Control**
- IAM roles with minimal required permissions
- Secrets stored in SSM Parameter Store
- No hardcoded credentials

✅ **Monitoring**
- CloudWatch logging for all services
- Enhanced monitoring for RDS
- Container insights for ECS

### Additional Recommendations

1. **Enable AWS WAF** on the load balancer
2. **Set up AWS Config** for compliance monitoring
3. **Enable AWS GuardDuty** for threat detection
4. **Use AWS KMS** for additional encryption
5. **Implement backup strategies** for RDS and S3

## Cost Optimization

### Current Configuration Costs (approximate monthly)

With Lambda (New):
- **Lambda**: ~$2-5 (100k requests/month)
- **API Gateway**: ~$3-10 (100k requests/month)
- **RDS db.t3.micro**: ~$15-20
- **ElastiCache cache.t3.micro**: ~$12-15
- **NAT Gateway**: ~$2-5
- **Data Transfer**: Variable based on usage
- **S3 Storage**: Variable based on usage

**Total estimated**: ~$45-55/month ✅ (Previously ~$80-120)

### Cost Comparison

| Component | ECS | Lambda | Savings |
|-----------|-----|--------|---------|
| Compute | $30-50 | $2-5 | ~90% |
| Load Balancer | $20-25 | - | ~100% |
| **Total** | ~$88 | ~$47 | **~47%** |

### Optimization Tips

1. **Monitor Lambda memory** - Increase if execution time is high
2. **Use API caching** - Reduce Lambda invocations for frequently accessed endpoints
3. **Enable Reserved Capacity** for predictable workloads
4. **Implement S3 lifecycle policies** for old files
5. **Use CloudWatch** to identify unused resources

## Troubleshooting

### Common Issues

**1. Lambda Function Not Executing**
```bash
# Check Lambda logs
aws logs tail /aws/lambda/anigmaa-backend --region ap-southeast-1

# Check Lambda function status
aws lambda get-function --function-name anigmaa-backend

# Test Lambda directly
aws lambda invoke --function-name anigmaa-backend response.json
cat response.json
```

**2. Database Connection Issues**
```bash
# Check security group rules
aws ec2 describe-security-groups --filters "Name=group-name,Values=*lambda*"

# Verify RDS endpoint
aws rds describe-db-instances --query 'DBInstances[0].Endpoint'

# Check Lambda VPC configuration
aws lambda get-function-configuration --function-name anigmaa-backend --query 'VpcConfig'
```

**3. API Gateway 502/503/504 Errors**
```bash
# Check API Gateway logs
aws logs tail /aws/apigateway/anigmaa --region ap-southeast-1

# Check Lambda errors
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Errors \
  --dimensions Name=FunctionName,Value=anigmaa-backend \
  --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
  --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
  --period 60 \
  --statistics Sum
```

**4. S3 Access Issues**
```bash
# Check Lambda IAM role S3 policy
aws iam get-role-policy \
  --role-name anigmaa-lambda-execution-role \
  --policy-name anigmaa-lambda-s3-policy

# Test S3 access via Lambda
aws lambda invoke \
  --function-name anigmaa-backend \
  --payload '{"requestContext":{"http":{"method":"GET","path":"/files"}},"body":""}' \
  response.json
```

## Cleanup

To completely remove all AWS resources:

```bash
⚠️ WARNING: This will permanently delete all data!

cd aws/terraform
terraform destroy \
  -var="db_password=$DB_PASSWORD" \
  -var="jwt_secret=$JWT_SECRET"
```

## Support

For issues with:
- **AWS Infrastructure**: Check CloudWatch logs and AWS documentation
- **Application Issues**: Check Lambda logs in `/aws/lambda/anigmaa-backend`
- **Database Issues**: Check RDS logs and connection parameters
- **Deployment Issues**: Verify Terraform configuration and AWS permissions

## Documentation

Please refer to these documents for detailed information:

- **[LAMBDA_MIGRATION.md](./LAMBDA_MIGRATION.md)** - Complete migration guide from ECS to Lambda
- **[CHANGES_SUMMARY.md](./CHANGES_SUMMARY.md)** - Detailed summary of all infrastructure changes
- **[DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)** - Pre/post-deployment verification checklist

## Next Steps

After successful deployment:

1. **Update CI/CD pipeline** to use `deploy-lambda.yml` (see github-actions/ directory)
2. **Configure custom domain** via API Gateway domain mapping (optional)
3. **Implement backup strategies** for critical data (RDS automated backups enabled)
4. **Set up monitoring and alerting** for production workloads
5. **Document operational procedures** for your team

## Key Differences from ECS

| Aspect | ECS | Lambda |
|--------|-----|--------|
| Deployment | Docker image to ECR | Go binary zip upload |
| Scaling | Manual or auto-scaling | Automatic (up to 1000 concurrent) |
| Cost | Always-on (even idle) | Pay-per-request |
| Cold start | ~10-30 seconds | ~1-2 seconds (with VPC) |
| Timeout | Configurable | 30 seconds (default), max 900 seconds |
| Management | ECS service/task management | AWS Lambda dashboard |
| Load Balancer | ALB required | API Gateway (included) |