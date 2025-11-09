# 🚀 GitHub Actions Complete Guide - CI/CD Automation

> **Master GitHub Actions from basics to advanced CI/CD pipelines**

---

## 📋 Table of Contents

1. [Introduction to GitHub Actions](#introduction-to-github-actions)
2. [Workflow Basics](#workflow-basics)
3. [Workflow Syntax](#workflow-syntax)
4. [Events & Triggers](#events--triggers)
5. [Jobs & Steps](#jobs--steps)
6. [Actions Marketplace](#actions-marketplace)
7. [Environment Variables & Secrets](#environment-variables--secrets)
8. [Matrix Builds](#matrix-builds)
9. [Caching Dependencies](#caching-dependencies)
10. [Artifacts](#artifacts)
11. [Testing Automation](#testing-automation)
12. [Docker Integration](#docker-integration)
13. [Deployment Workflows](#deployment-workflows)
14. [Advanced Patterns](#advanced-patterns)
15. [Self-Hosted Runners](#self-hosted-runners)
16. [Security Best Practices](#security-best-practices)
17. [Troubleshooting](#troubleshooting)
18. [Real-World Examples](#real-world-examples)

---

## Introduction to GitHub Actions

### What is GitHub Actions?

GitHub Actions is a **CI/CD platform** that allows you to:
- **Automate workflows** - Build, test, deploy
- **Respond to events** - Push, PR, issues, releases
- **Run on GitHub** - No external CI service needed
- **Use marketplace actions** - Pre-built actions
- **Run anywhere** - Linux, Windows, macOS, containers

### Key Concepts

```
Workflow
  └── Event (trigger)
      └── Job(s)
          └── Step(s)
              └── Action(s)
```

- **Workflow** - Automated process defined in YAML
- **Event** - Trigger that starts a workflow
- **Job** - Set of steps that run on the same runner
- **Step** - Individual task (run command or action)
- **Action** - Reusable unit of code
- **Runner** - Server that runs workflows

### Pricing

- **Public repos** - Unlimited free minutes
- **Private repos** - 2,000 free minutes/month (Free plan)
- **Self-hosted runners** - Free

---

## Workflow Basics

### Creating Your First Workflow

```yaml
# .github/workflows/hello-world.yml
name: Hello World

on: [push]

jobs:
  greet:
    runs-on: ubuntu-latest
    steps:
      - name: Say Hello
        run: echo "Hello, World!"
```

### Workflow Location

```
repository/
└── .github/
    └── workflows/
        ├── ci.yml
        ├── deploy.yml
        └── test.yml
```

### Basic Workflow Structure

```yaml
name: CI Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm install
      
      - name: Run tests
        run: npm test
```

---

## Workflow Syntax

### Name and Description

```yaml
name: Production Deployment

# Optional description
run-name: Deploy to prod by @${{ github.actor }}
```

### On (Triggers)

```yaml
# Single event
on: push

# Multiple events
on: [push, pull_request]

# Event with filters
on:
  push:
    branches:
      - main
      - develop
    paths:
      - 'src/**'
      - '!src/docs/**'
```

### Jobs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building..."
  
  test:
    needs: build  # Wait for build job
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing..."
  
  deploy:
    needs: [build, test]  # Wait for multiple jobs
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying..."
```

### Steps

```yaml
steps:
  # Run command
  - name: Echo message
    run: echo "Hello"
  
  # Use action
  - name: Checkout code
    uses: actions/checkout@v4
  
  # Multi-line script
  - name: Run script
    run: |
      echo "Line 1"
      echo "Line 2"
      npm install
  
  # Conditional step
  - name: Deploy
    if: github.ref == 'refs/heads/main'
    run: npm run deploy
```

---

## Events & Triggers

### Push Event

```yaml
on:
  push:
    branches:
      - main
      - 'releases/**'  # Pattern matching
    tags:
      - v1.*
    paths:
      - 'src/**'
      - 'package.json'
    paths-ignore:
      - 'docs/**'
      - '**.md'
```

### Pull Request Event

```yaml
on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
    branches:
      - main
```

### Schedule (Cron)

```yaml
on:
  schedule:
    # Run every day at 2am UTC
    - cron: '0 2 * * *'
    # Run every Monday at 9am UTC
    - cron: '0 9 * * 1'
```

### Manual Trigger (workflow_dispatch)

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy to'
        required: true
        default: 'staging'
        type: choice
        options:
          - staging
          - production
      version:
        description: 'Version to deploy'
        required: false
        type: string

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: |
          echo "Deploying to ${{ inputs.environment }}"
          echo "Version: ${{ inputs.version }}"
```

### Issue and PR Events

```yaml
on:
  issues:
    types: [opened, labeled]
  
  issue_comment:
    types: [created]
  
  pull_request_review:
    types: [submitted]
```

### Release Event

```yaml
on:
  release:
    types: [published]
```

---

## Jobs & Steps

### Runner Types

```yaml
jobs:
  ubuntu-job:
    runs-on: ubuntu-latest  # Also: ubuntu-22.04, ubuntu-20.04
  
  macos-job:
    runs-on: macos-latest   # Also: macos-12, macos-11
  
  windows-job:
    runs-on: windows-latest # Also: windows-2022, windows-2019
```

### Job Dependencies

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building"
  
  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "Testing"
  
  deploy:
    needs: [build, test]
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying"
```

### Job Outputs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.get-version.outputs.version }}
    steps:
      - uses: actions/checkout@v4
      
      - name: Get version
        id: get-version
        run: |
          VERSION=$(node -p "require('./package.json').version")
          echo "version=$VERSION" >> $GITHUB_OUTPUT
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Deploy version
        run: echo "Deploying version ${{ needs.build.outputs.version }}"
```

### Conditional Execution

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    # Only run on main branch
    if: github.ref == 'refs/heads/main'
    steps:
      - run: echo "Deploying to production"

steps:
  # Run only on success
  - name: Success notification
    if: success()
    run: echo "Tests passed!"
  
  # Run only on failure
  - name: Failure notification
    if: failure()
    run: echo "Tests failed!"
  
  # Run always
  - name: Cleanup
    if: always()
    run: echo "Cleaning up..."
  
  # Custom conditions
  - name: Deploy to staging
    if: github.event_name == 'pull_request'
    run: npm run deploy:staging
```

---

## Actions Marketplace

### Common Actions

```yaml
steps:
  # Checkout code
  - uses: actions/checkout@v4
    with:
      fetch-depth: 0  # Fetch all history
  
  # Setup Node.js
  - uses: actions/setup-node@v4
    with:
      node-version: '18'
      cache: 'npm'
  
  # Setup Python
  - uses: actions/setup-python@v5
    with:
      python-version: '3.11'
  
  # Setup Go
  - uses: actions/setup-go@v5
    with:
      go-version: '1.21'
  
  # Setup Bun
  - uses: oven-sh/setup-bun@v1
    with:
      bun-version: latest
  
  # Docker login
  - uses: docker/login-action@v3
    with:
      username: ${{ secrets.DOCKER_USERNAME }}
      password: ${{ secrets.DOCKER_PASSWORD }}
  
  # Build and push Docker image
  - uses: docker/build-push-action@v5
    with:
      push: true
      tags: user/app:latest
  
  # Deploy to Vercel
  - uses: amondnet/vercel-action@v25
    with:
      vercel-token: ${{ secrets.VERCEL_TOKEN }}
      vercel-org-id: ${{ secrets.ORG_ID }}
      vercel-project-id: ${{ secrets.PROJECT_ID }}
```

### Creating Custom Actions

```yaml
# action.yml
name: 'Hello World Action'
description: 'Greet someone'
inputs:
  who-to-greet:
    description: 'Who to greet'
    required: true
    default: 'World'
outputs:
  time:
    description: 'The time we greeted you'
runs:
  using: 'node20'
  main: 'index.js'
```

```javascript
// index.js
const core = require('@actions/core');
const github = require('@actions/github');

try {
  const nameToGreet = core.getInput('who-to-greet');
  console.log(`Hello ${nameToGreet}!`);
  
  const time = new Date().toTimeString();
  core.setOutput('time', time);
  
  const payload = JSON.stringify(github.context.payload, undefined, 2);
  console.log(`The event payload: ${payload}`);
} catch (error) {
  core.setFailed(error.message);
}
```

---

## Environment Variables & Secrets

### Environment Variables

```yaml
env:
  # Global environment variables
  NODE_ENV: production
  API_URL: https://api.example.com

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      # Job-level environment variables
      BUILD_TYPE: release
    steps:
      - name: Build
        env:
          # Step-level environment variables
          DEPLOY_ENV: staging
        run: |
          echo "Node env: $NODE_ENV"
          echo "Build type: $BUILD_TYPE"
          echo "Deploy env: $DEPLOY_ENV"
```

### Default Environment Variables

```yaml
steps:
  - name: Print default vars
    run: |
      echo "Repository: $GITHUB_REPOSITORY"
      echo "Branch: $GITHUB_REF"
      echo "Commit SHA: $GITHUB_SHA"
      echo "Actor: $GITHUB_ACTOR"
      echo "Workflow: $GITHUB_WORKFLOW"
      echo "Run ID: $GITHUB_RUN_ID"
      echo "Run Number: $GITHUB_RUN_NUMBER"
```

### Secrets

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to AWS
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws s3 sync ./dist s3://my-bucket
```

**Adding Secrets:**
1. Go to repository Settings
2. Click "Secrets and variables" → "Actions"
3. Click "New repository secret"
4. Add name and value

### Environment-Specific Secrets

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://myapp.com
    steps:
      - name: Deploy
        env:
          API_KEY: ${{ secrets.PROD_API_KEY }}
        run: npm run deploy
```

---

## Matrix Builds

### Basic Matrix

```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
        node-version: [16, 18, 20]
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      
      - run: npm install
      - run: npm test
```

### Matrix with Includes

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    node-version: [16, 18]
    include:
      # Add specific configuration
      - os: ubuntu-latest
        node-version: 20
        experimental: true
```

### Matrix with Excludes

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    node-version: [16, 18, 20]
    exclude:
      # Don't test Node 16 on Windows
      - os: windows-latest
        node-version: 16
```

### Fail-Fast Strategy

```yaml
strategy:
  fail-fast: false  # Continue running other jobs even if one fails
  matrix:
    os: [ubuntu-latest, macos-latest]
    node-version: [16, 18, 20]
```

---

## Caching Dependencies

### NPM Cache

```yaml
steps:
  - uses: actions/checkout@v4
  
  - uses: actions/setup-node@v4
    with:
      node-version: '18'
      cache: 'npm'  # Automatic caching
  
  - run: npm install
  - run: npm test
```

### Manual Cache

```yaml
steps:
  - uses: actions/checkout@v4
  
  - name: Cache dependencies
    uses: actions/cache@v4
    with:
      path: ~/.npm
      key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
      restore-keys: |
        ${{ runner.os }}-node-
  
  - run: npm install
  - run: npm test
```

### Multiple Cache Paths

```yaml
- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: |
      ~/.npm
      ~/.cache
      node_modules
    key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
```

### Bun Cache

```yaml
steps:
  - uses: actions/checkout@v4
  
  - uses: oven-sh/setup-bun@v1
  
  - name: Cache Bun dependencies
    uses: actions/cache@v4
    with:
      path: ~/.bun/install/cache
      key: ${{ runner.os }}-bun-${{ hashFiles('**/bun.lockb') }}
  
  - run: bun install
  - run: bun test
```

---

## Artifacts

### Upload Artifacts

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm install
      - run: npm run build
      
      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: dist
          path: dist/
          retention-days: 7
```

### Download Artifacts

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: dist
          path: dist/
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v4
        with:
          name: dist
          path: dist/
      
      - name: Deploy
        run: |
          ls -la dist/
          # Deploy files
```

### Multiple Artifacts

```yaml
- name: Upload coverage
  uses: actions/upload-artifact@v4
  with:
    name: coverage-report
    path: coverage/

- name: Upload logs
  uses: actions/upload-artifact@v4
  with:
    name: test-logs
    path: logs/
```

---

## Testing Automation

### Node.js/TypeScript Tests

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run type check
        run: npm run type-check
      
      - name: Run unit tests
        run: npm test
      
      - name: Run E2E tests
        run: npm run test:e2e
```

### Test with Coverage

```yaml
- name: Run tests with coverage
  run: npm test -- --coverage

- name: Upload coverage to Codecov
  uses: codecov/codecov-action@v4
  with:
    token: ${{ secrets.CODECOV_TOKEN }}
    files: ./coverage/coverage-final.json
    flags: unittests
    name: codecov-umbrella
```

### Playwright Tests

```yaml
name: Playwright Tests

on: [push, pull_request]

jobs:
  test:
    timeout-minutes: 60
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright browsers
        run: npx playwright install --with-deps
      
      - name: Run Playwright tests
        run: npx playwright test
      
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30
```

### Cypress Tests

```yaml
name: Cypress Tests

on: [push]

jobs:
  cypress-run:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Cypress run
        uses: cypress-io/github-action@v6
        with:
          build: npm run build
          start: npm start
          wait-on: 'http://localhost:3000'
```

---

## Docker Integration

### Build Docker Image

```yaml
name: Docker Build

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            myusername/myapp:latest
            myusername/myapp:${{ github.sha }}
          cache-from: type=registry,ref=myusername/myapp:buildcache
          cache-to: type=registry,ref=myusername/myapp:buildcache,mode=max
```

### Multi-Platform Builds

```yaml
- name: Build multi-platform image
  uses: docker/build-push-action@v5
  with:
    context: .
    platforms: linux/amd64,linux/arm64
    push: true
    tags: myusername/myapp:latest
```

### Docker Compose

```yaml
- name: Run tests with Docker Compose
  run: |
    docker-compose -f docker-compose.test.yml up --abort-on-container-exit
    docker-compose -f docker-compose.test.yml down
```

---

## Deployment Workflows

### Deploy to Vercel

```yaml
name: Deploy to Vercel

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.ORG_ID }}
          vercel-project-id: ${{ secrets.PROJECT_ID }}
          vercel-args: '--prod'
```

### Deploy to Netlify

```yaml
name: Deploy to Netlify

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - run: npm ci
      - run: npm run build
      
      - name: Deploy to Netlify
        uses: nwtgck/actions-netlify@v3
        with:
          publish-dir: './dist'
          production-branch: main
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "Deploy from GitHub Actions"
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### Deploy to AWS S3 + CloudFront

```yaml
name: Deploy to AWS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - run: npm ci
      - run: npm run build
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
      
      - name: Deploy to S3
        run: |
          aws s3 sync ./dist s3://${{ secrets.S3_BUCKET }} --delete
      
      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation \
            --distribution-id ${{ secrets.CLOUDFRONT_DISTRIBUTION_ID }} \
            --paths "/*"
```

### Deploy to Railway

```yaml
name: Deploy to Railway

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Railway
        run: npm install -g @railway/cli
      
      - name: Deploy to Railway
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
        run: railway up
```

### Deploy to Fly.io

```yaml
name: Deploy to Fly.io

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: superfly/flyctl-actions/setup-flyctl@master
      
      - name: Deploy to Fly.io
        run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

---

## Advanced Patterns

### Reusable Workflows

```yaml
# .github/workflows/reusable-deploy.yml
name: Reusable Deploy

on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      deploy-key:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: echo "Deploying to ${{ inputs.environment }}"
        env:
          KEY: ${{ secrets.deploy-key }}
```

```yaml
# .github/workflows/main.yml
name: Main

on: [push]

jobs:
  deploy-staging:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: staging
    secrets:
      deploy-key: ${{ secrets.STAGING_DEPLOY_KEY }}
  
  deploy-prod:
    uses: ./.github/workflows/reusable-deploy.yml
    with:
      environment: production
    secrets:
      deploy-key: ${{ secrets.PROD_DEPLOY_KEY }}
```

### Composite Actions

```yaml
# .github/actions/setup-app/action.yml
name: 'Setup App'
description: 'Setup Node.js and install dependencies'

inputs:
  node-version:
    description: 'Node.js version'
    required: false
    default: '18'

runs:
  using: 'composite'
  steps:
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ inputs.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
      shell: bash
    
    - name: Cache node_modules
      uses: actions/cache@v4
      with:
        path: node_modules
        key: ${{ runner.os }}-modules-${{ hashFiles('**/package-lock.json') }}
```

```yaml
# Usage
steps:
  - uses: actions/checkout@v4
  - uses: ./.github/actions/setup-app
    with:
      node-version: '20'
  - run: npm test
```

### Concurrency Control

```yaml
name: Deploy

on:
  push:
    branches: [main]

concurrency:
  group: production-deploy
  cancel-in-progress: false  # Don't cancel running deployments

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy
        run: echo "Deploying..."
```

### Required Status Checks

```yaml
name: Required Checks

on:
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run lint
  
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test
  
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
```

**Configure in GitHub:**
Settings → Branches → Branch protection rules → Require status checks

---

## Self-Hosted Runners

### Setup Self-Hosted Runner

```bash
# Download runner
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

# Configure
./config.sh --url https://github.com/your-org/your-repo --token YOUR_TOKEN

# Run
./run.sh

# Or install as a service
sudo ./svc.sh install
sudo ./svc.sh start
```

### Use Self-Hosted Runner

```yaml
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm test
```

### Runner Labels

```yaml
jobs:
  build:
    runs-on: [self-hosted, linux, x64, gpu]
    steps:
      - run: nvidia-smi  # GPU available
```

---

## Security Best Practices

### Secure Secrets Usage

```yaml
# ✅ GOOD: Use secrets for sensitive data
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: deploy.sh

# ❌ BAD: Never log secrets
- name: Debug
  run: echo ${{ secrets.API_KEY }}  # DON'T DO THIS!

# ✅ GOOD: Mask sensitive values
- name: Set masked value
  run: echo "::add-mask::$SENSITIVE_VALUE"
```

### Principle of Least Privilege

```yaml
permissions:
  contents: read  # Read-only access to repository
  pull-requests: write  # Can comment on PRs
  issues: write  # Can manage issues

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v4
```

### Dependabot for Actions

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

### Pin Actions to SHA

```yaml
# ✅ GOOD: Pin to specific commit SHA
- uses: actions/checkout@8e5e7e5ab8b370d6c329ec480221332ada57f0ab  # v4.1.1

# ⚠️ OK: Pin to version tag
- uses: actions/checkout@v4

# ❌ BAD: Use branch reference
- uses: actions/checkout@main
```

---

## Troubleshooting

### Debug Logging

```yaml
steps:
  - name: Enable debug logging
    run: echo "ACTIONS_STEP_DEBUG=true" >> $GITHUB_ENV
  
  - name: Debug workflow
    run: |
      echo "Event: ${{ github.event_name }}"
      echo "Ref: ${{ github.ref }}"
      echo "SHA: ${{ github.sha }}"
      echo "Actor: ${{ github.actor }}"
```

### Common Issues

```yaml
# Issue: Cache not working
# Solution: Check cache key
- uses: actions/cache@v4
  with:
    path: node_modules
    key: ${{ runner.os }}-${{ hashFiles('package-lock.json') }}  # Must be unique

# Issue: Secrets not available
# Solution: Check secret name and scope
env:
  API_KEY: ${{ secrets.API_KEY }}  # Case-sensitive

# Issue: Step skipped
# Solution: Check conditional logic
- name: Deploy
  if: success() && github.ref == 'refs/heads/main'  # Both conditions must be true
  run: deploy.sh
```

### View Logs

```bash
# Download logs for a run
gh run view 12345678 --log

# List recent runs
gh run list

# Re-run failed jobs
gh run rerun 12345678 --failed
```

---

## Real-World Examples

### Full CI/CD Pipeline

```yaml
name: Full CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '18'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Type check
        run: npm run type-check
      
      - name: Unit tests
        run: npm test -- --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          token: ${{ secrets.CODECOV_TOKEN }}
  
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: playwright-report
          path: playwright-report/
  
  build:
    needs: [test, e2e]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/
  
  deploy-staging:
    needs: build
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment:
      name: staging
      url: https://staging.example.com
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      
      - name: Deploy to staging
        run: |
          echo "Deploying to staging..."
          # Your deployment commands here
  
  deploy-production:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://example.com
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Your deployment commands here
```

### Monorepo with Turborepo

```yaml
name: Monorepo CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run Turborepo tests
        run: npx turbo run test lint type-check
      
      - name: Build all packages
        run: npx turbo run build
```

### Release Automation

```yaml
name: Release

on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          registry-url: 'https://registry.npmjs.org'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Semantic Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
        run: npx semantic-release
```

---

## 🎯 Best Practices Checklist

- ✅ Use caching for dependencies
- ✅ Pin action versions to specific commits
- ✅ Use secrets for sensitive data
- ✅ Set proper permissions for jobs
- ✅ Use matrix builds for multi-platform testing
- ✅ Upload artifacts for debugging
- ✅ Use reusable workflows for DRY
- ✅ Add proper error handling
- ✅ Use environments for deployments
- ✅ Monitor workflow execution time
- ✅ Clean up old artifacts and logs
- ✅ Document your workflows

---

## 📚 Resources

- **GitHub Actions Docs**: https://docs.github.com/actions
- **Actions Marketplace**: https://github.com/marketplace?type=actions
- **GitHub Actions Toolkit**: https://github.com/actions/toolkit
- **Awesome Actions**: https://github.com/sdras/awesome-actions

**You're now ready to automate everything with GitHub Actions!** 🚀