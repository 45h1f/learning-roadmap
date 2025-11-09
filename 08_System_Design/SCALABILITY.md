# 📈 Scalability Strategies

> **"Scalability is not just about handling more load. It's about doing so efficiently, reliably, and cost-effectively."**

A comprehensive guide to scaling systems from zero to millions of users.

---

## 📋 Table of Contents

1. [Understanding Scalability](#understanding-scalability)
2. [Horizontal vs Vertical Scaling](#horizontal-vs-vertical-scaling)
3. [Database Scaling](#database-scaling)
4. [Caching Strategies](#caching-strategies)
5. [Load Balancing](#load-balancing)
6. [Content Delivery Networks](#content-delivery-networks)
7. [Microservices Scaling](#microservices-scaling)
8. [Async Processing](#async-processing)
9. [Real-World Scaling Journey](#real-world-scaling-journey)
10. [Cost Optimization](#cost-optimization)

---

## 🎯 Understanding Scalability

### What is Scalability?

```markdown
Scalability = Ability to handle increased load

Types of Load:
- More users (10 → 1,000 → 1,000,000)
- More data (1GB → 1TB → 1PB)
- More requests (100/s → 10k/s → 1M/s)
- More features (simple → complex)
- More geographic regions (1 → 10 → 100)

Good scalability:
✅ Performance stays consistent
✅ Costs grow linearly (not exponentially)
✅ System remains reliable
✅ Development velocity maintained

Bad scalability:
❌ Slow performance under load
❌ Frequent outages
❌ Exponential cost growth
❌ Can't add features without breaking things
```

### The Scalability Ladder

```text
Stage 1: 0-1k users          Single server
Stage 2: 1k-10k users         Add caching, CDN
Stage 3: 10k-100k users       Scale database, load balancer
Stage 4: 100k-1M users        Microservices, async jobs
Stage 5: 1M-10M users         Multi-region, sharding
Stage 6: 10M+ users           Custom infrastructure, edge computing
```

### Key Metrics

```markdown
## Latency
- P50: 50% of requests (median)
- P95: 95% of requests
- P99: 99% of requests
- P99.9: 99.9% of requests

Example:
P50: 100ms  → Most users happy
P95: 200ms  → Some slowness
P99: 500ms  → Noticeable lag
P99.9: 2s   → Bad experience

Goal: Optimize for P95, monitor P99

## Throughput
- Requests per second (RPS)
- Transactions per second (TPS)
- Queries per second (QPS)

Example:
100 RPS → Small app
1,000 RPS → Medium app
10,000 RPS → Large app
100,000+ RPS → Massive scale

## Availability
- 99% = 7.2 hours downtime/month
- 99.9% = 43.2 minutes downtime/month
- 99.99% = 4.32 minutes downtime/month
- 99.999% = 25.9 seconds downtime/month

Cost increases exponentially with each "9"
```

---

## ⚖️ Horizontal vs Vertical Scaling

### Vertical Scaling (Scale Up)

**Definition:** Add more resources to a single machine

```text
Before:              After:
┌─────────┐          ┌─────────┐
│ 4 CPU   │    →     │ 16 CPU  │
│ 8GB RAM │          │ 64GB RAM│
│ 100GB   │          │ 1TB SSD │
└─────────┘          └─────────┘
```

**Pros:**
- ✅ Simple (no code changes)
- ✅ No distributed system complexity
- ✅ Lower latency (no network hops)
- ✅ Consistent state (single machine)

**Cons:**
- ❌ Hardware limits (can't scale infinitely)
- ❌ Single point of failure
- ❌ Downtime during upgrades
- ❌ Expensive (bigger machines cost exponentially more)

**When to use:**
- Early stage (< 10k users)
- Database optimization
- Quick fix while planning horizontal scaling
- Workloads that can't be distributed

---

### Horizontal Scaling (Scale Out)

**Definition:** Add more machines

```text
Before:              After:
┌─────────┐          ┌─────────┐ ┌─────────┐ ┌─────────┐
│ Server  │    →     │Server 1 │ │Server 2 │ │Server 3 │
│         │          │         │ │         │ │         │
└─────────┘          └─────────┘ └─────────┘ └─────────┘
```

**Pros:**
- ✅ No hard limits (add infinite machines)
- ✅ High availability (redundancy)
- ✅ No downtime for scaling
- ✅ Better cost efficiency at scale

**Cons:**
- ❌ Complex (distributed systems)
- ❌ Data consistency challenges
- ❌ Network latency
- ❌ More moving parts

**Requirements:**
- Load balancer
- Stateless application servers
- Shared data layer (database, cache)
- Session management

---

### Making Apps Horizontally Scalable

```typescript
// ❌ NOT Scalable (Stateful)
let sessionData = {}; // In-memory state

app.post('/login', (req, res) => {
  const user = authenticateUser(req.body);
  sessionData[user.id] = user; // Stored on this server only
  res.json({ success: true });
});

app.get('/profile', (req, res) => {
  const user = sessionData[req.userId]; // Only works if same server
  res.json(user);
});

// ✅ Scalable (Stateless)
import Redis from 'ioredis';
const redis = new Redis();

app.post('/login', async (req, res) => {
  const user = authenticateUser(req.body);
  const token = generateToken(user);
  
  // Store in shared Redis
  await redis.setex(`session:${token}`, 3600, JSON.stringify(user));
  
  res.json({ token });
});

app.get('/profile', async (req, res) => {
  const token = req.headers.authorization;
  const userData = await redis.get(`session:${token}`);
  
  if (!userData) return res.status(401).json({ error: 'Unauthorized' });
  
  res.json(JSON.parse(userData));
});

// Any server can handle any request!
```

---

## 🗄️ Database Scaling

### Read Replicas

**Problem:** Too many read queries slow down database

**Solution:** Create read-only copies of database

```text
                    ┌──────────────┐
                    │   Primary    │
                    │  (Writes)    │
                    └───────┬──────┘
                            │
              ┌─────────────┼─────────────┐
              │             │             │
              ▼             ▼             ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │Replica 1 │  │Replica 2 │  │Replica 3 │
        │ (Reads)  │  │ (Reads)  │  │ (Reads)  │
        └──────────┘  └──────────┘  └──────────┘
```

**Implementation:**

```typescript
import { Pool } from 'pg';

// Primary database (writes)
const primaryDb = new Pool({
  host: 'primary.db.example.com',
  database: 'myapp',
  max: 20
});

// Read replicas (reads)
const replicaDb1 = new Pool({
  host: 'replica1.db.example.com',
  database: 'myapp',
  max: 50
});

const replicaDb2 = new Pool({
  host: 'replica2.db.example.com',
  database: 'myapp',
  max: 50
});

// Simple load balancer
const replicas = [replicaDb1, replicaDb2];
let replicaIndex = 0;

function getReadConnection() {
  const replica = replicas[replicaIndex];
  replicaIndex = (replicaIndex + 1) % replicas.length;
  return replica;
}

// Usage
async function getUser(userId: string) {
  // Read from replica
  const db = getReadConnection();
  const result = await db.query('SELECT * FROM users WHERE id = $1', [userId]);
  return result.rows[0];
}

async function updateUser(userId: string, data: any) {
  // Write to primary
  await primaryDb.query(
    'UPDATE users SET name = $1 WHERE id = $2',
    [data.name, userId]
  );
}

// Handle replication lag
async function getUserAfterWrite(userId: string) {
  // Read from primary to ensure consistency
  const result = await primaryDb.query(
    'SELECT * FROM users WHERE id = $1',
    [userId]
  );
  return result.rows[0];
}
```

**Benefits:**
- ✅ Scale read capacity
- ✅ Reduce load on primary
- ✅ Geographic distribution

**Considerations:**
- ⚠️ Replication lag (eventual consistency)
- ⚠️ Read-after-write consistency issues
- ⚠️ Failover complexity

---

### Database Sharding

**Problem:** Single database too large, too slow

**Solution:** Split data across multiple databases

```text
┌────────────────────────────────────────┐
│         Application Layer              │
└──────┬────────┬────────┬───────────────┘
       │        │        │
       ▼        ▼        ▼
   ┌──────┐ ┌──────┐ ┌──────┐
   │Shard1│ │Shard2│ │Shard3│
   │      │ │      │ │      │
   │Users │ │Users │ │Users │
   │ 0-33%│ │34-66%│ │67-99%│
   └──────┘ └──────┘ └──────┘
```

**Sharding Strategies:**

```typescript
// 1. Hash-based Sharding
function getShardByUserId(userId: string): Database {
  const hash = hashFunction(userId);
  const shardIndex = hash % NUM_SHARDS;
  return shards[shardIndex];
}

// 2. Range-based Sharding
function getShardByUserId(userId: string): Database {
  const id = parseInt(userId);
  if (id < 1000000) return shard1;
  if (id < 2000000) return shard2;
  return shard3;
}

// 3. Geographic Sharding
function getShardByRegion(region: string): Database {
  const shardMap = {
    'us-east': usEastShard,
    'us-west': usWestShard,
    'eu': euShard,
    'asia': asiaShard
  };
  return shardMap[region];
}

// Sharding middleware
class ShardedDatabase {
  private shards: Map<number, Database>;
  
  constructor(shardConfigs: ShardConfig[]) {
    this.shards = new Map();
    shardConfigs.forEach((config, index) => {
      this.shards.set(index, new Database(config));
    });
  }
  
  private getShard(key: string): Database {
    const hash = this.hashFunction(key);
    const shardId = hash % this.shards.size;
    return this.shards.get(shardId)!;
  }
  
  async findById(table: string, id: string) {
    const shard = this.getShard(id);
    return await shard.query(`SELECT * FROM ${table} WHERE id = $1`, [id]);
  }
  
  async insert(table: string, id: string, data: any) {
    const shard = this.getShard(id);
    return await shard.query(
      `INSERT INTO ${table} (id, data) VALUES ($1, $2)`,
      [id, JSON.stringify(data)]
    );
  }
  
  // Cross-shard queries are expensive!
  async findAll(table: string): Promise<any[]> {
    const results = await Promise.all(
      Array.from(this.shards.values()).map(shard =>
        shard.query(`SELECT * FROM ${table}`)
      )
    );
    return results.flat();
  }
  
  private hashFunction(key: string): number {
    let hash = 0;
    for (let i = 0; i < key.length; i++) {
      hash = ((hash << 5) - hash) + key.charCodeAt(i);
      hash = hash & hash; // Convert to 32-bit integer
    }
    return Math.abs(hash);
  }
}

// Usage
const db = new ShardedDatabase([
  { host: 'shard1.db.com', database: 'myapp' },
  { host: 'shard2.db.com', database: 'myapp' },
  { host: 'shard3.db.com', database: 'myapp' }
]);

// All user data for userId goes to same shard
const user = await db.findById('users', userId);
const posts = await db.findById('posts', userId); // Same shard
```

**Benefits:**
- ✅ Horizontal scalability
- ✅ Improved performance
- ✅ Better fault isolation

**Challenges:**
- ❌ Complex implementation
- ❌ Cross-shard queries are slow
- ❌ Rebalancing is hard
- ❌ Hotspot issues (uneven distribution)

---

### Database Connection Pooling

**Problem:** Creating new DB connections is expensive

**Solution:** Reuse connections

```typescript
import { Pool } from 'pg';

// ❌ Bad: New connection per request
async function getUser(userId: string) {
  const client = new Client({
    host: 'db.example.com',
    database: 'myapp'
  });
  await client.connect(); // Slow!
  const result = await client.query('SELECT * FROM users WHERE id = $1', [userId]);
  await client.end();
  return result.rows[0];
}

// ✅ Good: Connection pool
const pool = new Pool({
  host: 'db.example.com',
  database: 'myapp',
  max: 20,        // Max connections
  min: 5,         // Min connections
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000
});

async function getUser(userId: string) {
  // Reuses existing connection from pool
  const result = await pool.query('SELECT * FROM users WHERE id = $1', [userId]);
  return result.rows[0];
}

// Monitor pool health
setInterval(() => {
  console.log({
    total: pool.totalCount,
    idle: pool.idleCount,
    waiting: pool.waitingCount
  });
}, 10000);
```

**Sizing Guidelines:**

```markdown
## Formula
connections = ((core_count * 2) + effective_spindle_count)

Example:
- 4 CPU cores
- connections = (4 * 2) + 1 = 9

## Per Server
- Small app: 10-20 connections
- Medium app: 20-50 connections
- Large app: 50-100 connections

## Watch for
- High waiting count → Increase pool size
- High idle count → Decrease pool size
- Connection timeouts → Increase timeout or pool size
```

---

## 🚀 Caching Strategies

### Multi-Layer Caching

```text
User Request
    │
    ▼
┌─────────────────┐
│  Browser Cache  │  (Static assets, 1 hour)
└────────┬────────┘
         │ Miss
         ▼
┌─────────────────┐
│   CDN Cache     │  (Images, CSS, JS, 1 day)
└────────┬────────┘
         │ Miss
         ▼
┌─────────────────┐
│  Redis Cache    │  (API responses, 5 min)
└────────┬────────┘
         │ Miss
         ▼
┌─────────────────┐
│    Database     │
└─────────────────┘
```

### Cache Implementation

```typescript
// Multi-layer cache
class CacheManager {
  constructor(
    private redis: Redis,
    private memoryCache: Map<string, any>
  ) {}
  
  async get<T>(key: string): Promise<T | null> {
    // Layer 1: Memory cache (fastest)
    if (this.memoryCache.has(key)) {
      console.log('Memory cache hit');
      return this.memoryCache.get(key);
    }
    
    // Layer 2: Redis (fast)
    const cached = await this.redis.get(key);
    if (cached) {
      console.log('Redis cache hit');
      const value = JSON.parse(cached);
      this.memoryCache.set(key, value); // Promote to memory
      return value;
    }
    
    console.log('Cache miss');
    return null;
  }
  
  async set(key: string, value: any, ttl: number) {
    // Store in both layers
    this.memoryCache.set(key, value);
    await this.redis.setex(key, ttl, JSON.stringify(value));
  }
  
  async delete(key: string) {
    this.memoryCache.delete(key);
    await this.redis.del(key);
  }
}

// Usage with cache-aside pattern
const cache = new CacheManager(redis, new Map());

async function getUser(userId: string) {
  const cacheKey = `user:${userId}`;
  
  // Try cache
  let user = await cache.get<User>(cacheKey);
  
  if (!user) {
    // Load from database
    user = await db.users.findById(userId);
    
    if (user) {
      // Store in cache
      await cache.set(cacheKey, user, 3600); // 1 hour
    }
  }
  
  return user;
}
```

### Cache Warming

**Problem:** Cold cache leads to slow initial requests

**Solution:** Pre-populate cache

```typescript
// Warm cache on startup
async function warmCache() {
  console.log('Warming cache...');
  
  // Popular users
  const popularUsers = await db.query(
    'SELECT id FROM users ORDER BY follower_count DESC LIMIT 1000'
  );
  
  for (const user of popularUsers.rows) {
    const userData = await db.users.findById(user.id);
    await cache.set(`user:${user.id}`, userData, 3600);
  }
  
  // Popular posts
  const popularPosts = await db.query(
    'SELECT id FROM posts ORDER BY view_count DESC LIMIT 5000'
  );
  
  for (const post of popularPosts.rows) {
    const postData = await db.posts.findById(post.id);
    await cache.set(`post:${post.id}`, postData, 1800);
  }
  
  console.log('Cache warmed');
}

// Run on server start
app.listen(3000, async () => {
  await warmCache();
  console.log('Server ready');
});

// Periodic refresh
setInterval(warmCache, 3600000); // Every hour
```

---

## ⚖️ Load Balancing

### Load Balancing Algorithms

```text
┌──────────────────────────────────────┐
│         Load Balancer                │
└──────┬────────┬────────┬─────────────┘
       │        │        │
       ▼        ▼        ▼
   ┌──────┐ ┌──────┐ ┌──────┐
   │ Srv1 │ │ Srv2 │ │ Srv3 │
   └──────┘ └──────┘ └──────┘
```

**1. Round Robin**

```typescript
class RoundRobinLoadBalancer {
  private currentIndex = 0;
  
  constructor(private servers: Server[]) {}
  
  getNext(): Server {
    const server = this.servers[this.currentIndex];
    this.currentIndex = (this.currentIndex + 1) % this.servers.length;
    return server;
  }
}

// Usage
const lb = new RoundRobinLoadBalancer([server1, server2, server3]);

app.use((req, res, next) => {
  const server = lb.getNext();
  proxy.web(req, res, { target: server.url });
});
```

**2. Least Connections**

```typescript
class LeastConnectionsLoadBalancer {
  private connections: Map<Server, number> = new Map();
  
  constructor(private servers: Server[]) {
    servers.forEach(s => this.connections.set(s, 0));
  }
  
  getNext(): Server {
    let minServer = this.servers[0];
    let minConnections = this.connections.get(minServer)!;
    
    for (const server of this.servers) {
      const conns = this.connections.get(server)!;
      if (conns < minConnections) {
        minConnections = conns;
        minServer = server;
      }
    }
    
    this.connections.set(minServer, minConnections + 1);
    return minServer;
  }
  
  releaseConnection(server: Server) {
    const current = this.connections.get(server)!;
    this.connections.set(server, current - 1);
  }
}
```

**3. Weighted Round Robin**

```typescript
class WeightedLoadBalancer {
  private currentIndex = 0;
  private currentWeight = 0;
  
  constructor(private servers: Array<{ server: Server; weight: number }>) {}
  
  getNext(): Server {
    let maxWeight = Math.max(...this.servers.map(s => s.weight));
    
    while (true) {
      this.currentIndex = (this.currentIndex + 1) % this.servers.length;
      
      if (this.currentIndex === 0) {
        this.currentWeight = this.currentWeight - 1;
        if (this.currentWeight <= 0) {
          this.currentWeight = maxWeight;
        }
      }
      
      if (this.servers[this.currentIndex].weight >= this.currentWeight) {
        return this.servers[this.currentIndex].server;
      }
    }
  }
}

// Usage: More powerful server gets more traffic
const lb = new WeightedLoadBalancer([
  { server: server1, weight: 5 },  // Powerful server
  { server: server2, weight: 3 },  // Medium server
  { server: server3, weight: 1 }   // Weak server
]);
```

**4. IP Hash (Sticky Sessions)**

```typescript
class IpHashLoadBalancer {
  constructor(private servers: Server[]) {}
  
  getNext(clientIp: string): Server {
    const hash = this.hashFunction(clientIp);
    const index = hash % this.servers.length;
    return this.servers[index];
  }
  
  private hashFunction(str: string): number {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      hash = ((hash << 5) - hash) + str.charCodeAt(i);
      hash = hash & hash;
    }
    return Math.abs(hash);
  }
}

// Same IP always goes to same server
app.use((req, res, next) => {
  const server = lb.getNext(req.ip);
  proxy.web(req, res, { target: server.url });
});
```

---

### Health Checks

```typescript
class HealthCheckedLoadBalancer {
  private healthyServers: Set<Server> = new Set();
  
  constructor(private servers: Server[]) {
    this.servers.forEach(s => this.healthyServers.add(s));
    this.startHealthChecks();
  }
  
  private startHealthChecks() {
    setInterval(() => {
      this.servers.forEach(async server => {
        try {
          const response = await fetch(`${server.url}/health`, {
            timeout: 2000
          });
          
          if (response.ok) {
            if (!this.healthyServers.has(server)) {
              console.log(`Server ${server.url} is back online`);
              this.healthyServers.add(server);
            }
          } else {
            throw new Error('Unhealthy');
          }
        } catch (err) {
          console.log(`Server ${server.url} is down`);
          this.healthyServers.delete(server);
        }
      });
    }, 5000); // Check every 5 seconds
  }
  
  getNext(): Server {
    if (this.healthyServers.size === 0) {
      throw new Error('No healthy servers available');
    }
    
    const healthy = Array.from(this.healthyServers);
    return healthy[Math.floor(Math.random() * healthy.length)];
  }
}
```

---

## 🌐 Content Delivery Networks (CDN)

### CDN Strategy

```text
┌──────────────┐
│    User      │
│  (Tokyo)     │
└──────┬───────┘
       │
       ▼
┌──────────────────┐
│  CDN Edge Node   │  (Tokyo - closest)
│  Cached Content  │
└──────────────────┘
       │ Cache Miss
       ▼
┌──────────────────┐
│  Origin Server   │  (US)
│  Dynamic Content │
└──────────────────┘
```

### Implementing CDN

```typescript
// Next.js with CDN
export default function Image({ src, alt }) {
  // Automatic CDN via Vercel/Cloudflare
  return <img src={src} alt={alt} />;
}

// Custom CDN implementation
const CDN_URL = 'https://cdn.example.com';

function getCdnUrl(path: string): string {
  // Static assets go to CDN
  if (path.match(/\.(jpg|png|css|js)$/)) {
    return `${CDN_URL}${path}`;
  }
  return path;
}

// Upload to CDN
async function uploadToCdn(file: File): Promise<string> {
  const filename = `${Date.now()}-${file.name}`;
  
  // Upload to S3 (automatically distributed by CloudFront)
  await s3.putObject({
    Bucket: 'my-cdn-bucket',
    Key: filename,
    Body: file,
    ContentType: file.type,
    CacheControl: 'public, max-age=31536000' // 1 year
  });
  
  return `${CDN_URL}/${filename}`;
}

// Set proper cache headers
app.use('/static', express.static('public', {
  maxAge: '1y', // Browser cache
  immutable: true
}));

app.get('/api/posts', (req, res) => {
  res.set({
    'Cache-Control': 'public, max-age=300', // 5 minutes
    'CDN-Cache-Control': 'public, max-age=3600' // CDN: 1 hour
  });
  res.json(posts);
});
```

### Cache Invalidation

```typescript
// Versioned assets (best practice)
// styles.css → styles.abc123.css
// No invalidation needed, old version cached separately

// Manual purge (when needed)
async function purgeCdnCache(paths: string[]) {
  // CloudFlare example
  await fetch('https://api.cloudflare.com/client/v4/zones/ZONE_ID/purge_cache', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${CLOUDFLARE_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ files: paths })
  });
}

// Purge on content update
async function updatePost(postId: string, data: any) {
  await db.posts.update(postId, data);
  
  // Purge CDN cache
  await purgeCdnCache([
    `https://cdn.example.com/api/posts/${postId}`,
    `https://cdn.example.com/api/posts`
  ]);
}
```

---

## 🔧 Microservices Scaling

### Service Discovery

```typescript
// Using Consul or etcd
class ServiceRegistry {
  private services: Map<string, string[]> = new Map();
  
  async register(serviceName: string, instanceUrl: string) {
    if (!this.services.has(serviceName)) {
      this.services.set(serviceName, []);
    }
    this.services.get(serviceName)!.push(instanceUrl);
    
    // Heartbeat to keep registration alive
    setInterval(() => this.heartbeat(serviceName, instanceUrl), 10000);
  }
  
  async discover(serviceName: string): string {
    const instances = this.services.get(serviceName);
    if (!instances || instances.length === 0) {
      throw new Error(`No instances of ${serviceName} available`);
    }
    
    // Random selection
    return instances[Math.floor(Math.random() * instances.length)];
  }
  
  private async heartbeat(serviceName: string, instanceUrl: string) {
    try {
      await fetch(`${instanceUrl}/health`);
    } catch (err) {
      // Remove dead instance
      const instances = this.services.get(serviceName)!;
      this.services.set(
        serviceName,
        instances.filter(url => url !== instanceUrl)
      );
    }
  }
}

// Usage
const registry = new ServiceRegistry();

// Service registers itself on startup
await registry.register('user-service', 'http://localhost:3001');

// Other services discover it
const userServiceUrl = await registry.discover('user-service');
const response = await fetch(`${userServiceUrl}/users/123`);
```

### Auto-scaling

```typescript
// Kubernetes HPA (Horizontal Pod Autoscaler) config
const hpaConfig = {
  apiVersion: 'autoscaling/v2',
  kind: 'HorizontalPodAutoscaler',
  metadata: {
    name: 'user-service-hpa'
  },
  spec: {
    scaleTargetRef: {
      apiVersion: 'apps/v1',
      kind: 'Deployment',
      name: 'user-service'
    },
    minReplicas: 3,
    maxReplicas: 10,
    metrics: [
      {
        type: 'Resource',
        resource: {
          name: 'cpu',
          target: {
            type: 'Utilization',
            averageUtilization: 70 // Scale up at 70% CPU
          }
        }
      },
      {
        type: 'Resource',
        resource: {
          name: 'memory',
          target: {
            type: 'Utilization',
            averageUtilization: 80
          }
        }
      }
    ]
  }
};

// Custom metrics (e.g., queue length)
const customMetricHpa = {
  // ... same as above
  metrics: [
    {
      type: 'External',
      external: {
        metric: {
          name: 'queue_length',
          selector: {
            matchLabels: {
              queue_name: 'email-queue'
            }
          }
        },
        target: {
          type: 'Value',
          value: '100' // Scale up if queue > 100
        }
      }
    }
  ]
};
```

---

## ⚡ Async Processing

### Job Queue Pattern

```typescript
// Using BullMQ
import { Queue, Worker } from 'bullmq';

// Producer
const emailQueue = new Queue('emails', {
  connection: {
    host: 'localhost',
    port: 6379
  }
});

async function sendEmailAsync(to: string, subject: string, body: string) {
  await emailQueue.add('send-email', {
    to,
    subject,
    body
  }, {
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    },
    removeOnComplete: true
  });
}

// Consumer (separate process/server)
const emailWorker = new Worker('emails', async job => {
  const { to, subject, body } = job.data;
  
  console.log(`Sending email to ${to}...`);
  await emailService.send(to, subject, body);
  
  return { sent: true, timestamp: new Date() };
}, {
  connection: {
    host: 'localhost',
    port: 6379
  },
  concurrency: 5 // Process 5 emails concurrently
});

emailWorker.on('completed', job => {
  console.log(`Email ${job.id} sent successfully`);
});

emailWorker.on('failed', (job, err) => {
  console.error(`Email ${job?.id} failed:`, err);
});

// Scale workers independently
// Start 10 worker instances to process emails faster
```

### Batch Processing

```typescript
// Collect and process in batches
class BatchProcessor<T> {
  private batch: T[] = [];
  private timer: NodeJS.Timeout | null = null;
  
  constructor(
    private processFn: (items: T[]) => Promise<void>,
    private batchSize: number = 100,
    private maxWaitMs: number = 5000
  ) {}
  
  async add(item: T) {
    this.batch.push(item);
    
    // Process if batch is full
    if (this.batch.length >= this.batchSize) {
      await this.flush();
    } else if (!this.timer) {
      // Start timer for first item
      this.timer = setTimeout(() => this.flush(), this.maxWaitMs);
    }
  }
  
  private async flush() {
    if (this.batch.length === 0) return;
    
    if (this.timer) {
      clearTimeout(this.timer);
      this.timer = null;
    }
    
    const items = [...this.batch];
    this.batch = [];
    
    try {
      await this.processFn(items);
      console.log(`Processed batch of ${items.length} items`);
    } catch (err) {
      console.error('Batch processing failed:', err);
      // Could re-queue items here
    }
  }
}

// Usage: Batch database writes
const dbBatcher = new BatchProcessor(
  async (users: User[]) => {
    await db.users.insertMany(users);
  },
  100,  // Batch size
  5000  // Max wait
);

// Individual writes get batched automatically
await dbBatcher.add({ name: 'Alice', email: 'alice@example.com' });
await dbBatcher.add({ name: 'Bob', email: 'bob@example.com' });
// ... more adds ...
// When batch is full (100) or 5 seconds pass, writes execute
```

---

## 🚀 Real-World Scaling Journey

### Stage 1: Single Server (0-1k users)

```text
┌─────────────────────────┐
│   Single Server         │
│  - Next.js App          │
│  - PostgreSQL           │
│  - Redis (cache)        │
└─────────────────────────┘

Cost: $20-50/month
Users: 1-1,000
Requests: < 10/second
```

**Implementation:**

```typescript
// Simple monolith
const app = express();

// Database
const db = new Pool({ connectionString: DATABASE_URL });

// Cache
const redis = new Redis(REDIS_URL);

// All in one
app.get('/api/posts', async (req, res) => {
  const cacheKey = 'posts:all';
  const cached = await redis.get(cacheKey);
  
  if (cached) {
    return res.json(JSON.parse(cached));
  }
  
  const posts = await db.query('SELECT * FROM posts ORDER BY created_at DESC');
  await redis.setex(cacheKey, 300, JSON.stringify(posts.rows));
  
  res.json(posts.rows);
});

app.listen(3000);
```

---

### Stage 2: Add CDN (1k-10k users)

```text
┌──────────┐
│   CDN    │  (Static assets)
└────┬─────┘
     │
┌────▼───────────────────┐
│   App Server           │
│  - API                 │
│  - Database            │
│  - Redis               │
└────────────────────────┘

Cost: $100-200/month
Users: 1k-10k
Requests: 10-100/second
```

**Changes:**

```typescript
// Separate static assets
app.use('/static', express.static('public', {
  maxAge: '1y',
  immutable: true
}));

// Upload images to S3/CDN
const cdnUrl = await uploadToCdn(imageFile);
```

---

### Stage 3: Horizontal Scaling (10k-100k users)

```text
                ┌──────────┐
                │   CDN    │
                └────┬─────┘
                     │
                ┌────▼──────────┐
                │Load Balancer  │
                └────┬──────────┘
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐
    │ App 1  │  │ App 2  │  │ App 3  │
    └────┬───┘  └────┬───┘  └────┬───┘
         │           │           │
         └───────────┼───────────┘
                     ▼
              ┌─────────────┐
              │  Database   │
              │  + Replicas │
              └─────────────┘
                     │
              ┌──────▼──────┐
              │    Redis    │
              │   Cluster   │
              └─────────────┘

Cost: $500-1,000/month
Users: 10k-100k
Requests: 100-1,000/second
```

**Changes:**

```typescript
// Make app stateless
// Sessions in Redis, not memory

// Connection pooling
const db = new Pool({
  max: 20,
  min: 5
});

// Read replicas
const readDb = new Pool({ host: 'replica.db.com' });

app.get('/api/posts', async (req, res) => {
  // Read from replica
  const posts = await readDb.query('SELECT * FROM posts');
  res.json(posts.rows);
});
```

---

### Stage 4: Microservices (100k-1M users)

```text
                ┌──────────┐
                │   CDN    │
                └────┬─────┘
                     │
                ┌────▼──────────┐
                │ API Gateway   │
                └────┬──────────┘
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐
    │ Users  │  │ Posts  │  │ Search │
    │Service │  │Service │  │Service │
    └────┬───┘  └────┬───┘  └────┬───┘
         │           │           │
         ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐
    │Users DB│  │Posts DB│  │Elastic │
    └────────┘  └────────┘  └────────┘

Cost: $2,000-5,000/month
Users: 100k-1M
Requests: 1k-10k/second
```

**Changes:**

```typescript
// Separate services
// User Service
const userService = express();
userService.get('/users/:id', getUserHandler);

// Post Service
const postService = express();
postService.get('/posts', getPostsHandler);

// Event-driven communication
eventBus.on('user.created', async (event) => {
  // Post service reacts to user creation
  await denormalizeUserData(event.userId);
});
```

---

### Stage 5: Multi-Region (1M-10M users)

```text
     US Region                      EU Region
┌─────────────────┐          ┌─────────────────┐
│  CDN + Servers  │          │  CDN + Servers  │
│                 │          │                 │
│  ┌──────────┐   │          │  ┌──────────┐   │
│  │Database  │   │◄────────►│  │Database  │   │
│  │(Primary) │   │   Sync   │  │(Replica) │   │
│  └──────────┘   │          │  └──────────┘   │
└─────────────────┘          └─────────────────┘

Cost: $10,000-50,000/month
Users: 1M-10M
Requests: 10k-100k/second
```

---

## 💰 Cost Optimization

### Right-Sizing Resources

```markdown
## Avoid Over-Provisioning

❌ Bad:
- 16 CPU server for app using 2 CPU average
- 64GB RAM for app using 8GB
- Cost: $500/month

✅ Good:
- 4 CPU server with auto-scaling
- 16GB RAM
- Scale up during peaks
- Cost: $100/month average

Savings: $400/month = $4,800/year
```

### Spot Instances for Batch Jobs

```typescript
// AWS SDK - Use spot instances for background jobs
const ec2 = new EC2Client({});

await ec2.send(new RunInstancesCommand({
  ImageId: 'ami-12345',
  InstanceType: 't3.large',
  MinCount: 1,
  MaxCount: 1,
  InstanceMarketOptions: {
    MarketType: 'spot',
    SpotOptions: {
      MaxPrice: '0.05', // 70% cheaper than on-demand
      SpotInstanceType: 'one-time'
    }
  }
}));

// Savings: 50-70% on compute costs for interruptible workloads
```

### Reserved Instances

```markdown
For predictable baseline load:

On-Demand: $0.10/hour = $876/year
1-Year Reserved: $0.06/hour = $525/year (40% savings)
3-Year Reserved: $0.04/hour = $350/year (60% savings)

Strategy:
- Reserved for baseline (always-on servers)
- On-demand/spot for burst capacity
```

---

## 📊 Monitoring Scalability

### Key Metrics to Track

```typescript
import prometheus from 'prom-client';

// Request rate
const httpRequestsTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status']
});

// Response time
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'route'],
  buckets: [0.01, 0.05, 0.1, 0.5, 1, 2, 5]
});

// Active connections
const activeConnections = new prometheus.Gauge({
  name: 'active_connections',
  help: 'Number of active connections'
});

// Queue length
const queueLength = new prometheus.Gauge({
  name: 'job_queue_length',
  help: 'Number of jobs in queue'
});

// Middleware
app.use((req, res, next) => {
  const start = Date.now();
  
  activeConnections.inc();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestsTotal.labels(req.method, req.route.path, res.statusCode).inc();
    httpRequestDuration.labels(req.method, req.route.path).observe(duration);
    activeConnections.dec();
  });
  
  next();
});

// Alert if queue too long
setInterval(async () => {
  const length = await getQueueLength();
  queueLength.set(length);
  
  if (length > 1000) {
    alert('Queue length critical: ' + length);
    // Auto-scale workers
    await scaleWorkers(Math.ceil(length / 100));
  }
}, 10000);
```

---

## 🎬 Summary

### Scaling Checklist

```markdown
## 0-1k Users
- [ ] Single server
- [ ] Basic caching (Redis)
- [ ] Database indexes
- [ ] Monitoring setup

## 1k-10k Users
- [ ] CDN for static assets
- [ ] Database connection pooling
- [ ] Application-level caching
- [ ] Basic monitoring

## 10k-100k Users
- [ ] Load balancer
- [ ] Horizontal scaling (2-3 app servers)
- [ ] Database read replicas
- [ ] Redis cluster
- [ ] Async job processing
- [ ] Auto-scaling setup

## 100k-1M Users
- [ ] Microservices (if needed)
- [ ] Database sharding (if needed)
- [ ] Advanced caching (multi-layer)
- [ ] Message queues
- [ ] Full observability stack

## 1M-10M Users
- [ ] Multi-region deployment
- [ ] CDN optimization
- [ ] Advanced auto-scaling
- [ ] Cost optimization
- [ ] Dedicated ops team
```

### Key Principles

1. **Measure First** - Don't optimize prematurely
2. **Vertical → Horizontal** - Scale up before scaling out
3. **Cache Everything** - But invalidate smartly
4. **Async When Possible** - Don't block the main thread
5. **Monitor Always** - You can't fix what you can't see
6. **Start Simple** - Add complexity only when needed
7. **Test at Scale** - Load test before you need to

---

**Related Resources:**
- **[PATTERNS.md](./PATTERNS.md)** - Design patterns for scalability
- **[CASE_STUDIES.md](./CASE_STUDIES.md)** - Real-world scaling stories
- **[FUNDAMENTALS.md](./FUNDAMENTALS.md)** - Core design principles

---

**Remember: Premature optimization is the root of all evil. Scale when metrics tell you to, not when you feel like it.** 📊🚀