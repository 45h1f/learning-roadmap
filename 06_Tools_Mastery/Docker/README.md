# 🐳 Docker - Containerization Platform

**The industry-standard platform for building, shipping, and running applications**

---

## 📋 Overview

**Docker** is a platform that uses OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries, and configuration files, making applications portable and consistent across environments.

**Key Features:**
- 📦 **Containerization** - Package apps with dependencies
- 🚀 **Portability** - Run anywhere (dev, staging, prod)
- ⚡ **Lightweight** - Faster than VMs
- 🔄 **Consistency** - "Works on my machine" problem solved
- 📊 **Scalability** - Easy to scale horizontally
- 🛠️ **DevOps Ready** - CI/CD integration

**Release:** 2013  
**Company:** Docker, Inc.  
**Written in:** Go  
**Market Share:** 83% of companies use containers

---

## 🔥 Why Learn Docker?

### Career Benefits
- 💰 **Salary Boost:** +$15-25K with Docker expertise
- 📈 **Job Requirement:** 75% of DevOps jobs require Docker
- 🎯 **Industry Standard:** Used by 90% of Fortune 500
- 🚀 **Career Path:** Essential for DevOps, Backend, Full-Stack

### Technical Benefits
- ✅ **Consistent environments** across team
- ✅ **Faster deployment** (seconds vs minutes)
- ✅ **Resource efficiency** (10x more containers than VMs)
- ✅ **Easy rollbacks** with versioned images
- ✅ **Microservices ready** - Perfect for distributed systems

### Companies Using Docker
- Google, Amazon, Microsoft, Netflix, Spotify
- Uber, PayPal, Shopify, GitHub
- Basically every tech company

---

## 🚀 Quick Start

### Installation

#### Linux
```bash
# Ubuntu/Debian
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (no sudo needed)
sudo usermod -aG docker $USER
newgrp docker

# Verify installation
docker --version
docker run hello-world
```

#### macOS
```bash
# Install Docker Desktop
brew install --cask docker

# Or download from: https://www.docker.com/products/docker-desktop

# Verify
docker --version
```

#### Windows
```bash
# Download Docker Desktop for Windows
# https://www.docker.com/products/docker-desktop

# Enable WSL 2 backend
# Verify in PowerShell
docker --version
```

### Your First Container

```bash
# Run a container
docker run nginx

# Run in detached mode (background)
docker run -d nginx

# Run with name
docker run -d --name my-nginx nginx

# Run with port mapping
docker run -d -p 8080:80 --name web nginx

# Visit: http://localhost:8080
```

---

## 📚 Core Concepts

### 1. Images vs Containers

**Image:** Blueprint/Template (like a class)
- Read-only template
- Contains OS, app code, dependencies
- Built from Dockerfile
- Stored in registries (Docker Hub)

**Container:** Running instance (like an object)
- Writable layer on top of image
- Isolated process
- Can be started, stopped, deleted
- Ephemeral by default

```bash
# List images
docker images

# List containers
docker ps        # Running only
docker ps -a     # All containers

# Pull an image
docker pull nginx:latest

# Run container from image
docker run nginx
```

### 2. Docker Architecture

```
┌─────────────────────────────────────────┐
│           Docker Client (CLI)           │
│         $ docker run, build, etc.       │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│          Docker Daemon (dockerd)        │
│                                         │
│  ┌──────────┐  ┌──────────┐           │
│  │ Images   │  │Containers│           │
│  └──────────┘  └──────────┘           │
└─────────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│        Docker Registry (Docker Hub)     │
│         public/private images           │
└─────────────────────────────────────────┘
```

---

## 📝 Dockerfile Basics

### Simple Dockerfile

```dockerfile
# Use base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Command to run app
CMD ["npm", "start"]
```

### Build and Run

```bash
# Build image
docker build -t my-app:1.0 .

# Run container
docker run -d -p 3000:3000 my-app:1.0

# View logs
docker logs <container-id>

# Execute command in container
docker exec -it <container-id> sh
```

### Dockerfile Instructions

```dockerfile
# FROM - Base image
FROM ubuntu:22.04

# LABEL - Metadata
LABEL maintainer="you@example.com"
LABEL version="1.0"

# ENV - Environment variables
ENV NODE_ENV=production
ENV PORT=3000

# WORKDIR - Set working directory
WORKDIR /app

# COPY - Copy files (supports wildcards)
COPY package*.json ./
COPY src/ ./src/

# ADD - Copy and extract archives
ADD archive.tar.gz /app

# RUN - Execute commands (build time)
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*

# EXPOSE - Document port
EXPOSE 3000

# USER - Switch user
USER node

# CMD - Default command (runtime, can be overridden)
CMD ["node", "server.js"]

# ENTRYPOINT - Main command (runtime, fixed)
ENTRYPOINT ["node"]
CMD ["server.js"]  # Can be overridden
```

---

## 🛠️ Essential Docker Commands

### Container Management

```bash
# Run container
docker run [OPTIONS] IMAGE [COMMAND]
docker run -d --name web -p 8080:80 nginx

# Common options:
# -d              Detached mode (background)
# --name          Container name
# -p 8080:80      Port mapping (host:container)
# -e KEY=value    Environment variable
# -v /host:/cont  Volume mount
# --rm            Remove after stop
# -it             Interactive terminal

# List containers
docker ps          # Running
docker ps -a       # All
docker ps -q       # IDs only

# Start/Stop/Restart
docker start <container>
docker stop <container>
docker restart <container>

# Remove container
docker rm <container>
docker rm -f <container>  # Force remove running

# View logs
docker logs <container>
docker logs -f <container>  # Follow (tail)
docker logs --tail 100 <container>

# Execute command in container
docker exec -it <container> bash
docker exec -it <container> sh
docker exec <container> ls /app

# Inspect container
docker inspect <container>

# Stats (CPU, memory usage)
docker stats
docker stats <container>

# Copy files
docker cp <container>:/path/to/file ./local/path
docker cp ./local/file <container>:/path/to/dest
```

### Image Management

```bash
# List images
docker images
docker image ls

# Pull image
docker pull nginx:latest
docker pull ubuntu:22.04

# Build image
docker build -t myapp:1.0 .
docker build -t myapp:latest -f Dockerfile.prod .

# Tag image
docker tag myapp:1.0 myapp:latest
docker tag myapp:1.0 username/myapp:1.0

# Push to registry
docker push username/myapp:1.0

# Remove image
docker rmi <image>
docker rmi -f <image>  # Force

# Save/Load images
docker save -o myapp.tar myapp:1.0
docker load -i myapp.tar

# History (layers)
docker history <image>

# Inspect image
docker inspect <image>
```

### System Management

```bash
# System info
docker info
docker version

# Disk usage
docker system df

# Clean up
docker system prune         # Remove unused data
docker system prune -a      # Remove all unused images
docker system prune --volumes  # Include volumes

# Remove all stopped containers
docker container prune

# Remove unused images
docker image prune
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune
```

---

## 🌐 Docker Networking

### Network Types

1. **Bridge** (default) - Isolated network
2. **Host** - Use host's network
3. **None** - No networking
4. **Overlay** - Multi-host networking

### Network Commands

```bash
# List networks
docker network ls

# Create network
docker network create my-network

# Run container on network
docker run -d --network my-network --name app nginx

# Connect container to network
docker network connect my-network <container>

# Disconnect
docker network disconnect my-network <container>

# Inspect network
docker network inspect my-network

# Remove network
docker network rm my-network
```

### Example: Multi-Container Network

```bash
# Create network
docker network create app-network

# Run database
docker run -d \
  --name postgres \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:15

# Run app (can access postgres by name)
docker run -d \
  --name api \
  --network app-network \
  -e DATABASE_URL=postgres://postgres:secret@postgres:5432/db \
  my-api:1.0

# Containers can communicate: http://postgres:5432
```

---

## 💾 Docker Volumes

### Volume Types

1. **Named Volumes** - Managed by Docker (recommended)
2. **Bind Mounts** - Map host directory
3. **tmpfs** - Temporary in memory

### Volume Commands

```bash
# Create volume
docker volume create my-data

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-data

# Remove volume
docker volume rm my-data

# Remove unused volumes
docker volume prune
```

### Using Volumes

```bash
# Named volume
docker run -d \
  --name postgres \
  -v pgdata:/var/lib/postgresql/data \
  postgres:15

# Bind mount (absolute path)
docker run -d \
  --name web \
  -v $(pwd)/src:/app/src \
  -v $(pwd)/public:/app/public \
  my-app:1.0

# Read-only volume
docker run -d \
  -v $(pwd)/config:/app/config:ro \
  my-app:1.0

# tmpfs (in memory)
docker run -d \
  --tmpfs /tmp \
  my-app:1.0
```

---

## 🎼 Docker Compose

### What is Docker Compose?

Tool for defining and running multi-container applications using YAML.

### Installation

```bash
# Linux (standalone)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Included with Docker Desktop (Mac/Windows)

# Verify
docker-compose --version
```

### Basic docker-compose.yml

```yaml
version: '3.8'

services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - frontend

  api:
    build: ./api
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
    networks:
      - frontend
      - backend

  db:
    image: postgres:15
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
      - POSTGRES_DB=mydb
    volumes:
      - pgdata:/var/lib/postgresql/data
    networks:
      - backend

networks:
  frontend:
  backend:

volumes:
  pgdata:
```

### Compose Commands

```bash
# Start services (build if needed)
docker-compose up
docker-compose up -d        # Detached

# Start specific service
docker-compose up web

# Build/rebuild services
docker-compose build
docker-compose build --no-cache

# Stop services
docker-compose stop
docker-compose down         # Stop and remove
docker-compose down -v      # Also remove volumes

# View logs
docker-compose logs
docker-compose logs -f      # Follow
docker-compose logs web     # Specific service

# Execute command
docker-compose exec web sh
docker-compose exec api npm test

# List containers
docker-compose ps

# Scale services
docker-compose up -d --scale api=3

# Restart services
docker-compose restart
docker-compose restart web
```

### Full-Stack Example

```yaml
version: '3.8'

services:
  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:4000
    volumes:
      - ./frontend/src:/app/src
    depends_on:
      - backend

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "4000:4000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:secret@postgres:5432/myapp
      - REDIS_URL=redis://redis:6379
    volumes:
      - ./backend/src:/app/src
    depends_on:
      - postgres
      - redis

  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=myapp
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Redis Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redisdata:/data

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - frontend
      - backend

volumes:
  pgdata:
  redisdata:
```

---

## 🎯 Real-World Examples

### 1. Node.js Application

```dockerfile
# Dockerfile
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy app source
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node healthcheck.js

# Start app
CMD ["node", "server.js"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - PORT=3000
    restart: unless-stopped
```

### 2. Python Flask API

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app
COPY . .

# Non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser /app
USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

### 3. React Frontend + Node.js Backend

```dockerfile
# Dockerfile.frontend
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

```dockerfile
# Dockerfile.backend
FROM node:18-alpine

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

EXPOSE 4000
CMD ["node", "server.js"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "80:80"
    depends_on:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "4000:4000"
    environment:
      - DATABASE_URL=postgresql://postgres:secret@db:5432/myapp
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=myapp
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

---

## 🏗️ Multi-Stage Builds

Reduce image size by using multiple FROM statements:

```dockerfile
# Stage 1: Build
FROM node:18 as builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine

WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./

EXPOSE 3000
CMD ["node", "dist/server.js"]
```

### Benefits
- ✅ Smaller final image (50-90% reduction)
- ✅ No build tools in production
- ✅ Faster deployments
- ✅ More secure

---

## 🔒 Docker Best Practices

### Security

```dockerfile
# 1. Use official base images
FROM node:18-alpine  # ✅ Official
# NOT: FROM random-user/node  # ❌

# 2. Don't run as root
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nodejs -u 1001
USER nodejs  # ✅

# 3. Use specific versions
FROM node:18.17.0-alpine  # ✅
# NOT: FROM node:latest     # ❌

# 4. Scan for vulnerabilities
# docker scan my-image:1.0

# 5. Don't include secrets
# Use environment variables or secrets management
```

### .dockerignore

```
# .dockerignore
node_modules
npm-debug.log
.git
.env
.env.local
*.md
.DS_Store
coverage
.vscode
dist
build
```

### Image Optimization

```dockerfile
# 1. Order layers by change frequency
FROM node:18-alpine

# Rarely changes
WORKDIR /app

# Changes occasionally
COPY package*.json ./
RUN npm ci --only=production

# Changes frequently
COPY . .

CMD ["node", "server.js"]

# 2. Minimize layers
RUN apt-get update && apt-get install -y \
    curl \
    vim \
    && rm -rf /var/lib/apt/lists/*  # ✅ Single layer

# NOT:
# RUN apt-get update              # ❌ Multiple layers
# RUN apt-get install -y curl
# RUN apt-get install -y vim

# 3. Clean up in same layer
RUN npm install && npm cache clean --force  # ✅

# 4. Use alpine images
FROM node:18-alpine   # ~50MB
# vs node:18          # ~900MB
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Install Docker
- [ ] Run first container (hello-world, nginx)
- [ ] Learn docker run, ps, stop, rm
- [ ] Understand images vs containers
- [ ] Pull images from Docker Hub
- [ ] View logs and execute commands

### Week 2: Dockerfiles
- [ ] Write first Dockerfile
- [ ] Build custom images
- [ ] Understand layers
- [ ] Use .dockerignore
- [ ] Multi-stage builds
- [ ] Push to Docker Hub

### Week 3: Networking & Volumes
- [ ] Create custom networks
- [ ] Connect containers
- [ ] Named volumes
- [ ] Bind mounts
- [ ] Data persistence
- [ ] Volume backups

### Week 4: Docker Compose
- [ ] Install Docker Compose
- [ ] Write docker-compose.yml
- [ ] Multi-container apps
- [ ] Environment variables
- [ ] Depends_on, healthchecks
- [ ] Production setup

**Time to Proficiency:** 4-6 weeks  
**Difficulty:** ⭐⭐⭐ (Intermediate)

---

## 🚀 Projects to Build

### Beginner
1. **Static Website**
   - Nginx + HTML files
   - Deploy with Docker

2. **Simple API**
   - Node.js/Python Flask
   - Dockerfile + docker-compose

### Intermediate
3. **Full-Stack App**
   - React frontend
   - Node.js backend
   - PostgreSQL database
   - Nginx reverse proxy

4. **Microservices**
   - 3+ services
   - Service discovery
   - Shared network

### Advanced
5. **Production Setup**
   - Multi-stage builds
   - Health checks
   - Auto-restart
   - Monitoring
   - Secrets management

---

## 🔧 Troubleshooting

### Common Issues

```bash
# Port already in use
docker ps  # Find container using port
docker stop <container>

# Permission denied
sudo usermod -aG docker $USER
newgrp docker

# Can't connect to Docker daemon
sudo systemctl start docker
sudo systemctl enable docker

# Out of disk space
docker system prune -a
docker volume prune

# Container exits immediately
docker logs <container>  # Check logs
docker run -it <image> sh  # Debug interactively

# Network issues
docker network inspect bridge
docker network create --driver bridge my-network
```

---

## 💡 Pro Tips

1. **Use Docker Compose** - Even for single containers (easy restart)
2. **Health checks** - Essential for production
3. **Resource limits** - Prevent memory leaks
4. **Logging** - Use JSON logs for parsing
5. **Restart policies** - `unless-stopped` for production
6. **Named volumes** - Easier to manage
7. **Multi-stage builds** - Smaller images
8. **Security scanning** - `docker scan` before deploy
9. **Version tags** - Never use `:latest` in production
10. **Cleanup regularly** - `docker system prune`

---

## 📚 Resources

### Official
- **Docs**: https://docs.docker.com/
- **Docker Hub**: https://hub.docker.com/
- **Best Practices**: https://docs.docker.com/develop/dev-best-practices/
- **Dockerfile Reference**: https://docs.docker.com/engine/reference/builder/

### Tutorials
- **Docker Get Started** - Official (30 min)
- **Docker in 100 Seconds** - Fireship (2 min)
- **Docker Tutorial for Beginners** - TechWorld with Nana (2 hours)
- **Docker Mastery** - Bret Fisher (Udemy)

### Tools
- **Docker Desktop** - GUI for Mac/Windows
- **Portainer** - Web UI for Docker
- **Dive** - Analyze image layers
- **ctop** - Container metrics

---

## 💼 Career Impact

### Salary Boost
- **Docker basics:** +$10-15K
- **Docker + Kubernetes:** +$20-30K
- **DevOps with Docker:** +$25-40K

### Job Titles
- DevOps Engineer ($110-160K)
- Site Reliability Engineer ($120-180K)
- Cloud Engineer ($100-150K)
- Backend Developer ($90-140K)
- Full-Stack Developer ($95-145K)

### Required For
- 75% of DevOps jobs
- 60% of backend jobs
- 40% of full-stack jobs
- 90% of cloud-native roles

---

## ✅ Checklist

### Basics
- [ ] Docker installed
- [ ] Run hello-world
- [ ] Pull and run nginx
- [ ] Understand containers vs images
- [ ] Basic commands (run, ps, stop, rm)

### Intermediate
- [ ] Write Dockerfile
- [ ] Build custom image
- [ ] Use docker-compose
- [ ] Volumes for persistence
- [ ] Networking between containers

### Advanced
- [ ] Multi-stage builds
- [ ] Production setup
- [ ] Security best practices
- [ ] CI/CD integration
- [ ] Monitoring and logging

### Expert
- [ ] Kubernetes basics
- [ ] Container orchestration
- [ ] Production deployments
- [ ] Performance optimization
- [ ] Security hardening

---

## 🎯 Next Steps

1. **Install Docker** - Right now!
2. **Run hello-world** - Verify installation
3. **Build first Dockerfile** - Simple Node.js app
4. **Use docker-compose** - Multi-container app
5. **Deploy project** - Real application
6. **Learn Kubernetes** - Next level (see Kubernetes guide)

---

**Last Updated:** January 2025  
**Status:** ✅ Complete Guide  
**Priority:** 🔴 CRITICAL (Essential for DevOps & Backend)

*Master Docker and unlock 75% more job opportunities! 🚀*