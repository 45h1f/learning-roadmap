# Quick Reference Guide - Essential Tools 🔧

A condensed cheat sheet for the most critical technologies you need to master.

---

## 🚨 Top 10 Must-Master Tools (In Order)

### 1. Git - Version Control
**Why:** Every software project uses version control
**Time to Learn:** 2-4 weeks
**Key Commands:**
```bash
git init                    # Initialize repository
git clone <url>            # Clone repository
git add .                  # Stage changes
git commit -m "message"    # Commit changes
git push origin main       # Push to remote
git pull                   # Pull latest changes
git branch <name>          # Create branch
git checkout <branch>      # Switch branch
git merge <branch>         # Merge branch
git log --oneline          # View commit history
```

**Master These Concepts:**
- Branching strategies (Feature branches, Git Flow)
- Pull requests & code reviews
- Merge conflict resolution
- Rebasing vs merging
- .gitignore patterns

---

### 2. Docker - Containerization
**Why:** Industry standard for deployment and development environments
**Time to Learn:** 3-6 weeks
**Essential Commands:**
```bash
docker build -t myapp .              # Build image
docker run -p 8080:80 myapp          # Run container
docker ps                            # List running containers
docker ps -a                         # List all containers
docker stop <container-id>           # Stop container
docker rm <container-id>             # Remove container
docker images                        # List images
docker rmi <image-id>               # Remove image
docker exec -it <container> bash     # Access container shell
docker-compose up -d                 # Start services
docker-compose down                  # Stop services
docker logs <container-id>          # View logs
```

**Key Files:**
```dockerfile
# Dockerfile example
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

```yaml
# docker-compose.yml example
version: '3.8'
services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
  db:
    image: postgres:15
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

---

### 3. Linux/Bash - Command Line
**Why:** All servers run Linux; automation requires shell scripting
**Time to Learn:** 4-8 weeks (ongoing practice)
**Essential Commands:**
```bash
# Navigation
cd /path/to/dir          # Change directory
ls -la                   # List files (detailed)
pwd                      # Print working directory

# File Operations
cp source dest           # Copy
mv source dest           # Move/rename
rm file                  # Remove file
rm -rf directory         # Remove directory
mkdir -p path/to/dir     # Create directory
touch file.txt           # Create empty file

# File Content
cat file.txt             # Display file
less file.txt            # View file (paginated)
head -n 10 file.txt      # First 10 lines
tail -n 10 file.txt      # Last 10 lines
tail -f log.txt          # Follow log file

# Search & Find
grep "pattern" file.txt  # Search in file
grep -r "pattern" .      # Recursive search
find . -name "*.js"      # Find files by name
find . -type f -mtime -7 # Files modified in last 7 days

# Permissions
chmod +x script.sh       # Make executable
chmod 755 file           # Set permissions
chown user:group file    # Change owner

# Process Management
ps aux                   # List processes
ps aux | grep node       # Find specific process
kill <pid>               # Kill process
kill -9 <pid>            # Force kill
top                      # Monitor processes
htop                     # Better process monitor

# System Info
df -h                    # Disk space
du -sh *                 # Directory sizes
free -h                  # Memory usage
uptime                   # System uptime

# Network
curl https://api.com     # Make HTTP request
wget https://file.com    # Download file
netstat -tuln            # List open ports
ping google.com          # Test connectivity

# Text Processing
sed 's/old/new/g' file   # Replace text
awk '{print $1}' file    # Print first column
sort file.txt            # Sort lines
uniq file.txt            # Remove duplicates
wc -l file.txt           # Count lines
```

---

### 4. Nginx - Web Server & Reverse Proxy
**Why:** Most popular web server; essential for production deployments
**Time to Learn:** 2-3 weeks
**Basic Configuration:**
```nginx
# /etc/nginx/nginx.conf or /etc/nginx/sites-available/default

# Simple static site
server {
    listen 80;
    server_name example.com;
    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Reverse proxy to backend
server {
    listen 80;
    server_name api.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

# Load balancing
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}

# SSL/HTTPS
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/ssl/certs/cert.pem;
    ssl_certificate_key /etc/ssl/private/key.pem;

    location / {
        proxy_pass http://localhost:3000;
    }
}
```

**Common Commands:**
```bash
sudo nginx -t                    # Test configuration
sudo systemctl start nginx       # Start nginx
sudo systemctl stop nginx        # Stop nginx
sudo systemctl restart nginx     # Restart nginx
sudo systemctl reload nginx      # Reload config (no downtime)
sudo systemctl status nginx      # Check status
```

---

### 5. PostgreSQL - Database
**Why:** Most advanced open-source relational database
**Time to Learn:** 4-6 weeks
**Essential SQL:**
```sql
-- Create
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert
INSERT INTO users (username, email) 
VALUES ('john_doe', 'john@example.com');

-- Select
SELECT * FROM users;
SELECT username, email FROM users WHERE id = 1;
SELECT * FROM users WHERE created_at > '2024-01-01';
SELECT * FROM users ORDER BY created_at DESC LIMIT 10;

-- Update
UPDATE users SET email = 'newemail@example.com' WHERE id = 1;

-- Delete
DELETE FROM users WHERE id = 1;

-- Joins
SELECT users.username, orders.total
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Indexes
CREATE INDEX idx_users_email ON users(email);

-- Transactions
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

**Common Commands:**
```bash
psql -U postgres                 # Connect to PostgreSQL
\l                               # List databases
\c database_name                 # Connect to database
\dt                              # List tables
\d table_name                    # Describe table
\q                               # Quit
```

---

### 6. Redis - Caching & Session Store
**Why:** Essential for performance optimization and real-time features
**Time to Learn:** 1-2 weeks
**Key Commands:**
```bash
# Strings
SET key "value"              # Set key
GET key                      # Get key
DEL key                      # Delete key
EXISTS key                   # Check if exists
EXPIRE key 60                # Set expiry (seconds)

# Lists
LPUSH mylist "item"          # Push to list
RPUSH mylist "item"          # Push to right
LPOP mylist                  # Pop from left
LRANGE mylist 0 -1           # Get all items

# Sets
SADD myset "member"          # Add to set
SMEMBERS myset               # Get all members
SISMEMBER myset "member"     # Check membership

# Hashes
HSET user:1 name "John"      # Set hash field
HGET user:1 name             # Get hash field
HGETALL user:1               # Get all fields

# Sorted Sets
ZADD leaderboard 100 "player1"
ZRANGE leaderboard 0 -1      # Get by rank

# Pub/Sub
SUBSCRIBE channel            # Subscribe to channel
PUBLISH channel "message"    # Publish message
```

---

### 7. Kubernetes - Container Orchestration
**Why:** Industry standard for running containers at scale
**Time to Learn:** 8-12 weeks
**Essential Commands:**
```bash
# Cluster Info
kubectl cluster-info         # View cluster info
kubectl get nodes            # List nodes

# Pods
kubectl get pods             # List pods
kubectl get pods -n namespace # List pods in namespace
kubectl describe pod <name>  # Describe pod
kubectl logs <pod-name>      # View logs
kubectl exec -it <pod> bash  # Access pod shell
kubectl delete pod <name>    # Delete pod

# Deployments
kubectl get deployments      # List deployments
kubectl create deployment nginx --image=nginx
kubectl scale deployment nginx --replicas=3
kubectl set image deployment/nginx nginx=nginx:1.16
kubectl rollout status deployment/nginx
kubectl rollout undo deployment/nginx

# Services
kubectl get services         # List services
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl describe service nginx

# ConfigMaps & Secrets
kubectl create configmap app-config --from-file=config.txt
kubectl create secret generic db-secret --from-literal=password=secret
kubectl get configmaps
kubectl get secrets

# Apply YAML
kubectl apply -f deployment.yaml
kubectl delete -f deployment.yaml

# Namespaces
kubectl get namespaces
kubectl create namespace dev
kubectl config set-context --current --namespace=dev
```

**Basic Deployment YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer
```

---

### 8. Terraform - Infrastructure as Code
**Why:** Manage infrastructure across all cloud providers
**Time to Learn:** 4-6 weeks
**Basic Commands:**
```bash
terraform init               # Initialize project
terraform plan               # Preview changes
terraform apply              # Apply changes
terraform destroy            # Destroy infrastructure
terraform validate           # Validate configuration
terraform fmt                # Format code
terraform state list         # List resources
terraform output             # Show outputs
```

**Basic Configuration:**
```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "my-app-data-bucket"
  acl    = "private"
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

---

### 9. AWS/GCP/Azure - Cloud Platform
**Why:** All modern applications run in the cloud
**Time to Learn:** 6-12 weeks per platform
**AWS Essential Services:**
```bash
# AWS CLI Commands
aws s3 ls                          # List S3 buckets
aws s3 cp file.txt s3://bucket/    # Upload to S3
aws ec2 describe-instances         # List EC2 instances
aws lambda list-functions          # List Lambda functions
aws rds describe-db-instances      # List RDS databases

# Key Services to Learn:
- EC2 (Virtual Machines)
- S3 (Object Storage)
- RDS (Managed Databases)
- Lambda (Serverless Functions)
- VPC (Virtual Private Cloud)
- IAM (Identity & Access Management)
- CloudWatch (Monitoring)
- ECS/EKS (Container Services)
```

---

### 10. CI/CD - GitHub Actions
**Why:** Automate testing and deployment
**Time to Learn:** 2-3 weeks
**Basic Workflow:**
```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Deploy to production
      run: |
        echo "Deploying to production..."
        # Add deployment commands here
```

---

## 📊 Learning Time Investment

| Tool | Priority | Time to Basic | Time to Proficient |
|------|----------|---------------|-------------------|
| Git | 🔴 Critical | 1-2 weeks | 1-2 months |
| Docker | 🔴 Critical | 2-3 weeks | 2-3 months |
| Linux/Bash | 🔴 Critical | 1 month | 6 months |
| Nginx | 🟡 High | 1-2 weeks | 1-2 months |
| PostgreSQL | 🟡 High | 2-3 weeks | 3-6 months |
| Redis | 🟡 High | 1 week | 1 month |
| Kubernetes | 🟡 High | 1-2 months | 6-12 months |
| Terraform | 🟡 High | 2-3 weeks | 2-3 months |
| Cloud (AWS) | 🔴 Critical | 1 month | 6-12 months |
| CI/CD | 🟡 High | 1-2 weeks | 1-2 months |

---

## 🎯 30-Day Quick Start Challenge

### Week 1: Version Control & Command Line
- [ ] Learn Git basics (commit, branch, merge)
- [ ] Practice Linux commands daily
- [ ] Create GitHub account and push first project
- [ ] Learn basic shell scripting

### Week 2: Containerization
- [ ] Install Docker
- [ ] Run your first container
- [ ] Create a Dockerfile for a simple app
- [ ] Learn Docker Compose basics

### Week 3: Web Server & Database
- [ ] Install and configure Nginx
- [ ] Set up PostgreSQL
- [ ] Create a simple database schema
- [ ] Connect application to database

### Week 4: Cloud & CI/CD
- [ ] Create AWS/GCP free tier account
- [ ] Deploy a simple application
- [ ] Set up GitHub Actions workflow
- [ ] Automate deployment

---

## 💡 Pro Tips

1. **Learn by Doing**: Build real projects, not just tutorials
2. **Read Official Docs**: They're the best resource
3. **Practice Daily**: 30 minutes > 5 hours on weekends
4. **Join Communities**: Reddit, Discord, Stack Overflow
5. **Keep Notes**: Use Notion/Obsidian to document learnings
6. **Teach Others**: Write blog posts, answer questions
7. **Get Certified**: AWS/GCP certifications validate skills
8. **Stay Updated**: Follow tech blogs and newsletters

---

## 📚 Best Documentation Resources

- **Git**: https://git-scm.com/doc
- **Docker**: https://docs.docker.com/
- **Kubernetes**: https://kubernetes.io/docs/
- **Nginx**: https://nginx.org/en/docs/
- **PostgreSQL**: https://www.postgresql.org/docs/
- **Redis**: https://redis.io/documentation
- **Terraform**: https://www.terraform.io/docs
- **AWS**: https://docs.aws.amazon.com/
- **MDN Web Docs**: https://developer.mozilla.org/

---

## 🔗 Cheat Sheet Links

- Git: https://education.github.com/git-cheat-sheet-education.pdf
- Docker: https://docs.docker.com/get-started/docker_cheatsheet.pdf
- Kubernetes: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- Linux: https://www.linuxtrainingacademy.com/linux-commands-cheat-sheet/

---

**Remember**: You don't need to memorize everything. Understanding concepts and knowing where to find information is more important than rote memorization.

**Start Today**: Pick one tool from this list and spend 30 minutes on it. Consistency is key! 🚀