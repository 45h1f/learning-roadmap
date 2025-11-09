# ☸️ Kubernetes - Complete Container Orchestration Guide

**The industry-standard platform for automating deployment, scaling, and management of containerized applications**

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Why Learn Kubernetes?](#why-learn-kubernetes)
3. [Core Concepts](#core-concepts)
4. [Installation & Setup](#installation--setup)
5. [Pods](#pods)
6. [Deployments](#deployments)
7. [Services](#services)
8. [ConfigMaps & Secrets](#configmaps--secrets)
9. [Volumes & Storage](#volumes--storage)
10. [Ingress](#ingress)
11. [Namespaces](#namespaces)
12. [Real-World Examples](#real-world-examples)
13. [Production Best Practices](#production-best-practices)
14. [Troubleshooting](#troubleshooting)
15. [Learning Path](#learning-path)

---

## 📋 Overview

**Kubernetes (K8s)** is an open-source container orchestration platform that automates deployment, scaling, and management of containerized applications across clusters of hosts.

**Key Features:**
- 🚀 **Auto-scaling** - Scale apps based on load
- 🔄 **Self-healing** - Restart failed containers
- 📦 **Service discovery** - Automatic load balancing
- 🔐 **Secret management** - Secure configuration
- 🌍 **Multi-cloud** - Run anywhere
- 📊 **Resource optimization** - Efficient scheduling

**Created by:** Google (2014)  
**Now maintained by:** Cloud Native Computing Foundation (CNCF)  
**Written in:** Go  
**Market Share:** 88% of container orchestration users choose Kubernetes

---

## 🔥 Why Learn Kubernetes?

### Career Benefits
- 💰 **Salary Boost:** +$25-40K with K8s expertise
- 📈 **Job Demand:** 67% of DevOps jobs require Kubernetes
- 🎯 **Industry Standard:** Used by 96% of Fortune 100 companies
- 🚀 **Future-Proof:** Cloud-native is the future

### Technical Benefits
- ✅ **High Availability** - No single point of failure
- ✅ **Zero-downtime deployments** - Rolling updates
- ✅ **Resource efficiency** - Optimal resource utilization
- ✅ **Portable** - Run on any cloud or on-premises
- ✅ **Declarative** - Describe desired state, K8s makes it happen

### Companies Using Kubernetes
- **Tech Giants:** Google, Amazon, Microsoft, Netflix, Spotify
- **Finance:** Capital One, Goldman Sachs, JPMorgan
- **Retail:** Walmart, Target, eBay
- **Gaming:** Pokémon GO, EA, Unity
- **Basically everyone:** 5.6 million developers use K8s

---

## 🏗️ Core Concepts

### Kubernetes Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CONTROL PLANE (Master)                   │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │  API Server  │  │  Scheduler   │  │  Controller  │    │
│  │  (kubectl)   │  │  (assigns)   │  │  (maintains) │    │
│  └──────────────┘  └──────────────┘  └──────────────┘    │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐ │
│  │              etcd (Cluster State)                     │ │
│  └──────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│  WORKER NODE  │    │  WORKER NODE  │    │  WORKER NODE  │
│               │    │               │    │               │
│  ┌─────────┐  │    │  ┌─────────┐  │    │  ┌─────────┐  │
│  │  Pods   │  │    │  │  Pods   │  │    │  │  Pods   │  │
│  └─────────┘  │    │  └─────────┘  │    │  └─────────┘  │
│               │    │               │    │               │
│  ┌─────────┐  │    │  ┌─────────┐  │    │  ┌─────────┐  │
│  │ kubelet │  │    │  │ kubelet │  │    │  │ kubelet │  │
│  └─────────┘  │    │  └─────────┘  │    │  └─────────┘  │
│               │    │               │    │               │
│  ┌─────────┐  │    │  ┌─────────┐  │    │  ┌─────────┐  │
│  │ kube-   │  │    │  │ kube-   │  │    │  │ kube-   │  │
│  │ proxy   │  │    │  │ proxy   │  │    │  │ proxy   │  │
│  └─────────┘  │    │  └─────────┘  │    │  └─────────┘  │
└───────────────┘    └───────────────┘    └───────────────┘
```

### Key Components

**Control Plane (Master Node):**
- **API Server** - Entry point for all commands
- **Scheduler** - Assigns pods to nodes
- **Controller Manager** - Maintains desired state
- **etcd** - Distributed key-value store (cluster state)

**Worker Nodes:**
- **kubelet** - Agent that runs on each node
- **kube-proxy** - Network proxy for services
- **Container Runtime** - Docker, containerd, CRI-O

**Kubernetes Objects:**
- **Pod** - Smallest deployable unit (1+ containers)
- **Deployment** - Manages pod replicas
- **Service** - Exposes pods to network
- **ConfigMap** - Configuration data
- **Secret** - Sensitive data
- **Volume** - Persistent storage
- **Namespace** - Virtual clusters

---

## 🚀 Installation & Setup

### Option 1: Minikube (Local Development)

**Best for:** Learning, local testing

```bash
# Install kubectl (CLI)
# macOS
brew install kubectl

# Linux
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Windows
choco install kubernetes-cli

# Verify
kubectl version --client

# Install Minikube
# macOS
brew install minikube

# Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Windows
choco install minikube

# Start cluster
minikube start

# Verify
kubectl cluster-info
kubectl get nodes
```

### Option 2: Kind (Kubernetes in Docker)

**Best for:** CI/CD, testing

```bash
# Install Kind
# macOS
brew install kind

# Linux/Windows
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create cluster
kind create cluster --name my-cluster

# Delete cluster
kind delete cluster --name my-cluster
```

### Option 3: Cloud Providers

**Production-ready managed services:**

```bash
# AWS EKS
eksctl create cluster --name my-cluster --region us-west-2

# Google GKE
gcloud container clusters create my-cluster --num-nodes=3

# Azure AKS
az aks create --resource-group myRG --name myAKS --node-count 3

# DigitalOcean DOKS
doctl kubernetes cluster create my-cluster
```

---

## 📦 Pods

**Pod:** Smallest deployable unit, runs one or more containers.

### Simple Pod

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.24
    ports:
    - containerPort: 80
```

```bash
# Create pod
kubectl apply -f pod.yaml

# List pods
kubectl get pods
kubectl get pods -o wide

# Describe pod
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod

# Execute command in pod
kubectl exec -it nginx-pod -- /bin/bash

# Delete pod
kubectl delete pod nginx-pod
```

### Multi-Container Pod

```yaml
# multi-container-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:1.0
    ports:
    - containerPort: 3000
  
  - name: sidecar
    image: fluentd:latest
    volumeMounts:
    - name: logs
      mountPath: /logs
  
  volumes:
  - name: logs
    emptyDir: {}
```

### Pod with Environment Variables

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
  - name: app
    image: node:18
    env:
    - name: NODE_ENV
      value: "production"
    - name: PORT
      value: "3000"
    - name: DATABASE_URL
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: url
```

---

## 🚀 Deployments

**Deployment:** Manages pod replicas, updates, rollbacks.

### Basic Deployment

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3  # Number of pods
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

### Deployment Commands

```bash
# Create deployment
kubectl apply -f deployment.yaml

# List deployments
kubectl get deployments

# Scale deployment
kubectl scale deployment nginx-deployment --replicas=5

# Update image (rolling update)
kubectl set image deployment/nginx-deployment nginx=nginx:1.25

# Rollback
kubectl rollout undo deployment/nginx-deployment

# Check rollout status
kubectl rollout status deployment/nginx-deployment

# View rollout history
kubectl rollout history deployment/nginx-deployment

# Delete deployment
kubectl delete deployment nginx-deployment
```

### Advanced Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-deployment
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max new pods during update
      maxUnavailable: 1  # Max unavailable pods
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
        version: v1
    spec:
      containers:
      - name: api
        image: myapi:1.0
        ports:
        - containerPort: 4000
        env:
        - name: NODE_ENV
          value: production
        livenessProbe:
          httpGet:
            path: /health
            port: 4000
          initialDelaySeconds: 10
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /ready
            Port: 4000
          initialDelaySeconds: 5
          periodSeconds: 3
        resources:
          requests:
            memory: "256Mi"
            cpu: "500m"
          limits:
            memory: "512Mi"
            cpu: "1000m"
```

---

## 🌐 Services

**Service:** Exposes pods to network traffic.

### Types of Services

1. **ClusterIP** (default) - Internal cluster access only
2. **NodePort** - External access via node IP:port
3. **LoadBalancer** - Cloud load balancer (AWS ELB, GCP LB)
4. **ExternalName** - DNS alias

### ClusterIP Service

```yaml
# service-clusterip.yaml
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  type: ClusterIP
  selector:
    app: api  # Matches pod labels
  ports:
  - port: 80        # Service port
    targetPort: 4000  # Container port
    protocol: TCP
```

### NodePort Service

```yaml
# service-nodeport.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 3000
    nodePort: 30080  # External port (30000-32767)
```

### LoadBalancer Service

```yaml
# service-loadbalancer.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: LoadBalancer
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 3000
```

### Service Commands

```bash
# List services
kubectl get services
kubectl get svc

# Describe service
kubectl describe service api-service

# Get service endpoints
kubectl get endpoints api-service

# Access service (from inside cluster)
kubectl run curl --image=curlimages/curl -it --rm -- sh
curl http://api-service

# Port forward (for testing)
kubectl port-forward service/api-service 8080:80
# Access: http://localhost:8080
```

---

## ⚙️ ConfigMaps & Secrets

### ConfigMap

**Store non-sensitive configuration:**

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database_host: "postgres.default.svc.cluster.local"
  database_port: "5432"
  log_level: "info"
  app.properties: |
    name=myapp
    version=1.0
    environment=production
```

**Use in Pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:1.0
    env:
    # Single value
    - name: DB_HOST
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: database_host
    
    # All values as env vars
    envFrom:
    - configMapRef:
        name: app-config
    
    # Mount as file
    volumeMounts:
    - name: config
      mountPath: /config
  
  volumes:
  - name: config
    configMap:
      name: app-config
```

### Secret

**Store sensitive data (base64 encoded):**

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=        # base64: admin
  password: cGFzc3dvcmQ=    # base64: password
```

```bash
# Create secret from command
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=secret123

# Create secret from file
kubectl create secret generic tls-secret \
  --from-file=tls.crt \
  --from-file=tls.key
```

**Use in Pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:1.0
    env:
    - name: DB_USERNAME
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
```

---

## 💾 Volumes & Storage

### Volume Types

1. **emptyDir** - Temporary, pod lifetime
2. **hostPath** - Node's filesystem
3. **PersistentVolume (PV)** - Cluster storage
4. **PersistentVolumeClaim (PVC)** - Request storage

### EmptyDir Volume

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cache-pod
spec:
  containers:
  - name: app
    image: myapp:1.0
    volumeMounts:
    - name: cache
      mountPath: /cache
  
  volumes:
  - name: cache
    emptyDir: {}
```

### PersistentVolume & PersistentVolumeClaim

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: standard
  hostPath:
    path: /data/postgres
---
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
  storageClassName: standard
```

**Use in Deployment:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
```

---

## 🌍 Ingress

**Ingress:** HTTP(S) routing to services (Layer 7 load balancing).

### Install Ingress Controller

```bash
# Nginx Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# Verify
kubectl get pods -n ingress-nginx
```

### Basic Ingress

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

### Advanced Ingress (Multiple Services)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-ingress
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - myapp.example.com
    secretName: tls-secret
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 4000
      
      - path: /admin
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 3000
```

---

## 📂 Namespaces

**Namespace:** Virtual clusters within a cluster.

```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace dev
kubectl create namespace prod

# Set default namespace
kubectl config set-context --current --namespace=dev

# List resources in namespace
kubectl get all -n dev

# Delete namespace (deletes all resources)
kubectl delete namespace dev
```

### Namespace YAML

```yaml
# namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: staging
  labels:
    environment: staging
```

### Resource Quotas

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "10"
    requests.memory: 20Gi
    limits.cpu: "20"
    limits.memory: 40Gi
    persistentvolumeclaims: "10"
    pods: "50"
```

---

## 🎯 Real-World Examples

### Example 1: Simple Web App

```yaml
# web-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
  - port: 80
    targetPort: 80
```

```bash
kubectl apply -f web-app.yaml
kubectl get service webapp-service
```

### Example 2: Full-Stack Application

```yaml
# fullstack-app.yaml
# PostgreSQL Database
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        - name: POSTGRES_DB
          value: myapp
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: postgres-storage
        persistentVolumeClaim:
          claimName: postgres-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: postgres-service
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
---
# Backend API
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: myapi:1.0
        env:
        - name: DATABASE_URL
          value: postgresql://postgres:5432/myapp
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        ports:
        - containerPort: 4000
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  ports:
  - port: 4000
    targetPort: 4000
---
# Frontend
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: myfrontend:1.0
        env:
        - name: API_URL
          value: http://api-service:4000
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  type: LoadBalancer
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 3000
```

---

## 🏆 Production Best Practices

### 1. Resource Limits

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "500m"
  limits:
    memory: "512Mi"
    cpu: "1000m"
```

### 2. Health Checks

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 30
  periodSeconds: 10

readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### 3. Rolling Updates

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

### 4. Pod Disruption Budget

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: api-pdb
spec:
  minAvailable: 2
  selector:
    matchLabels:
      app: api
```

### 5. Horizontal Pod Autoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## 🔧 Troubleshooting

### Common Commands

```bash
# Check cluster
kubectl cluster-info
kubectl get nodes

# Check resources
kubectl get all
kubectl get all -n default

# Describe resources
kubectl describe pod <pod-name>
kubectl describe deployment <deployment-name>

# Logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>  # Follow
kubectl logs <pod-name> -c <container-name>  # Multi-container

# Execute commands
kubectl exec -it <pod-name> -- sh
kubectl exec -it <pod-name> -c <container> -- sh

# Events
kubectl get events
kubectl get events --sort-by=.metadata.creationTimestamp

# Resource usage
kubectl top nodes
kubectl top pods
```

### Common Issues

**Pod stuck in Pending:**
```bash
kubectl describe pod <pod-name>
# Check: Insufficient resources, node selector, PVC not bound
```

**Pod CrashLoopBackOff:**
```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
# Check: Application errors, missing dependencies, wrong command
```

**Service not accessible:**
```bash
kubectl get endpoints <service-name>
# Check: Selector matches pod labels, correct ports
```

**ImagePullBackOff:**
```bash
kubectl describe pod <pod-name>
# Check: Image exists, registry credentials, image name typo
```

---

## 🎓 Learning Path

### Week 1: Fundamentals
- [ ] Install kubectl & Minikube
- [ ] Understand architecture
- [ ] Create first pod
- [ ] Basic kubectl commands
- [ ] Pod lifecycle

### Week 2: Core Objects
- [ ] Deployments
- [ ] Services (ClusterIP, NodePort)
- [ ] ConfigMaps
- [ ] Secrets
- [ ] Simple app deployment

### Week 3: Advanced
- [ ] Volumes & PVCs
- [ ] Ingress
- [ ] Namespaces
- [ ] Resource limits
- [ ] Health checks

### Week 4: Production
- [ ] Rolling updates
- [ ] Horizontal scaling
- [ ] Monitoring
- [ ] Troubleshooting
- [ ] Best practices

**Time to Proficiency:** 4-8 weeks  
**Difficulty:** ⭐⭐⭐⭐ (Advanced)  
**Prerequisites:** Docker, Linux basics, networking

---

## 💼 Career Impact

### Salary Boost
- **Kubernetes basics:** +$15-25K
- **K8s + AWS/GCP:** +$30-45K
- **Kubernetes architect:** +$40-60K

### Job Roles
- **DevOps Engineer:** $110-180K
- **Site Reliability Engineer (SRE):** $130-200K
- **Cloud Engineer:** $100-160K
- **Platform Engineer:** $120-180K
- **Kubernetes Administrator:** $110-170K

### Certifications
- **CKA** - Certified Kubernetes Administrator
- **CKAD** - Certified Kubernetes Application Developer
- **CKS** - Certified Kubernetes Security Specialist

---

## 📚 Resources

### Official
- **Docs:** https://kubernetes.io/docs/
- **Tutorials:** https://kubernetes.io/docs/tutorials/
- **Playground:** https://labs.play-with-k8s.com/

### Courses
- **Kubernetes for Absolute Beginners** - KodeKloud
- **Kubernetes Mastery** - Udemy (Stephen Grider)
- **CKA/CKAD Prep** - Linux Academy

### Tools
- **Lens** - Kubernetes IDE
- **k9s** - Terminal UI
- **kubectl-aliases** - Shortcuts
- **Helm** - Package manager

---

## ✅ Checklist

### Beginner
- [ ] Installed kubectl & cluster
- [ ] Created first pod
- [ ] Created deployment
- [ ] Exposed service
- [ ] Viewed logs

### Intermediate
- [ ] Used ConfigMaps & Secrets
- [ ] Set up Ingress
- [ ] Used PersistentVolumes
- [ ] Deployed multi-tier app
- [ ] Scaled deployment

### Advanced
- [ ] Rolling updates
- [ ] Health checks
- [ ] Resource limits
- [ ] Horizontal autoscaling
- [ ] Production deployment

---

**Last Updated:** January 2025  
**Status:** ✅ Complete Guide  
**Priority:** 🔴 CRITICAL (Essential for DevOps)

*Master Kubernetes and become a cloud-native expert! ☸️*