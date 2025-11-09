# ☁️ AWS Complete Guide - Cloud Infrastructure Mastery

> **Master Amazon Web Services from fundamentals to production deployments**

---

## 📋 Table of Contents

1. [Introduction to AWS](#introduction-to-aws)
2. [AWS Account Setup](#aws-account-setup)
3. [IAM - Identity & Access Management](#iam---identity--access-management)
4. [EC2 - Elastic Compute Cloud](#ec2---elastic-compute-cloud)
5. [S3 - Simple Storage Service](#s3---simple-storage-service)
6. [RDS - Relational Database Service](#rds---relational-database-service)
7. [Lambda - Serverless Functions](#lambda---serverless-functions)
8. [API Gateway](#api-gateway)
9. [DynamoDB - NoSQL Database](#dynamodb---nosql-database)
10. [CloudFront - CDN](#cloudfront---cdn)
11. [Route 53 - DNS](#route-53---dns)
12. [VPC - Virtual Private Cloud](#vpc---virtual-private-cloud)
13. [ECS/EKS - Container Services](#ecseks---container-services)
14. [CloudWatch - Monitoring](#cloudwatch---monitoring)
15. [SNS & SQS - Messaging](#sns--sqs---messaging)
16. [Infrastructure as Code](#infrastructure-as-code)
17. [Deployment Strategies](#deployment-strategies)
18. [Cost Optimization](#cost-optimization)
19. [Security Best Practices](#security-best-practices)
20. [Real-World Architectures](#real-world-architectures)

---

## Introduction to AWS

### What is AWS?

Amazon Web Services (AWS) is a **comprehensive cloud platform** offering:
- **Compute** - EC2, Lambda, ECS, EKS
- **Storage** - S3, EBS, EFS
- **Database** - RDS, DynamoDB, Aurora
- **Networking** - VPC, CloudFront, Route 53
- **Security** - IAM, KMS, Secrets Manager
- **DevOps** - CodePipeline, CodeBuild, CodeDeploy
- **Serverless** - Lambda, API Gateway, Step Functions

### AWS Global Infrastructure

- **Regions** - Geographic locations (us-east-1, eu-west-1)
- **Availability Zones** - Isolated data centers within regions
- **Edge Locations** - CDN caching locations worldwide

### AWS Pricing Model

- **Pay-as-you-go** - Only pay for what you use
- **Reserved Instances** - Commit for 1-3 years, save up to 75%
- **Spot Instances** - Bid on spare capacity, save up to 90%
- **Free Tier** - 12 months of free services for new accounts

---

## AWS Account Setup

### Creating an Account

```bash
# 1. Go to https://aws.amazon.com/
# 2. Click "Create an AWS Account"
# 3. Provide email, password, account name
# 4. Add payment information
# 5. Verify phone number
# 6. Choose support plan (Basic is free)
```

### Installing AWS CLI

```bash
# macOS
brew install awscli

# Linux
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Windows
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Verify installation
aws --version
```

### Configure AWS CLI

```bash
# Configure credentials
aws configure

# Enter:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Default output format (json)

# Test configuration
aws sts get-caller-identity
```

### AWS CLI Profiles

```bash
# Configure named profile
aws configure --profile production

# Use profile
aws s3 ls --profile production

# Set default profile
export AWS_PROFILE=production

# List all profiles
aws configure list-profiles
```

---

## IAM - Identity & Access Management

### IAM Core Concepts

- **Users** - Individual people or applications
- **Groups** - Collections of users
- **Roles** - Temporary credentials for services
- **Policies** - Permissions documents (JSON)

### Creating IAM User

```bash
# Create user
aws iam create-user --user-name developer

# Create access key
aws iam create-access-key --user-name developer

# Attach policy
aws iam attach-user-policy \
  --user-name developer \
  --policy-arn arn:aws:iam::aws:policy/ReadOnlyAccess
```

### IAM Policy Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::my-bucket/*"
    },
    {
      "Effect": "Deny",
      "Action": "s3:DeleteBucket",
      "Resource": "*"
    }
  ]
}
```

### Common IAM Policies

```json
// S3 Full Access
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}

// EC2 Read-Only
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:Get*"
      ],
      "Resource": "*"
    }
  ]
}

// Lambda Execution Role
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
```

### Creating IAM Roles

```bash
# Create trust policy
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create role
aws iam create-role \
  --role-name LambdaExecutionRole \
  --assume-role-policy-document file://trust-policy.json

# Attach policy
aws iam attach-role-policy \
  --role-name LambdaExecutionRole \
  --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

### IAM Best Practices

- ✅ Enable MFA for root account
- ✅ Use IAM roles for EC2 instances
- ✅ Follow principle of least privilege
- ✅ Rotate credentials regularly
- ✅ Use IAM groups for user permissions
- ✅ Enable CloudTrail for auditing
- ❌ Never use root account for daily tasks
- ❌ Never hardcode credentials in code

---

## EC2 - Elastic Compute Cloud

### Instance Types

```
General Purpose:  t3, t4g, m5, m6i
Compute Optimized: c5, c6i, c7g
Memory Optimized:  r5, r6i, x2i
Storage Optimized: i3, i4i, d2
GPU Instances:     p3, p4, g4dn

Example:
t3.micro   - 2 vCPU, 1 GB RAM   (Free tier)
t3.small   - 2 vCPU, 2 GB RAM
t3.medium  - 2 vCPU, 4 GB RAM
m5.large   - 2 vCPU, 8 GB RAM
c5.xlarge  - 4 vCPU, 8 GB RAM
```

### Launching EC2 Instance (AWS CLI)

```bash
# Create key pair
aws ec2 create-key-pair \
  --key-name my-key \
  --query 'KeyMaterial' \
  --output text > my-key.pem

chmod 400 my-key.pem

# Create security group
aws ec2 create-security-group \
  --group-name web-server-sg \
  --description "Web server security group"

# Allow SSH and HTTP
aws ec2 authorize-security-group-ingress \
  --group-name web-server-sg \
  --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
  --group-name web-server-sg \
  --protocol tcp --port 80 --cidr 0.0.0.0/0

# Launch instance
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t3.micro \
  --key-name my-key \
  --security-groups web-server-sg \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer}]'
```

### User Data Script

```bash
#!/bin/bash
# This script runs on first boot

# Update system
yum update -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install PM2
npm install -g pm2

# Clone application
cd /home/ec2-user
git clone https://github.com/yourapp/app.git
cd app
npm install

# Start application
pm2 start npm --name "app" -- start
pm2 startup
pm2 save

# Install and configure nginx
amazon-linux-extras install nginx1 -y
systemctl start nginx
systemctl enable nginx
```

### Connect to EC2

```bash
# SSH to instance
ssh -i my-key.pem ec2-user@<public-ip>

# Using Session Manager (no SSH key needed)
aws ssm start-session --target <instance-id>
```

### EC2 Instance Metadata

```bash
# From inside EC2 instance
# Get instance ID
curl http://169.254.169.254/latest/meta-data/instance-id

# Get public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Get IAM role
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Get user data
curl http://169.254.169.254/latest/user-data
```

### Auto Scaling

```bash
# Create launch template
aws ec2 create-launch-template \
  --launch-template-name my-template \
  --version-description "Version 1" \
  --launch-template-data '{
    "ImageId": "ami-0c55b159cbfafe1f0",
    "InstanceType": "t3.micro",
    "KeyName": "my-key",
    "SecurityGroupIds": ["sg-12345678"]
  }'

# Create auto scaling group
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name my-asg \
  --launch-template LaunchTemplateName=my-template \
  --min-size 1 \
  --max-size 5 \
  --desired-capacity 2 \
  --availability-zones us-east-1a us-east-1b

# Create scaling policy (CPU-based)
aws autoscaling put-scaling-policy \
  --auto-scaling-group-name my-asg \
  --policy-name scale-up \
  --scaling-adjustment 1 \
  --adjustment-type ChangeInCapacity
```

---

## S3 - Simple Storage Service

### S3 Basics

```bash
# Create bucket
aws s3 mb s3://my-unique-bucket-name

# List buckets
aws s3 ls

# Upload file
aws s3 cp file.txt s3://my-bucket/

# Upload directory
aws s3 cp ./dist s3://my-bucket/ --recursive

# Download file
aws s3 cp s3://my-bucket/file.txt ./

# List bucket contents
aws s3 ls s3://my-bucket/

# Delete file
aws s3 rm s3://my-bucket/file.txt

# Delete bucket
aws s3 rb s3://my-bucket --force
```

### S3 Sync (Deploy Website)

```bash
# Sync local directory to S3
aws s3 sync ./dist s3://my-website-bucket/ \
  --delete \
  --acl public-read

# Sync with cache control
aws s3 sync ./dist s3://my-website-bucket/ \
  --cache-control "max-age=31536000,public" \
  --exclude "*.html" \
  --delete

# HTML files with no cache
aws s3 sync ./dist s3://my-website-bucket/ \
  --cache-control "no-cache" \
  --include "*.html" \
  --exclude "*"
```

### S3 Bucket Policy (Public Website)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-website-bucket/*"
    }
  ]
}
```

### Enable Static Website Hosting

```bash
# Configure website
aws s3 website s3://my-website-bucket/ \
  --index-document index.html \
  --error-document error.html

# Website URL: http://my-website-bucket.s3-website-us-east-1.amazonaws.com
```

### S3 CORS Configuration

```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "POST", "PUT"],
    "AllowedOrigins": ["https://myapp.com"],
    "ExposeHeaders": ["ETag"]
  }
]
```

### S3 Lifecycle Rules

```json
{
  "Rules": [
    {
      "Id": "MoveToGlacier",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 30,
          "StorageClass": "STANDARD_IA"
        },
        {
          "Days": 90,
          "StorageClass": "GLACIER"
        }
      ],
      "Expiration": {
        "Days": 365
      }
    }
  ]
}
```

### S3 with Node.js SDK

```typescript
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';

const s3 = new S3Client({ region: 'us-east-1' });

// Upload file
async function uploadFile(file: Buffer, key: string) {
  await s3.send(new PutObjectCommand({
    Bucket: 'my-bucket',
    Key: key,
    Body: file,
    ContentType: 'image/jpeg',
  }));
}

// Download file
async function downloadFile(key: string) {
  const response = await s3.send(new GetObjectCommand({
    Bucket: 'my-bucket',
    Key: key,
  }));
  
  return response.Body;
}

// Generate presigned URL
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';

async function getUploadUrl(key: string) {
  const command = new PutObjectCommand({
    Bucket: 'my-bucket',
    Key: key,
  });
  
  return await getSignedUrl(s3, command, { expiresIn: 3600 });
}
```

---

## RDS - Relational Database Service

### Supported Databases

- PostgreSQL
- MySQL
- MariaDB
- Oracle
- SQL Server
- Aurora (MySQL & PostgreSQL compatible)

### Create RDS Instance

```bash
# Create DB subnet group
aws rds create-db-subnet-group \
  --db-subnet-group-name my-db-subnet \
  --db-subnet-group-description "My DB subnet group" \
  --subnet-ids subnet-12345 subnet-67890

# Create PostgreSQL instance
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version 15.2 \
  --master-username admin \
  --master-user-password MySecurePass123! \
  --allocated-storage 20 \
  --storage-type gp3 \
  --vpc-security-group-ids sg-12345678 \
  --db-subnet-group-name my-db-subnet \
  --backup-retention-period 7 \
  --preferred-backup-window "03:00-04:00" \
  --preferred-maintenance-window "sun:04:00-sun:05:00" \
  --publicly-accessible \
  --tags Key=Name,Value=MyDatabase
```

### Connect to RDS

```bash
# Get endpoint
aws rds describe-db-instances \
  --db-instance-identifier mydb \
  --query 'DBInstances[0].Endpoint.Address' \
  --output text

# Connect with psql
psql -h mydb.123456789012.us-east-1.rds.amazonaws.com \
  -U admin \
  -d postgres

# Connection string
postgresql://admin:password@mydb.123456789012.us-east-1.rds.amazonaws.com:5432/mydb
```

### RDS with Prisma

```prisma
// prisma/schema.prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id    String @id @default(cuid())
  email String @unique
  name  String
}
```

```bash
# .env
DATABASE_URL="postgresql://admin:password@mydb.rds.amazonaws.com:5432/mydb"

# Run migrations
bunx prisma migrate deploy
```

### RDS Snapshots

```bash
# Create snapshot
aws rds create-db-snapshot \
  --db-instance-identifier mydb \
  --db-snapshot-identifier mydb-snapshot-$(date +%Y%m%d)

# List snapshots
aws rds describe-db-snapshots \
  --db-instance-identifier mydb

# Restore from snapshot
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier mydb-restored \
  --db-snapshot-identifier mydb-snapshot-20250115
```

### RDS Read Replicas

```bash
# Create read replica
aws rds create-db-instance-read-replica \
  --db-instance-identifier mydb-replica \
  --source-db-instance-identifier mydb \
  --db-instance-class db.t3.micro
```

---

## Lambda - Serverless Functions

### Lambda Basics

```javascript
// index.js
export const handler = async (event) => {
  console.log('Event:', JSON.stringify(event));
  
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: 'Hello from Lambda!',
      input: event,
    }),
  };
};
```

### Create Lambda Function

```bash
# Package function
zip function.zip index.js

# Create function
aws lambda create-function \
  --function-name my-function \
  --runtime nodejs18.x \
  --role arn:aws:iam::123456789012:role/LambdaExecutionRole \
  --handler index.handler \
  --zip-file fileb://function.zip

# Invoke function
aws lambda invoke \
  --function-name my-function \
  --payload '{"name": "World"}' \
  response.json

cat response.json
```

### Lambda with TypeScript

```typescript
// handler.ts
import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  const body = JSON.parse(event.body || '{}');
  
  return {
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
    body: JSON.stringify({
      message: 'Success',
      data: body,
    }),
  };
};
```

### Lambda Environment Variables

```bash
# Set environment variables
aws lambda update-function-configuration \
  --function-name my-function \
  --environment Variables="{DB_HOST=mydb.rds.amazonaws.com,API_KEY=secret}"
```

### Lambda Layers

```bash
# Create layer
mkdir nodejs
cd nodejs
npm install axios
cd ..
zip -r layer.zip nodejs

# Publish layer
aws lambda publish-layer-version \
  --layer-name my-dependencies \
  --zip-file fileb://layer.zip \
  --compatible-runtimes nodejs18.x

# Add layer to function
aws lambda update-function-configuration \
  --function-name my-function \
  --layers arn:aws:lambda:us-east-1:123456789012:layer:my-dependencies:1
```

### Lambda Triggers

```bash
# S3 trigger
aws lambda add-permission \
  --function-name my-function \
  --statement-id s3-trigger \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::my-bucket

# EventBridge (CloudWatch Events)
aws events put-rule \
  --name daily-task \
  --schedule-expression "rate(1 day)"

aws events put-targets \
  --rule daily-task \
  --targets "Id"="1","Arn"="arn:aws:lambda:us-east-1:123456789012:function:my-function"
```

---

## API Gateway

### Create REST API

```bash
# Create API
aws apigateway create-rest-api \
  --name my-api \
  --description "My REST API"

# Get root resource
aws apigateway get-resources \
  --rest-api-id abc123

# Create resource
aws apigateway create-resource \
  --rest-api-id abc123 \
  --parent-id xyz789 \
  --path-part users

# Create method
aws apigateway put-method \
  --rest-api-id abc123 \
  --resource-id def456 \
  --http-method GET \
  --authorization-type NONE

# Integrate with Lambda
aws apigateway put-integration \
  --rest-api-id abc123 \
  --resource-id def456 \
  --http-method GET \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:my-function/invocations

# Deploy API
aws apigateway create-deployment \
  --rest-api-id abc123 \
  --stage-name prod
```

### API Gateway with Lambda (Serverless Framework)

```yaml
# serverless.yml
service: my-api

provider:
  name: aws
  runtime: nodejs18.x
  region: us-east-1

functions:
  getUser:
    handler: handler.getUser
    events:
      - http:
          path: users/{id}
          method: get
          cors: true
  
  createUser:
    handler: handler.createUser
    events:
      - http:
          path: users
          method: post
          cors: true
```

### CORS Configuration

```javascript
export const handler = async (event) => {
  return {
    statusCode: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type,Authorization',
      'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
    },
    body: JSON.stringify({ message: 'Success' }),
  };
};
```

---

## DynamoDB - NoSQL Database

### Create Table

```bash
# Create table
aws dynamodb create-table \
  --table-name Users \
  --attribute-definitions \
    AttributeName=userId,AttributeType=S \
    AttributeName=email,AttributeType=S \
  --key-schema \
    AttributeName=userId,KeyType=HASH \
  --global-secondary-indexes \
    "[{\"IndexName\":\"EmailIndex\",\"KeySchema\":[{\"AttributeName\":\"email\",\"KeyType\":\"HASH\"}],\"Projection\":{\"ProjectionType\":\"ALL\"},\"ProvisionedThroughput\":{\"ReadCapacityUnits\":5,\"WriteCapacityUnits\":5}}]" \
  --billing-mode PAY_PER_REQUEST
```

### DynamoDB Operations

```typescript
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { DynamoDBDocumentClient, PutCommand, GetCommand, QueryCommand, UpdateCommand, DeleteCommand } from '@aws-sdk/lib-dynamodb';

const client = new DynamoDBClient({ region: 'us-east-1' });
const dynamodb = DynamoDBDocumentClient.from(client);

// Put item
await dynamodb.send(new PutCommand({
  TableName: 'Users',
  Item: {
    userId: '123',
    email: 'user@example.com',
    name: 'John Doe',
    createdAt: new Date().toISOString(),
  },
}));

// Get item
const result = await dynamodb.send(new GetCommand({
  TableName: 'Users',
  Key: { userId: '123' },
}));

// Query by index
const users = await dynamodb.send(new QueryCommand({
  TableName: 'Users',
  IndexName: 'EmailIndex',
  KeyConditionExpression: 'email = :email',
  ExpressionAttributeValues: {
    ':email': 'user@example.com',
  },
}));

// Update item
await dynamodb.send(new UpdateCommand({
  TableName: 'Users',
  Key: { userId: '123' },
  UpdateExpression: 'set #name = :name, updatedAt = :updatedAt',
  ExpressionAttributeNames: {
    '#name': 'name',
  },
  ExpressionAttributeValues: {
    ':name': 'Jane Doe',
    ':updatedAt': new Date().toISOString(),
  },
}));

// Delete item
await dynamodb.send(new DeleteCommand({
  TableName: 'Users',
  Key: { userId: '123' },
}));
```

---

## CloudFront - CDN

### Create CloudFront Distribution

```bash
# Create distribution config
cat > distribution-config.json << EOF
{
  "CallerReference": "my-distribution-$(date +%s)",
  "Comment": "My CloudFront Distribution",
  "Enabled": true,
  "Origins": {
    "Quantity": 1,
    "Items": [
      {
        "Id": "S3-my-bucket",
        "DomainName": "my-bucket.s3.amazonaws.com",
        "S3OriginConfig": {
          "OriginAccessIdentity": ""
        }
      }
    ]
  },
  "DefaultCacheBehavior": {
    "TargetOriginId": "S3-my-bucket",
    "ViewerProtocolPolicy": "redirect-to-https",
    "AllowedMethods": {
      "Quantity": 2,
      "Items": ["GET", "HEAD"]
    },
    "ForwardedValues": {
      "QueryString": false,
      "Cookies": { "Forward": "none" }
    },
    "MinTTL": 0,
    "DefaultTTL": 86400,
    "MaxTTL": 31536000
  }
}
EOF

# Create distribution
aws cloudfront create-distribution \
  --distribution-config file://distribution-config.json
```

### Invalidate Cache

```bash
# Invalidate all files
aws cloudfront create-invalidation \
  --distribution-id E1234567890ABC \
  --paths "/*"

# Invalidate specific paths
aws cloudfront create-invalidation \
  --distribution-id E1234567890ABC \
  --paths "/index.html" "/css/*" "/js/*"
```

---

## Route 53 - DNS

### Create Hosted Zone

```bash
# Create hosted zone
aws route53 create-hosted-zone \
  --name example.com \
  --caller-reference $(date +%s)

# List hosted zones
aws route53 list-hosted-zones
```

### Create DNS Records

```json
{
  "Changes": [
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "www.example.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z2FDTNDATAQYW2",
          "DNSName": "d111111abcdef8.cloudfront.net",
          "EvaluateTargetHealth": false
        }
      }
    },
    {
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "api.example.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          { "Value": "my-load-balancer.us-east-1.elb.amazonaws.com" }
        ]
      }
    }
  ]
}
```

```bash
# Apply changes
aws route53 change-resource-record-sets \
  --hosted-zone-id Z1234567890ABC \
  --change-batch file://records.json
```

---

## VPC - Virtual Private Cloud

### VPC Architecture

```
VPC (10.0.0.0/16)
├── Public Subnet 1 (10.0.1.0/24) - us-east-1a
│   ├── Internet Gateway
│   ├── NAT Gateway
│   └── Load Balancer
├── Public Subnet 2 (10.0.2.0/24) - us-east-1b
│   └── NAT Gateway
├── Private Subnet 1 (10.0.10.0/24) - us-east-1a
│   ├── EC2 Instances
│   └── Lambda (ENI)
├── Private Subnet 2 (10.0.11.0/24) - us-east-1b
│   └── EC2 Instances
├── Database Subnet 1 (10.0.20.0/24) - us-east-1a
│   └── RDS
└── Database Subnet 2 (10.0.21.0/24) - us-east-1b
    └── RDS Replica
```

### Create VPC

```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnets
aws ec2 create-subnet \
  --vpc-id vpc-12345678 \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a

# Create internet gateway
aws ec2 create-internet-gateway

# Attach to VPC
aws ec2 attach-internet-gateway \
  --internet-gateway-id igw-12345678 \
  --vpc-id vpc-12345678

# Create route table
aws ec2 create-route-table --vpc-id vpc-12345678

# Add route to internet
aws ec2 create-route \
  --route-table-id rtb-12345678 \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-12345678
```

---

## ECS/EKS - Container Services

### ECS with Fargate

```bash
# Create cluster
aws ecs create-cluster --cluster-name my-cluster

# Register task definition
cat > task-definition.json << EOF
{
  "family": "my-app",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "app",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/my-app",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
}
EOF

aws ecs register-task-definition --cli-input-json file://task-definition.json

# Create service
aws ecs create-service \
  --cluster my-cluster \
  --service-name my-service \
  --task-definition my-app \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-12345],securityGroups=[sg-12345],assignPublicIp=ENABLED}"
```

---

## CloudWatch - Monitoring

### CloudWatch Metrics

```bash
# List metrics
aws cloudwatch list-metrics --namespace AWS/EC2

# Get metric statistics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --start-time 2025-01-15T00:00:00Z \
  --end-time 2025-01-15T23:59:59Z \
  --period 3600 \
  --statistics Average,Maximum
```

### CloudWatch Alarms

```bash
# Create alarm
aws cloudwatch put-metric-alarm \
  --alarm-name high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --evaluation-periods 2 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0
```

### CloudWatch Logs

```typescript
import { CloudWatchLogsClient, PutLogEventsCommand } from '@aws-sdk/client-cloudwatch-logs';

const client = new CloudWatchLogsClient({ region: 'us-east-1' });

await client.send(new PutLogEventsCommand({
  logGroupName: '/aws/lambda/my-function',
  logStreamName: '2025/01/15/[$LATEST]abcd1234',
  logEvents: [
    {
      message: 'Application started',
      timestamp: Date.now(),
    },
  ],
}));
```

---

## SNS & SQS - Messaging

### SNS (Simple Notification Service)

```bash
# Create topic
aws sns create-topic --name my-topic

# Subscribe email
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-topic \
  --protocol email \
  --notification-endpoint user@example.com

# Publish message
aws sns publish \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-topic \
  --message "Hello from SNS"
```

### SQS (Simple Queue Service)

```bash
# Create queue
aws sqs create-queue --queue-name my-queue

# Send message
aws sqs send-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --message-body "Hello from SQS"

# Receive messages
aws sqs receive-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue

# Delete message
aws sqs delete-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --receipt-handle "receipt-handle-string"
```

---

## Infrastructure as Code

### AWS CDK (TypeScript)

```typescript
import * as cdk from 'aws-cdk-lib';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as apigateway from 'aws-cdk-lib/aws-apigateway';

export class MyStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // S3 bucket
    const bucket = new s3.Bucket(this, 'MyBucket', {
      versioned: true,
      encryption: s3.BucketEncryption.S3_MANAGED,
      removalPolicy: cdk.RemovalPolicy.DESTROY,
    });

    // Lambda function
    const handler = new lambda.Function(this, 'MyFunction', {
      runtime: lambda.Runtime.NODEJS_18_X,
      code: lambda.Code.fromAsset('lambda'),
      handler: 'index.handler',
      environment: {
        BUCKET_NAME: bucket.bucketName,
      },
    });

    bucket.grantReadWrite(handler);

    // API Gateway
    const api = new apigateway.RestApi(this, 'MyApi', {
      restApiName: 'My Service',
    });

    const integration = new apigateway.LambdaIntegration(handler);
    api.root.addMethod('GET', integration);
  }
}
```

### Terraform

```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website" {
  bucket = "my-website-bucket"
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.website.id}"
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.website.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
```

---

## Deployment Strategies

### Blue-Green Deployment

```bash
# Deploy new version (green)
aws ecs update-service \
  --cluster my-cluster \
  --service my-service-green \
  --task-definition my-app:2 \
  --desired-count 2

# Test green environment
# Once verified, switch traffic

# Update load balancer target groups
# Decommission blue environment
```

### Canary Deployment

```yaml
# CodeDeploy AppSpec
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "my-task:2"
        LoadBalancerInfo:
          ContainerName: "app"
          ContainerPort: 3000
Hooks:
  - BeforeInstall: "LambdaFunctionToValidateBeforeInstall"
  - AfterInstall: "LambdaFunctionToValidateAfterInstall"
  - AfterAllowTestTraffic: "LambdaFunctionToValidateAfterTestTraffic"
```

---

## Cost Optimization

### Cost Optimization Strategies

1. **Right-sizing** - Use appropriate instance types
2. **Reserved Instances** - Commit for 1-3 years
3. **Spot Instances** - Use for fault-tolerant workloads
4. **Auto Scaling** - Scale based on demand
5. **S3 Lifecycle Policies** - Move to cheaper storage tiers
6. **CloudFront** - Reduce data transfer costs
7. **Lambda** - Pay only for execution time
8. **Monitoring** - Track spending with Cost Explorer

### AWS Cost Explorer

```bash
# Get cost and usage
aws ce get-cost-and-usage \
  --time-period Start=2025-01-01,End=2025-01-31 \
  --granularity MONTHLY \
  --metrics "BlendedCost" \
  --group-by Type=DIMENSION,Key=SERVICE
```

---

## Security Best Practices

### Security Checklist

- ✅ Enable MFA on root account
- ✅ Use IAM roles instead of access keys
- ✅ Encrypt data at rest (S3, RDS, EBS)
- ✅ Encrypt data in transit (HTTPS, TLS)
- ✅ Enable CloudTrail for auditing
- ✅ Use VPC for network isolation
- ✅ Regular security assessments
- ✅ Patch and update regularly
- ✅ Use AWS Secrets Manager for credentials
- ✅ Enable GuardDuty for threat detection

### AWS Secrets Manager

```typescript
import { SecretsManagerClient, GetSecretValueCommand } from '@aws-sdk/client-secrets-manager';

const client = new SecretsManagerClient({ region: 'us-east-1' });

async function getSecret(secretName: string) {
  const response = await client.send(
    new GetSecretValueCommand({ SecretId: secretName })
  );
  
  return JSON.parse(response.SecretString!);
}

// Usage
const dbCreds = await getSecret('prod/db/credentials');
const connectionString = `postgresql://${dbCreds.username}:${dbCreds.password}@${dbCreds.host}:5432/mydb`;
```

---

## Real-World Architectures

### Serverless Web App

```
Client (Browser)
  ↓
CloudFront (CDN)
  ↓
S3 (Static Website)
  ↓
API Gateway
  ↓
Lambda Functions
  ↓
DynamoDB / RDS

Cost: ~$5-50/month for small apps
```

### Traditional Web App

```
Route 53 (DNS)
  ↓
CloudFront (CDN)
  ↓
Application Load Balancer
  ↓
EC2 Auto Scaling Group (2-10 instances)
  ↓
RDS (Multi-AZ)
  ↓
S3 (File Storage)

Cost: ~$100-500/month
```

### Microservices Architecture

```
Route 53
  ↓
API Gateway
  ↓
Lambda / ECS Fargate (Microservices)
  ↓
├── DynamoDB
├── RDS
├── ElastiCache
├── SQS
└── SNS

Cost: $200-2000/month depending on scale
```

---

## 🎯 Practice Projects

### Project 1: Static Website Hosting
- S3 bucket for static files
- CloudFront distribution
- Route 53 for custom domain
- CI/CD with GitHub Actions

### Project 2: Serverless API
- API Gateway + Lambda
- DynamoDB for data
- Cognito for auth
- CloudWatch for logs

### Project 3: Full-Stack Application
- EC2 with Auto Scaling
- RDS for database
- S3 for file uploads
- Load Balancer + CloudFront

### Project 4: Container Deployment
- ECS Fargate
- ECR for Docker images
- RDS for database
- CloudWatch for monitoring

---

## 📚 Resources

- **AWS Documentation**: https://docs.aws.amazon.com/
- **AWS Free Tier**: https://aws.amazon.com/free/
- **AWS CLI Reference**: https://awscli.amazonaws.com/v2/documentation/api/latest/index.html
- **AWS CDK**: https://aws.amazon.com/cdk/
- **AWS Well-Architected**: https://aws.amazon.com/architecture/well-architected/

**You're now ready to build production applications on AWS!** 🚀