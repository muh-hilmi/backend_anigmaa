# ECS/Fargate to Lambda Migration

## Overview
Infrastruktur telah direvisi untuk mengganti ECS/Fargate dengan AWS Lambda sebagai komputasi utama. Perubahan ini memberikan beberapa keuntungan:

- **Cost-effective**: Anda hanya membayar untuk waktu eksekusi, bukan uptime sepanjang waktu
- **Simpler scaling**: Auto-scaling otomatis berdasarkan permintaan API Gateway
- **Easier deployment**: Cukup upload binary Go tanpa perlu Docker container management
- **Faster cold starts**: Binary Go lebih ringan dibanding Docker container

## Architecture Changes

### Previous Architecture (ECS/Fargate)
```
API Request → ALB (Application Load Balancer)
           → ECS Service (Fargate)
           → RDS + Redis
           → S3
```

### New Architecture (Lambda)
```
API Request → API Gateway
           → Lambda Function
           → RDS + Redis
           → S3
```

## Files Modified/Created

### New Files
1. **`lambda.tf`** - Lambda function, layer, dan CloudWatch logs
2. **`api_gateway.tf`** - API Gateway v2 (HTTP API), integration, dan custom domain

### Modified Files
1. **`main.tf`** - Menambahkan Lambda Security Group dan rules untuk RDS/Redis
2. **`iam.tf`** - Menambahkan Lambda IAM roles dan policies
3. **`ecs.tf`** - Commented out semua ECS/Fargate resources
4. **`variables.tf`** - Menambahkan `lambda_memory`, commented out ECS variables
5. **`outputs.tf`** - Menambahkan Lambda/API Gateway outputs, commented out ALB/ECS outputs

## Network Configuration

### VPC Setup (Tetap sama)
- Public subnets: NAT Gateway
- Private subnets: Lambda dan RDS/Redis dalam private subnets
- Security groups: Baru `lambda_sg` dengan akses ke RDS (5432) dan Redis (6379)

## Environment Variables

Lambda menerima environment variables yang sama seperti sebelumnya:
```
PORT=8080
ENV=prod
DB_HOST=<RDS endpoint>
DB_PORT=5432
DB_USER=postgres
DB_NAME=anigmaa
DB_SSLMODE=require
REDIS_HOST=<ElastiCache endpoint>
REDIS_PORT=6379
STORAGE_TYPE=s3
AWS_REGION=ap-southeast-1
AWS_BUCKET=<S3 bucket>
ALLOWED_ORIGINS=<CORS origins>
MIDTRANS_CLIENT_KEY=<key>
MIDTRANS_IS_PRODUCTION=true
```

### Secrets (dari SSM Parameter Store)
- `DB_PASSWORD`
- `JWT_SECRET`
- `REDIS_PASSWORD`
- `MIDTRANS_SERVER_KEY`

## Deployment Steps

### 1. Prepare Lambda Binary
Backend Go harus dikompilasi sebagai binary untuk Linux x86_64:

```bash
# Development
GOOS=linux GOARCH=amd64 go build -o bootstrap .
zip lambda-function.zip bootstrap

# Gunakan Go 1.x atau custom runtime provided.al2
```

### 2. Lambda Layer (Optional)
Jika menggunakan dependencies eksternal:

```bash
mkdir -p layer/go/lib
# Copy dependencies jika diperlukan
zip -r lambda-layer.zip layer/
```

### 3. Deploy Terraform

```bash
cd aws/terraform

# Review changes
terraform plan

# Apply
terraform apply \
  -var="db_password=YOUR_DB_PASSWORD" \
  -var="jwt_secret=YOUR_JWT_SECRET"
```

### 4. Get API Endpoint

```bash
terraform output api_gateway_endpoint
```

## Cost Comparison

### ECS/Fargate (Previous)
- ALB: ~$16/month
- ECS tasks (2x): ~$30/month (always running)
- RDS: ~$20/month
- ElastiCache: ~$15/month
- **Total: ~$81/month** (before data transfer)

### Lambda (New)
- API Gateway: $0.035 per request (pay per use)
- Lambda: $0.0000002 per 100ms (pay per execution)
- RDS: ~$20/month (sama)
- ElastiCache: ~$15/month (sama)
- **Total: ~$35/month + API usage** (significantly cheaper if < 100k requests/month)

## Important Notes

### 1. Lambda Timeout
- Default timeout: **30 seconds**
- Untuk long-running operations, pertimbangkan menggunakan async patterns (SQS + Lambda)

### 2. Lambda Memory
- Default: **512 MB**
- Ubah via variable `lambda_memory` (default 512, range 128-10240)
- Lebih tinggi memory = lebih cepat CPU, lebih mahal

### 3. Cold Start
- First request after deployment/idle time mungkin lebih lambat (1-2 detik)
- Gunakan CloudWatch Logs untuk monitoring execution time

### 4. VPC Overhead
- Lambda dalam VPC akan memiliki ENI cold start penalty
- Jauh lebih cepat setelah cold start

### 5. API Gateway
- HTTP API (v2) lebih murah dan cepat dari REST API (v1)
- Built-in CORS configuration
- Automatic request/response logging ke CloudWatch

## Testing Locally

Gunakan AWS SAM atau LocalStack untuk testing lokal:

```bash
# Install AWS SAM
brew install aws-sam-cli

# Invoke function locally
sam local invoke --template ./lambda.tf
```

## Rollback ke ECS/Fargate

Jika perlu rollback, uncomment konfigurasi di:
1. `ecs.tf` - semua ECS resources
2. `alb.tf` - ALB configuration
3. `variables.tf` - ECS variables
4. `outputs.tf` - ALB/ECS outputs
5. `iam.tf` - ECS roles (masih ada, jangan dihapus)
6. Comment out Lambda/API Gateway resources

## Monitoring

### CloudWatch Logs
- Lambda: `/aws/lambda/anigmaa-backend`
- API Gateway: `/aws/apigateway/anigmaa`

### Key Metrics
- Lambda: Duration, Errors, Throttles
- API Gateway: 4XX, 5XX errors, latency
- RDS: CPU, connections
- ElastiCache: CPU, evictions

## Useful Commands

```bash
# Tail Lambda logs
aws logs tail /aws/lambda/anigmaa-backend --follow

# Get Lambda metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/Lambda \
  --metric-name Duration \
  --dimensions Name=FunctionName,Value=anigmaa-backend

# Invoke Lambda manually
aws lambda invoke \
  --function-name anigmaa-backend \
  --payload '{"path":"/health","requestContext":{"http":{"method":"GET"}}}' \
  response.json
```

## References
- [AWS Lambda Best Practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
- [API Gateway HTTP API](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
- [Lambda in VPC](https://docs.aws.amazon.com/lambda/latest/dg/vpc.html)
