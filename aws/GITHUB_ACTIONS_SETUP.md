# GitHub Actions CI/CD Setup untuk AWS Lambda + Cloudflare

Panduan setup GitHub Actions untuk automatic deployment ke AWS Lambda.

## Arsitektur CI/CD

```
Push ke main branch
        ↓
GitHub Actions workflow
        ↓
1. Test (go test)
        ↓
2. Build (GOOS=linux go build)
        ↓
3. Deploy Lambda (aws lambda update-function-code)
        ↓
4. Notify (success/failure)
```

## Prerequisites

1. GitHub repository (sudah ada)
2. AWS Account dengan credentials
3. Lambda function sudah di-deploy (dari CLOUDFLARE_SETUP.md)

## Step 1: Setup AWS Credentials di GitHub Secrets

### 1.1 Create IAM User untuk GitHub Actions

Di AWS Console:

```bash
# Atau gunakan AWS CLI:
aws iam create-user --user-name github-actions-anigmaa

# Attach policy untuk Lambda update
aws iam put-user-policy --user-name github-actions-anigmaa \
  --policy-name lambda-update \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:UpdateFunctionCode",
          "lambda:GetFunction"
        ],
        "Resource": "arn:aws:lambda:ap-southeast-1:ACCOUNT_ID:function:anigmaa-backend"
      }
    ]
  }'

# Create access key
aws iam create-access-key --user-name github-actions-anigmaa
```

**Save the Access Key ID dan Secret Access Key!**

### 1.2 Add Secrets ke GitHub Repository

Go to: `https://github.com/YOUR_USERNAME/backend_anigmaa/settings/secrets/actions`

Click **New repository secret** dan add:

1. **AWS_ACCESS_KEY_ID**
   - Value: (dari Step 1.1)

2. **AWS_SECRET_ACCESS_KEY**
   - Value: (dari Step 1.1)

3. **AWS_REGION**
   - Value: `ap-southeast-1`

4. **LAMBDA_FUNCTION_NAME**
   - Value: `anigmaa-backend`

## Step 2: Create GitHub Actions Workflow

Create file: `.github/workflows/deploy-lambda.yml`

```yaml
name: Deploy to AWS Lambda

on:
  push:
    branches:
      - main
    paths:
      - 'cmd/**'
      - 'internal/**'
      - 'pkg/**'
      - 'go.mod'
      - 'go.sum'
      - '.github/workflows/deploy-lambda.yml'
  pull_request:
    branches:
      - main

jobs:
  test:
    runs-on: ubuntu-latest
    name: Test

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: Download dependencies
        run: go mod download

      - name: Run tests
        run: go test -v -race -coverprofile=coverage.out ./...

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage.out
          flags: unittests
          fail_ci_if_error: false

  build:
    needs: test
    runs-on: ubuntu-latest
    name: Build Lambda Binary

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: Download dependencies
        run: go mod download

      - name: Build binary
        run: |
          GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build \
            -o bootstrap \
            -ldflags="-s -w" \
            cmd/server/main.go

      - name: Check binary size
        run: ls -lh bootstrap

      - name: Upload binary as artifact
        uses: actions/upload-artifact@v3
        with:
          name: lambda-binary
          path: bootstrap
          retention-days: 1

  deploy:
    needs: build
    runs-on: ubuntu-latest
    name: Deploy to Lambda
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'

    steps:
      - name: Download binary
        uses: actions/download-artifact@v3
        with:
          name: lambda-binary

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Create deployment package
        run: |
          zip lambda-function.zip bootstrap
          ls -lh lambda-function.zip

      - name: Deploy to Lambda
        run: |
          aws lambda update-function-code \
            --function-name ${{ secrets.LAMBDA_FUNCTION_NAME }} \
            --zip-file fileb://lambda-function.zip \
            --region ${{ secrets.AWS_REGION }}

      - name: Wait for update
        run: sleep 30

      - name: Get function info
        run: |
          aws lambda get-function-configuration \
            --function-name ${{ secrets.LAMBDA_FUNCTION_NAME }} \
            --region ${{ secrets.AWS_REGION }}

      - name: Test Lambda
        run: |
          aws lambda invoke \
            --function-name ${{ secrets.LAMBDA_FUNCTION_NAME }} \
            --region ${{ secrets.AWS_REGION }} \
            --payload '{"requestContext":{"http":{"method":"GET","path":"/health"}},"body":""}' \
            response.json

          cat response.json
          grep -q statusCode response.json || exit 1

      - name: Notify Success
        if: success()
        run: |
          echo "✅ Deployment successful!"
          echo "Function: ${{ secrets.LAMBDA_FUNCTION_NAME }}"
          echo "Region: ${{ secrets.AWS_REGION }}"

      - name: Notify Failure
        if: failure()
        run: |
          echo "❌ Deployment failed!"
          exit 1
```

## Step 3: Optional - Add More Workflows

### 3.1 Lint Workflow

Create file: `.github/workflows/lint.yml`

```yaml
name: Lint and Format

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
    name: Lint

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: golangci-lint
        uses: golangci/golangci-lint-action@v3
        with:
          version: latest

      - name: Go fmt
        run: |
          if [ -n "$(go fmt ./...)" ]; then
            echo "Code must be gofmt'd"
            exit 1
          fi

      - name: Go vet
        run: go vet ./...
```

### 3.2 Security Scan Workflow

Create file: `.github/workflows/security.yml`

```yaml
name: Security Scan

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  schedule:
    - cron: '0 0 * * 0'  # Weekly

jobs:
  security:
    runs-on: ubuntu-latest
    name: Security Scan

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Go
        uses: actions/setup-go@v4
        with:
          go-version: '1.21'

      - name: Run gosec
        uses: securego/gosec@master
        with:
          args: '-no-fail -fmt sarif -out gosec-results.sarif ./...'

      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: gosec-results.sarif
```

## Step 4: Test Workflow Locally (Optional)

Install act untuk test workflow locally:

```bash
# Install act (https://github.com/nektos/act)
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run workflow
act -j test
act -j build
```

## Step 5: Trigger Deployment

### Option A: Push ke main branch

```bash
git add .
git commit -m "Update API endpoint"
git push origin main

# GitHub Actions akan automatically trigger
# Check: https://github.com/YOUR_USERNAME/backend_anigmaa/actions
```

### Option B: Manual workflow dispatch (Optional)

Add input parameter ke workflow untuk manual trigger:

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'production'
        type: choice
        options:
          - production
          - staging
```

Kemudian bisa trigger dari GitHub UI atau CLI:

```bash
gh workflow run deploy-lambda.yml
```

## Monitoring Deployments

### View Workflow Runs

```bash
# List recent runs
gh run list --repo YOUR_USERNAME/backend_anigmaa

# View specific run
gh run view RUN_ID --repo YOUR_USERNAME/backend_anigmaa

# Watch run in real-time
gh run watch RUN_ID --repo YOUR_USERNAME/backend_anigmaa
```

### View Logs

```bash
# Tail logs
gh run view RUN_ID --repo YOUR_USERNAME/backend_anigmaa --log

# Download logs
gh run download RUN_ID --repo YOUR_USERNAME/backend_anigmaa --dir ./logs
```

## Troubleshooting

### Problem 1: AWS Credentials Error

```
Error: InvalidClientTokenId: The security token included in the request is invalid
```

**Solution:**
1. Verify AWS credentials di GitHub Secrets
2. Verify IAM user permissions
3. Check AWS access key is not expired

### Problem 2: Lambda Update Fails

```
Error: ResourceNotFoundException: Function not found
```

**Solution:**
1. Verify LAMBDA_FUNCTION_NAME di GitHub Secrets
2. Verify function exists: `aws lambda get-function --function-name anigmaa-backend`

### Problem 3: Tests Fail

```
FAIL: go test ./...
```

**Solution:**
1. Run tests locally: `go test -v ./...`
2. Fix failing tests
3. Commit dan push

### Problem 4: Build Fails

```
error: go build: compile error
```

**Solution:**
1. Run locally: `GOOS=linux GOARCH=amd64 go build -o bootstrap cmd/server/main.go`
2. Fix errors
3. Test di local machine sebelum push

## Cost Optimization Tips

1. **Limit workflow runs:**
   - Trigger hanya pada main branch
   - Skip jika tidak ada code changes

2. **Cache dependencies:**
   ```yaml
   - name: Cache Go modules
     uses: actions/cache@v3
     with:
       path: ~/go/pkg/mod
       key: ${{ runner.os }}-go-${{ hashFiles('**/go.sum') }}
   ```

3. **Parallel jobs:**
   - Test dan lint bisa jalan parallel
   - Deploy hanya setelah test pass

## Security Best Practices

1. **Never commit credentials:**
   - Use GitHub Secrets, bukan hardcoded values

2. **Limit IAM permissions:**
   - GitHub Actions user hanya perlu `lambda:UpdateFunctionCode`

3. **Rotate credentials regularly:**
   - Change AWS access keys setiap 90 hari

4. **Review workflow:**
   - Audit workflow changes di pull request

5. **Sign commits:**
   ```bash
   git commit -S -m "Message"  # Requires GPG key
   ```

## Next Steps

1. ✅ Create workflow files
2. ✅ Add AWS credentials to secrets
3. ✅ Test workflow on main branch
4. ⏭️ Monitor deployments
5. ⏭️ Add notifications (Slack, email)
6. ⏭️ Add approval steps (for production)

## FAQ

**Q: Bisa batch multiple commits sebelum deploy?**
A: Ya, setiap push ke main akan deploy. Untuk batch, commit semua dulu baru push.

**Q: Bagaimana jika deployment gagal?**
A: Workflow akan fail, tidak akan update Lambda. Fix error, commit, dan push lagi.

**Q: Bisa deploy ke staging dulu?**
A: Ya, tambah environment matrix di workflow untuk test sebelum production.

**Q: Apakah bisa rollback?**
A: Tidak otomatis, tapi bisa manual atau dengan version aliases.

---

**Document Version:** 1.0
**Last Updated:** October 27, 2025
