# 30-Day Technology Kickstart Challenge 🚀

Transform from beginner to confident developer in just 30 days with this intensive, practical learning plan.

---

## 🎯 Challenge Overview

**Goal:** Build a solid foundation in the most critical technologies every software engineer needs.

**Time Commitment:** 2-3 hours per day (60-90 hours total)

**What You'll Learn:**
- Git & GitHub
- Command Line & Linux basics
- Docker & Containerization
- Basic web development
- Database fundamentals
- Deploy your first application

**By Day 30, You Will:**
- ✅ Have 5+ projects on GitHub
- ✅ Understand version control
- ✅ Be comfortable with command line
- ✅ Know how to containerize applications
- ✅ Deploy apps to the cloud
- ✅ Have a portfolio website

---

## 📅 Week 1: Foundations (Git, Linux, Command Line)

### Day 1: Git Basics
**Goal:** Master version control fundamentals

**Morning (30 min) - Theory:**
- What is Git and why it matters
- Basic concepts: repository, commit, branch, merge
- Read: [Git Handbook](https://guides.github.com/introduction/git-handbook/)

**Evening (90 min) - Practice:**
```bash
# Install Git
# Ubuntu/Debian: sudo apt install git
# macOS: brew install git
# Windows: Download from git-scm.com

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Create your first repository
mkdir my-first-project
cd my-first-project
git init
echo "# My First Project" > README.md
git add README.md
git commit -m "Initial commit"

# Create a GitHub account and push your code
git remote add origin https://github.com/yourusername/my-first-project.git
git push -u origin main
```

**Daily Challenge:**
- Create a GitHub account
- Create 3 repositories
- Make at least 5 commits
- Write a good README.md

**Resources:**
- [GitHub Learning Lab](https://lab.github.com/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

---

### Day 2: Git Branching & Collaboration
**Goal:** Understand branching and merging

**Morning (30 min):**
- Watch: "Git Branching Tutorial" on YouTube
- Understand: branches, merging, conflicts

**Evening (90 min):**
```bash
# Create a new branch
git branch feature-1
git checkout feature-1
# Or combined: git checkout -b feature-1

# Make changes and commit
echo "New feature" >> feature.txt
git add feature.txt
git commit -m "Add new feature"

# Switch back to main and merge
git checkout main
git merge feature-1

# Practice resolving conflicts
# Create conflicting changes in two branches
# Merge and resolve manually
```

**Daily Challenge:**
- Create 3 different branches
- Make changes in each
- Merge them all back to main
- Intentionally create and resolve a merge conflict

**Resources:**
- [Learn Git Branching](https://learngitbranching.js.org/) - Interactive tutorial

---

### Day 3: Command Line Basics
**Goal:** Become comfortable with terminal/command line

**Morning (30 min):**
- Why command line matters
- Basic navigation and file operations
- Read: Command line basics tutorial

**Evening (90 min):**
```bash
# Navigation
pwd                    # Print working directory
ls -la                 # List all files with details
cd /path/to/directory  # Change directory
cd ~                   # Go to home directory
cd ..                  # Go up one level

# File operations
touch file.txt         # Create empty file
mkdir my-folder        # Create directory
cp source.txt dest.txt # Copy file
mv old.txt new.txt     # Move/rename file
rm file.txt            # Remove file
rm -rf folder/         # Remove directory

# File content
cat file.txt           # Display file content
less file.txt          # View file (paginated)
head -n 10 file.txt    # First 10 lines
tail -n 10 file.txt    # Last 10 lines
tail -f log.txt        # Follow log file

# Search and find
grep "pattern" file.txt          # Search in file
grep -r "pattern" .              # Recursive search
find . -name "*.txt"             # Find files by name
find . -type f -mtime -1         # Files modified in last 24h

# Combining commands
ls -la | grep ".txt"             # Pipe output
echo "Hello" > file.txt          # Redirect output
echo "World" >> file.txt         # Append to file
```

**Daily Challenge:**
- Navigate your entire file system using only terminal
- Create a folder structure for a project (folders for src, tests, docs)
- Create 10 files using touch
- Find all .txt files on your system
- Practice using grep to search file contents

**Resources:**
- [The Linux Command Line book](http://linuxcommand.org/tlcl.php) - Free PDF
- [Explainshell.com](https://explainshell.com/) - Explains commands

---

### Day 4: Linux/Unix Fundamentals
**Goal:** Understand Linux systems

**Morning (30 min):**
- Linux file system structure
- Users and permissions
- Process management basics

**Evening (90 min):**
```bash
# Permissions
ls -la                 # View permissions
chmod +x script.sh     # Make executable
chmod 755 file         # Set specific permissions
chmod u+w file         # Add write for user
chown user:group file  # Change ownership

# Process management
ps aux                 # List all processes
ps aux | grep node     # Find specific process
top                    # Monitor processes
htop                   # Better process monitor (install first)
kill <PID>             # Kill process by ID
killall node           # Kill all node processes

# System information
df -h                  # Disk space
du -sh *               # Directory sizes
free -h                # Memory usage
uptime                 # System uptime
whoami                 # Current user
uname -a               # System information

# Package management (Ubuntu/Debian)
sudo apt update        # Update package list
sudo apt upgrade       # Upgrade packages
sudo apt install vim   # Install package
sudo apt remove vim    # Remove package

# Environment variables
echo $PATH             # View PATH
export MY_VAR="value"  # Set variable
echo $MY_VAR           # Use variable
```

**Daily Challenge:**
- Install 5 new packages using your package manager
- Check your system's disk space and memory
- Find and kill a running process
- Create a file and change its permissions
- Set up environment variables

---

### Day 5: Shell Scripting Basics
**Goal:** Automate tasks with shell scripts

**Morning (30 min):**
- What are shell scripts?
- Bash script basics
- When to use scripts

**Evening (90 min):**
```bash
# Create your first script
nano backup.sh

# Script content:
#!/bin/bash

# Variables
SOURCE_DIR="/path/to/source"
BACKUP_DIR="/path/to/backup"
DATE=$(date +%Y-%m-%d)

# Create backup directory
mkdir -p "$BACKUP_DIR/$DATE"

# Copy files
cp -r "$SOURCE_DIR"/* "$BACKUP_DIR/$DATE/"

# Print message
echo "Backup completed: $BACKUP_DIR/$DATE"

# Make it executable
chmod +x backup.sh

# Run it
./backup.sh
```

**More Examples:**
```bash
# Loop through files
for file in *.txt; do
  echo "Processing $file"
  cat "$file"
done

# Conditional statements
if [ -f "file.txt" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi

# Functions
function greet() {
  echo "Hello, $1!"
}

greet "World"

# Read user input
read -p "Enter your name: " name
echo "Hello, $name!"
```

**Daily Challenge:**
- Create a backup script for your projects
- Write a script to organize files by extension
- Create a deployment script
- Write a script that checks if a service is running
- Make a script that prompts for user input

**Resources:**
- [Bash Scripting Tutorial](https://linuxconfig.org/bash-scripting-tutorial-for-beginners)

---

### Day 6: Text Processing & Automation
**Goal:** Master grep, sed, awk for text manipulation

**Morning (30 min):**
- Understanding pipes and redirects
- Text processing tools overview

**Evening (90 min):**
```bash
# grep - Search
grep "error" log.txt                    # Find "error" in file
grep -i "error" log.txt                 # Case-insensitive
grep -r "TODO" .                        # Recursive search
grep -n "error" log.txt                 # Show line numbers
grep -v "success" log.txt               # Invert match (exclude)
grep -E "error|warning" log.txt         # Multiple patterns

# sed - Stream editor
sed 's/old/new/' file.txt               # Replace first occurrence
sed 's/old/new/g' file.txt              # Replace all occurrences
sed '1d' file.txt                       # Delete first line
sed -n '1,10p' file.txt                 # Print lines 1-10
sed -i 's/old/new/g' file.txt           # Edit file in-place

# awk - Text processing
awk '{print $1}' file.txt               # Print first column
awk -F',' '{print $2}' file.csv         # Use comma as delimiter
awk '$3 > 100' data.txt                 # Filter rows
awk '{sum+=$1} END {print sum}' nums.txt # Sum numbers

# Combining tools
cat log.txt | grep "error" | wc -l      # Count errors
ps aux | grep node | awk '{print $2}'   # Get PIDs of node processes
find . -name "*.log" | xargs grep "error" # Search in multiple files

# Useful combinations
# Find large files
find . -type f -size +100M

# Find recently modified files
find . -type f -mtime -7

# Count lines of code
find . -name "*.js" | xargs wc -l

# Monitor log file and alert on errors
tail -f app.log | grep --line-buffered "ERROR"
```

**Daily Challenge:**
- Parse a log file and extract only error messages
- Count how many times each word appears in a text file
- Replace all occurrences of "TODO" with "DONE" in your codebase
- Extract email addresses from a file using grep
- Create a script that monitors a log file for errors

---

### Day 7: Week 1 Review & Mini-Project
**Goal:** Consolidate Week 1 learning

**Project: Automated Backup & Deployment Script**

Create a comprehensive script that:
1. Backs up important files
2. Commits changes to Git
3. Pushes to GitHub
4. Logs all operations

```bash
#!/bin/bash

# Configuration
PROJECT_DIR="/path/to/project"
BACKUP_DIR="/path/to/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="deployment.log"

# Function to log messages
log() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

log "Starting deployment process..."

# Backup
log "Creating backup..."
mkdir -p "$BACKUP_DIR"
tar -czf "$BACKUP_DIR/backup_$DATE.tar.gz" "$PROJECT_DIR"

if [ $? -eq 0 ]; then
  log "Backup successful"
else
  log "Backup failed"
  exit 1
fi

# Git operations
log "Committing changes..."
cd "$PROJECT_DIR"
git add .
git commit -m "Automated deployment: $DATE"
git push origin main

if [ $? -eq 0 ]; then
  log "Pushed to GitHub successfully"
else
  log "Push failed"
  exit 1
fi

log "Deployment completed successfully!"
```

**Week 1 Checklist:**
- [ ] Comfortable with Git (commit, branch, merge)
- [ ] Have GitHub account with 5+ repositories
- [ ] Can navigate file system using terminal only
- [ ] Understand file permissions and processes
- [ ] Can write basic shell scripts
- [ ] Can use grep, sed, awk for text processing
- [ ] Completed automated backup script

---

## 🐳 Week 2: Docker & Containerization

### Day 8: Docker Basics
**Goal:** Understand containers and run your first container

**Morning (30 min):**
- What are containers?
- Docker vs VMs
- Why Docker matters
- Read: [Docker Overview](https://docs.docker.com/get-started/overview/)

**Evening (90 min):**
```bash
# Install Docker
# Ubuntu: sudo apt install docker.io
# macOS: Download Docker Desktop
# Windows: Download Docker Desktop

# Verify installation
docker --version
docker run hello-world

# Basic commands
docker images                    # List images
docker ps                        # List running containers
docker ps -a                     # List all containers
docker pull nginx                # Pull image
docker run nginx                 # Run container
docker run -d nginx              # Run in background
docker run -d -p 8080:80 nginx   # Map ports
docker stop <container-id>       # Stop container
docker rm <container-id>         # Remove container
docker rmi <image-id>           # Remove image

# Interactive mode
docker run -it ubuntu bash       # Run Ubuntu interactively
docker exec -it <container> bash # Access running container
```

**Daily Challenge:**
- Install Docker
- Run 5 different containers (nginx, ubuntu, redis, postgres, node)
- Expose ports and access applications in browser
- Access a running container's shell
- Stop and remove all containers

**Resources:**
- [Docker Getting Started](https://docs.docker.com/get-started/)
- [Play with Docker](https://labs.play-with-docker.com/) - Practice online

---

### Day 9: Creating Docker Images
**Goal:** Build your own Docker images

**Morning (30 min):**
- Understanding Dockerfile
- Image layers
- Best practices for Docker images

**Evening (90 min):**
```dockerfile
# Create a simple Node.js app
# app.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from Docker!');
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});

# package.json
{
  "name": "docker-app",
  "version": "1.0.0",
  "main": "app.js",
  "dependencies": {
    "express": "^4.18.0"
  }
}

# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "app.js"]

# Build and run
docker build -t my-app .
docker run -d -p 3000:3000 my-app

# View logs
docker logs <container-id>
```

**Daily Challenge:**
- Create Dockerfile for a Node.js application
- Create Dockerfile for a Python Flask app
- Create Dockerfile for a static HTML site
- Build and tag images with different versions
- Push an image to Docker Hub

---

### Day 10: Docker Compose
**Goal:** Manage multi-container applications

**Morning (30 min):**
- What is Docker Compose?
- When to use it
- YAML basics

**Evening (90 min):**
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://postgres:password@db:5432/mydb
    depends_on:
      - db
      - redis
    volumes:
      - ./src:/app/src
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  db-data:

# Commands
docker-compose up -d          # Start all services
docker-compose down           # Stop all services
docker-compose ps             # List services
docker-compose logs web       # View logs
docker-compose exec web bash  # Access container
docker-compose restart web    # Restart service
```

**Daily Challenge:**
- Create a full-stack app with Docker Compose (frontend, backend, database)
- Set up WordPress with Docker Compose
- Configure environment variables for different environments
- Use volumes to persist data
- Network multiple containers together

---

### Day 11: Docker Networking & Volumes
**Goal:** Understand Docker networking and data persistence

**Morning (30 min):**
- Docker networks
- Volume types
- Data persistence strategies

**Evening (90 min):**
```bash
# Networking
docker network ls                          # List networks
docker network create my-network           # Create network
docker network inspect my-network          # Inspect network
docker run --network my-network nginx      # Connect to network

# Volumes
docker volume ls                           # List volumes
docker volume create my-volume             # Create volume
docker volume inspect my-volume            # Inspect volume
docker volume rm my-volume                 # Remove volume

# Mount types
# Bind mount
docker run -v /host/path:/container/path nginx

# Named volume
docker run -v my-volume:/container/path nginx

# Anonymous volume
docker run -v /container/path nginx

# Example: Database with persistent volume
docker run -d \
  --name postgres \
  -e POSTGRES_PASSWORD=secret \
  -v pgdata:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:15
```

**Daily Challenge:**
- Create custom Docker network
- Connect 3 containers to the same network
- Test communication between containers
- Create persistent volume for database
- Backup and restore Docker volume

---

### Day 12: Docker Best Practices
**Goal:** Write production-ready Dockerfiles

**Morning (30 min):**
- Multi-stage builds
- Image optimization
- Security best practices

**Evening (90 min):**
```dockerfile
# Multi-stage build example
# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001

# Copy only necessary files from builder
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./

USER nodejs

EXPOSE 3000

CMD ["node", "dist/index.js"]

# Best practices:
# 1. Use specific image tags (not "latest")
# 2. Use multi-stage builds
# 3. Run as non-root user
# 4. Use .dockerignore
# 5. Minimize layers
# 6. Order instructions by change frequency
# 7. Use COPY instead of ADD
# 8. Clean up in same layer
```

**.dockerignore:**
```
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.DS_Store
```

**Daily Challenge:**
- Optimize a Dockerfile to reduce image size by 50%
- Implement multi-stage build
- Add health checks to containers
- Scan images for vulnerabilities
- Create .dockerignore file

---

### Day 13: Docker in Practice
**Goal:** Real-world Docker usage

**Full Day Project (3 hours):**

Build a complete microservices application:
- Frontend (React)
- Backend API (Node.js/Python)
- Database (PostgreSQL)
- Cache (Redis)
- Reverse Proxy (Nginx)

```yaml
# docker-compose.yml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:8080
    depends_on:
      - api

  api:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=app
    volumes:
      - postgres-data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - frontend
      - api

volumes:
  postgres-data:
  redis-data:
```

**Daily Challenge:**
- Deploy the entire stack with one command
- Make changes and see hot-reload working
- Test inter-service communication
- Monitor logs from all services
- Practice tearing down and rebuilding

---

### Day 14: Week 2 Review & Docker Project
**Goal:** Build production-ready containerized application

**Final Project: Full-Stack Todo Application**

Requirements:
1. React frontend with Dockerfile
2. Node.js backend with Dockerfile
3. PostgreSQL database
4. Redis for caching
5. Nginx as reverse proxy
6. Docker Compose orchestration
7. Environment-based configuration (dev, prod)
8. Volume persistence
9. Health checks
10. Documentation in README.md

**Week 2 Checklist:**
- [ ] Can run and manage Docker containers
- [ ] Can write Dockerfiles for different languages
- [ ] Understand Docker Compose
- [ ] Can set up multi-container applications
- [ ] Know Docker networking and volumes
- [ ] Implemented multi-stage builds
- [ ] Deployed full-stack app with Docker

---

## 🌐 Week 3: Web Development & Databases

### Day 15: HTML & CSS Fundamentals
### Day 16: JavaScript Basics
### Day 17: Backend Development (Node.js/Python)
### Day 18: RESTful APIs
### Day 19: PostgreSQL Basics
### Day 20: Database Design & SQL
### Day 21: Week 3 Project - Full-Stack CRUD App

---

## ☁️ Week 4: Cloud Deployment & DevOps

### Day 22: Cloud Basics (AWS/GCP)
### Day 23: Deploying to Cloud
### Day 24: CI/CD with GitHub Actions
### Day 25: Nginx Configuration
### Day 26: Monitoring & Logging
### Day 27: Security Basics
### Day 28: Final Project Setup

---

## 🏆 Days 29-30: Final Project & Portfolio

### Day 29: Complete Final Project
Build a comprehensive application that demonstrates everything learned:
- Containerized with Docker
- Full-stack (Frontend + Backend + Database)
- Deployed to cloud
- CI/CD pipeline
- Monitoring
- Documentation

### Day 30: Portfolio & Showcase
- Create portfolio website
- Deploy all projects
- Write README files
- Update GitHub profile
- Share your journey on social media

---

## ✅ 30-Day Completion Checklist

### Technical Skills
- [ ] Git & GitHub proficiency
- [ ] Command line mastery
- [ ] Shell scripting
- [ ] Docker containerization
- [ ] Docker Compose
- [ ] Web development basics
- [ ] API development
- [ ] Database skills (SQL)
- [ ] Cloud deployment
- [ ] CI/CD pipeline

### Projects Completed
- [ ] 5+ Git repositories
- [ ] Automated backup script
- [ ] Dockerized applications
- [ ] Full-stack CRUD app
- [ ] Cloud-deployed application
- [ ] Portfolio website

### Portfolio
- [ ] GitHub profile with green squares
- [ ] Professional README files
- [ ] Live deployed projects
- [ ] Portfolio website showcasing work
- [ ] LinkedIn profile updated

---

## 🎯 What's Next?

After completing this 30-day challenge:

1. **Week 5-8:** Kubernetes, Terraform, Advanced Cloud
2. **Week 9-12:** Advanced backend, microservices, message queues
3. **Month 4-6:** Specialization (Frontend/Backend/DevOps)
4. **Month 7-12:** Build complex projects, contribute to open source

---

## 💡 Success Tips

1. **Don't skip days** - Consistency is key
2. **Build projects** - Don't just watch tutorials
3. **Take notes** - Document your learning
4. **Ask questions** - Use Stack Overflow, Discord, Reddit
5. **Share progress** - Post on Twitter/LinkedIn daily
6. **Take breaks** - Use Pomodoro technique
7. **Review regularly** - Spend weekends reviewing
8. **Sleep well** - Your brain needs rest to learn

---

## 📊 Track Your Progress

```markdown
Day 1:  ⬜ Git Basics
Day 2:  ⬜ Git Branching
Day 3:  ⬜ Command Line
Day 4:  ⬜ Linux Fundamentals
Day 5:  ⬜ Shell Scripting
Day 6:  ⬜ Text Processing
Day 7:  ⬜ Week 1 Project
Day 8:  ⬜ Docker Basics
Day 9:  ⬜ Docker Images
Day 10: ⬜ Docker Compose
Day 11: ⬜ Docker Networking
Day 12: ⬜ Docker Best Practices
Day 13: ⬜ Docker in Practice
Day 14: ⬜ Week 2 Project
Day 15-21: ⬜ Web Development Week
Day 22-28: ⬜ Cloud & DevOps Week
Day 29: ⬜ Final Project
Day 30: ⬜ Portfolio
```

---

**Start Date:** _______________
**Target Completion:** _______________

**You've got this! Start Day 1 today! 🚀**