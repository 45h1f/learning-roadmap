# 🏗️ System Design Fundamentals 2025-2026

> **Master the art of building scalable systems**: Essential patterns, principles, and architectures for senior+ engineers.

**Last Updated**: January 2025  
**Version**: 2.0  
**Target Audience**: Mid-Level to Senior Engineers

---

## 📋 Table of Contents

1. [What is System Design?](#what-is-system-design)
2. [Core Principles](#core-principles)
3. [Key Concepts](#key-concepts)
4. [Building Blocks](#building-blocks)
5. [Scalability Patterns](#scalability-patterns)
6. [Database Design](#database-design)
7. [Caching Strategies](#caching-strategies)
8. [Message Queues](#message-queues)
9. [Microservices vs Monolith](#microservices-vs-monolith)
10. [Real-World Examples](#real-world-examples)

---

## 🎯 What is System Design?

### **Definition**

System design is the process of defining the **architecture**, **components**, **modules**, **interfaces**, and **data** for a system to satisfy specified requirements.

### **Why It Matters**

- **Senior+ Requirement**: Expected in all senior engineer interviews
- **Production Reality**: Most engineering work involves system design decisions
- **Career Growth**: Distinguishes mid-level from senior engineers
- **Business Impact**: Good design = scalable, maintainable, cost-effective systems

### **When You'll Use It**

- Technical interviews (45-60 min whiteboard sessions)
- Architecture reviews at work
- Planning new features/systems
- Debugging production issues
- Making technology choices

---

## 🧱 Core Principles

### **1. Scalability**

**Definition**: System's ability to handle growing workload

**Types**:
- **Vertical Scaling** (Scale Up): Add more power to existing machines
  - ✅ Simpler
  - ❌ Hardware limits
  - ❌ Single point of failure
  - Example: 8GB → 32GB RAM

- **Horizontal Scaling** (Scale Out): Add more machines
  - ✅ No hard limits
  - ✅ Better redundancy
  - ❌ More complex
  - Example: 1 server → 10 servers

**Best Practice**: Design for horizontal scaling from day 1

---

### **2. Reliability**

**Definition**: System continues to work correctly even when things fail

**Key Metrics**:
- **Availability**: % of time system is operational
  - 99.9% = 8.76 hours downtime/year
  - 99.99% = 52.56 minutes downtime/year
  - 99.999% = 5.26 minutes downtime/year

**Techniques**:
- Redundancy (backup components)
- Replication (data copies)
- Failover (automatic switch to backup)
- Health checks
- Graceful degradation

---

### **3. Maintainability**

**Definition**: Ease of fixing bugs, adding features, and operating the system

**Best Practices**:
- Clean code and architecture
- Comprehensive documentation
- Monitoring and alerting
- Automated testing
- Infrastructure as Code

---

### **4. Performance**

**Definition**: System's responsiveness and throughput

**Key Metrics**:
- **Latency**: Time to complete one operation
- **Throughput**: Number of operations per second
- **Response Time**: Time from request to response

**Targets** (typical web apps):
- API response: < 200ms
- Page load: < 2 seconds
- Database query: < 100ms

---

### **5. Security**

**Definition**: Protection against unauthorized access and data breaches

**Key Areas**:
- Authentication (who are you?)
- Authorization (what can you do?)
- Encryption (in transit and at rest)
- Input validation
- Rate limiting
- DDoS protection

---

## 🔑 Key Concepts

### **CAP Theorem**

**Statement**: A distributed system can only provide 2 of 3 guarantees:

1. **Consistency**: All nodes see the same data at the same time
2. **Availability**: Every request gets a response
3. **Partition Tolerance**: System works despite network failures

**Real-World Choices**:
- **CP System**: Bank transactions (consistency over availability)
- **AP System**: Social media feeds (availability over consistency)
- **Note**: Network partitions happen, so choose between C and A

**Example**:
- **MongoDB**: CP (default) or AP (configurable)
- **Cassandra**: AP
- **PostgreSQL**: CA (not partition tolerant)

---

### **Load Balancing**

**Purpose**: Distribute incoming traffic across multiple servers

**Algorithms**:
1. **Round Robin**: Rotate through servers sequentially
2. **Least Connections**: Send to server with fewest active connections
3. **IP Hash**: Use client IP to determine server
4. **Weighted Round Robin**: Servers with different capacities

**Types**:
- **Layer 4** (Transport): Route based on IP/port
- **Layer 7** (Application): Route based on HTTP headers, cookies, URLs

**Popular Tools**:
- Nginx
- HAProxy
- AWS ELB/ALB
- Google Cloud Load Balancer

**Example**:
```
User Request
    ↓
Load Balancer (Nginx)
    ↓
├─→ Server 1
├─→ Server 2
└─→ Server 3
```

---

### **Caching**

**Purpose**: Store frequently accessed data in fast storage

**Levels**:
1. **Browser Cache**: Client-side
2. **CDN**: Edge locations (static content)
3. **Application Cache**: In-memory (Redis)
4. **Database Cache**: Query results

**Strategies**:

**1. Cache-Aside (Lazy Loading)**
```
1. Check cache
2. If miss → Query database
3. Store in cache
4. Return data
```
✅ Only cache what's needed
❌ Cache miss penalty

**2. Write-Through**
```
1. Write to cache
2. Write to database
3. Return success
```
✅ Cache always fresh
❌ Write latency

**3. Write-Behind**
```
1. Write to cache
2. Return success
3. Async write to database
```
✅ Fast writes
❌ Risk of data loss

**Popular Tools**:
- Redis (most common)
- Memcached
- CDN (Cloudflare, CloudFront)

---

### **Database Sharding**

**Purpose**: Split database across multiple machines

**Strategies**:

**1. Horizontal Sharding** (Most common)
- Split rows across databases
- Example: Users 1-1M → DB1, Users 1M-2M → DB2

**2. Vertical Sharding**
- Split columns across databases
- Example: User profile → DB1, User posts → DB2

**Sharding Key Selection**:
- ✅ Evenly distributed
- ✅ Avoids hotspots
- ❌ Hard to change later

**Challenges**:
- Joins across shards (difficult)
- Transactions across shards (very difficult)
- Rebalancing shards

**Example** (by user ID):
```
User ID % 3 = Shard
User 1 → Shard 1
User 2 → Shard 2
User 3 → Shard 0
User 4 → Shard 1
```

---

### **Database Replication**

**Purpose**: Copy data across multiple databases

**Master-Slave** (Primary-Replica):
```
Master (Writes)
    ↓
├─→ Slave 1 (Reads)
├─→ Slave 2 (Reads)
└─→ Slave 3 (Reads)
```
✅ Read scaling
✅ Backup
❌ Replication lag
❌ Single write point

**Master-Master** (Multi-Primary):
```
Master 1 ←→ Master 2
```
✅ Write scaling
✅ High availability
❌ Conflict resolution complex

---

### **Consistent Hashing**

**Purpose**: Distribute data across nodes with minimal reshuffling

**Problem it solves**:
- Normal hashing: Adding/removing node = rehash everything
- Consistent hashing: Only affects 1/n of data

**Use Cases**:
- Load balancing
- Distributed caching
- Database sharding

**Implementation**: Hash ring

---

## 🧩 Building Blocks

### **1. DNS (Domain Name System)**

**Purpose**: Translate domain names to IP addresses

**How it works**:
```
User types: www.example.com
    ↓
Browser cache → OS cache → Router cache
    ↓
DNS Resolver (ISP)
    ↓
Root DNS → TLD DNS (.com) → Authoritative DNS
    ↓
Returns: 192.168.1.1
```

**Latency**: 20-100ms
**TTL**: Time to cache DNS records

---

### **2. CDN (Content Delivery Network)**

**Purpose**: Deliver static content from geographically distributed servers

**What to cache**:
- Images, videos
- CSS, JavaScript
- Static HTML

**Benefits**:
- ✅ Reduced latency
- ✅ Reduced server load
- ✅ DDoS protection
- ✅ HTTPS termination

**Popular CDNs**:
- Cloudflare
- AWS CloudFront
- Fastly
- Akamai

---

### **3. API Gateway**

**Purpose**: Single entry point for all clients

**Responsibilities**:
- Routing
- Authentication
- Rate limiting
- Request/response transformation
- Caching
- Logging

**Tools**:
- Kong
- AWS API Gateway
- Azure API Management
- Nginx

---

### **4. Message Queue**

**Purpose**: Asynchronous communication between services

**Use Cases**:
- Decouple services
- Handle traffic spikes
- Background jobs
- Event-driven architecture

**Patterns**:

**1. Point-to-Point**:
```
Producer → Queue → Consumer
```

**2. Publish-Subscribe**:
```
Publisher → Topic
    ↓
├─→ Subscriber 1
├─→ Subscriber 2
└─→ Subscriber 3
```

**Popular Tools**:
- RabbitMQ
- Apache Kafka
- AWS SQS
- Redis Streams

---

### **5. Search Engine**

**Purpose**: Full-text search at scale

**When to use**:
- Complex text queries
- Fuzzy matching
- Faceted search
- Autocomplete

**Popular Tools**:
- Elasticsearch (most popular)
- Solr
- Algolia (hosted)
- Typesense

**Example Use Case**:
- E-commerce product search
- Log analysis
- Document search

---

## 📊 Scalability Patterns

### **Pattern 1: Read-Heavy Systems**

**Characteristics**: 90%+ reads, 10% writes

**Solutions**:
1. **Caching** (Redis)
2. **Database Replication** (Read replicas)
3. **CDN** (Static content)

**Example**: News website, blog

**Architecture**:
```
Users → Load Balancer
    ↓
App Servers (with cache)
    ↓
Master DB ←→ Slave DB 1
         ←→ Slave DB 2
         ←→ Slave DB 3
```

---

### **Pattern 2: Write-Heavy Systems**

**Characteristics**: High write throughput needed

**Solutions**:
1. **Database Sharding**
2. **Message Queues** (buffer writes)
3. **NoSQL databases** (Cassandra)
4. **Batch processing**

**Example**: Analytics, logging, social media

**Architecture**:
```
Users → API
    ↓
Message Queue (Kafka)
    ↓
Workers
    ↓
Sharded Databases
```

---

### **Pattern 3: Real-Time Systems**

**Characteristics**: Low latency critical

**Solutions**:
1. **WebSockets**
2. **In-memory databases** (Redis)
3. **Edge computing**
4. **Server-sent events**

**Example**: Chat, live sports, stock trading

---

### **Pattern 4: Data-Intensive Systems**

**Characteristics**: Large data volumes

**Solutions**:
1. **Data Lakes** (S3)
2. **Data Warehouses** (Snowflake)
3. **Stream Processing** (Kafka Streams)
4. **Batch Processing** (Spark)

**Example**: Analytics, ML training

---

## 💾 Database Design

### **SQL vs NoSQL**

| Factor | SQL | NoSQL |
|--------|-----|-------|
| **Schema** | Fixed | Flexible |
| **Scalability** | Vertical | Horizontal |
| **Consistency** | Strong | Eventual |
| **Transactions** | ACID | Limited |
| **Queries** | Complex | Simple |
| **Use Case** | Structured data | Unstructured, high scale |

**SQL (PostgreSQL, MySQL)**:
✅ Complex queries
✅ ACID transactions
✅ Relationships
❌ Harder to scale

**NoSQL Types**:

1. **Document** (MongoDB, Couchbase)
   - Use: Flexible schema, nested data

2. **Key-Value** (Redis, DynamoDB)
   - Use: Simple lookups, caching

3. **Column-Family** (Cassandra, HBase)
   - Use: Time-series, write-heavy

4. **Graph** (Neo4j, Amazon Neptune)
   - Use: Relationships, social networks

---

### **Indexing**

**Purpose**: Speed up queries

**Types**:

**1. B-Tree Index** (Default)
- Equality and range queries
- Ordered results

**2. Hash Index**
- Equality only
- Faster than B-Tree

**3. Full-Text Index**
- Text search
- Elasticsearch, PostgreSQL

**Best Practices**:
- Index columns in WHERE, JOIN, ORDER BY
- Don't over-index (slows writes)
- Monitor query performance
- Use composite indexes carefully

---

### **Normalization vs Denormalization**

**Normalization** (SQL standard):
✅ No redundancy
✅ Data integrity
❌ Multiple joins

**Denormalization** (NoSQL common):
✅ Fast reads
✅ No joins
❌ Data redundancy
❌ Update complexity

**Best Practice**: Denormalize for read-heavy systems

---

## ⚡ Caching Strategies

### **What to Cache**

✅ **Good candidates**:
- Database query results
- API responses
- Computed values
- Session data
- Static content

❌ **Bad candidates**:
- Frequently changing data
- Large objects
- Personalized data (carefully)

---

### **Cache Invalidation**

**Strategies**:

**1. TTL (Time to Live)**
```
Set key with expiration: 1 hour
After 1 hour → Automatic deletion
```

**2. Write-Through**
```
On update:
1. Update database
2. Update cache
```

**3. Cache-Aside Invalidation**
```
On update:
1. Update database
2. Delete from cache
```

**Best Practice**: Combine TTL + invalidation

---

### **Cache Stampede Prevention**

**Problem**: Cache expires → 1000s of requests hit DB

**Solutions**:

**1. Locking**
```
if not in cache:
    acquire lock
    if still not in cache:
        fetch from DB
        set in cache
    release lock
```

**2. Probabilistic Early Expiration**
```
Refresh before expiration randomly
```

---

## 📨 Message Queues

### **When to Use**

✅ Asynchronous processing
✅ Decouple services
✅ Handle traffic spikes
✅ Retry logic
✅ Event-driven systems

### **Patterns**

**1. Task Queue**
```
API → Queue → Worker
```
Example: Email sending, image processing

**2. Event Bus**
```
Service A → Event → Service B
                  → Service C
                  → Service D
```
Example: User registration triggers multiple actions

**3. Stream Processing**
```
Kafka → Stream Processor → Output
```
Example: Real-time analytics

---

### **Guarantees**

**At-most-once**: May lose messages
**At-least-once**: May duplicate messages (most common)
**Exactly-once**: No loss, no duplicates (expensive)

---

## 🏢 Microservices vs Monolith

### **Monolith**

**Architecture**: Single deployable unit

✅ **Pros**:
- Simple to develop
- Easy to deploy
- Easy to test
- Good for small teams

❌ **Cons**:
- Scales as one unit
- Hard to maintain (large codebase)
- Tight coupling
- Long deployment times

**When to use**: Startups, MVPs, small teams

---

### **Microservices**

**Architecture**: Multiple independent services

✅ **Pros**:
- Independent scaling
- Technology diversity
- Team autonomy
- Fault isolation

❌ **Cons**:
- Complex deployment
- Network overhead
- Data consistency challenges
- More operational overhead

**When to use**: Large teams, complex domains, high scale

---

### **Service Mesh**

**Purpose**: Handle service-to-service communication

**Features**:
- Service discovery
- Load balancing
- Encryption
- Observability

**Tools**:
- Istio
- Linkerd
- Consul

---

## 🌍 Real-World Examples

### **Example 1: URL Shortener (bit.ly)**

**Requirements**:
- Shorten URLs
- Redirect to original URL
- 100M URLs/day
- Low latency

**Design**:
```
1. URL Shortening:
   User → API → Generate short code → Store in DB

2. URL Redirection:
   User → CDN (cache) → API → DB → Redirect

Database Schema:
- short_url (PK, indexed)
- long_url
- created_at
- clicks

Short Code Generation:
- Base62 encoding (a-z, A-Z, 0-9)
- 6 characters = 62^6 = 56 billion URLs

Caching:
- Redis: short_url → long_url
- TTL: 1 hour
- Cache hot URLs
```

**Scaling**:
- Read-heavy: Cache + Read replicas
- Write: Shard by hash(short_url)

---

### **Example 2: News Feed (Twitter/Facebook)**

**Requirements**:
- Post updates
- View feed
- Follow users
- 500M users
- Low latency feed

**Design**:

**Option 1: Pull Model** (Fetch on demand)
```
User opens app →
  Query: Get posts from followed users →
  Sort by timestamp →
  Return
```
✅ Simple
❌ Slow for celebrities

**Option 2: Push Model** (Precompute feeds)
```
User posts →
  For each follower:
    Add post to their feed cache
```
✅ Fast reads
❌ Slow for celebrities

**Hybrid Approach** (Best):
- Push for regular users
- Pull for celebrities
- Cache in Redis

**Schema**:
```
Posts:
- post_id (PK)
- user_id
- content
- timestamp

Follows:
- follower_id
- followee_id

Feed Cache (Redis):
- user_id → [post_ids...]
```

---

### **Example 3: Video Streaming (YouTube)**

**Requirements**:
- Upload videos
- Stream videos
- Recommendations
- 1B users

**Design**:

**Upload Pipeline**:
```
1. Upload to S3
2. Transcode (multiple qualities)
3. Generate thumbnails
4. Update database
5. Process with ML (recommendations)
```

**Streaming**:
```
User → CDN → Video chunks
```

**Components**:
- **Storage**: S3 (petabytes)
- **CDN**: CloudFront
- **Transcoding**: AWS Elastic Transcoder
- **Database**: MySQL (metadata), Cassandra (analytics)
- **Recommendations**: ML models

---

## 🎓 Key Takeaways

1. **No Perfect Design**: Trade-offs everywhere
2. **Start Simple**: Optimize when needed
3. **Measure First**: Don't premature optimize
4. **CAP Theorem**: Choose consistency or availability
5. **Cache Aggressively**: 80% of requests hit cache
6. **Async When Possible**: Use message queues
7. **Database Last**: Cache, CDN, then DB
8. **Monitor Everything**: You can't improve what you don't measure

---

## 📝 System Design Interview Framework

### **Step 1: Requirements (5 min)**
- Functional: What does the system do?
- Non-functional: Scale, performance, availability

### **Step 2: Estimation (5 min)**
- Users
- Requests per second
- Storage
- Bandwidth

### **Step 3: API Design (5 min)**
- Define key endpoints
- Request/response formats

### **Step 4: High-Level Design (10 min)**
- Draw boxes and arrows
- Client → Load Balancer → Servers → Database

### **Step 5: Deep Dive (20 min)**
- Interviewer chooses areas
- Database schema
- Caching strategy
- Scaling plan

### **Step 6: Discuss (5 min)**
- Bottlenecks
- Trade-offs
- Monitoring

---

## 🔗 Related Resources

- **08_System_Design/PATTERNS.md** - Design patterns catalog
- **08_System_Design/SCALABILITY.md** - Scaling strategies
- **08_System_Design/CASE_STUDIES.md** - Real system designs
- **09_Interview_Prep/TECHNICAL_ROUNDS.md** - System design interviews

---

**Remember**: System design is learned through practice and experience. Study these fundamentals, but always design for your specific requirements.

**Happy designing!** 🏗️