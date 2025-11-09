# 🏗️ System Design Patterns

> **"Good architecture is less about the decisions you make and more about the decisions you defer."** - Robert C. Martin

A comprehensive guide to common system design patterns for building scalable applications.

---

## 📋 Table of Contents

1. [Introduction to Design Patterns](#introduction-to-design-patterns)
2. [API Design Patterns](#api-design-patterns)
3. [Data Management Patterns](#data-management-patterns)
4. [Caching Patterns](#caching-patterns)
5. [Messaging Patterns](#messaging-patterns)
6. [Resilience Patterns](#resilience-patterns)
7. [Scalability Patterns](#scalability-patterns)
8. [Security Patterns](#security-patterns)
9. [Observability Patterns](#observability-patterns)
10. [Real-World Examples](#real-world-examples)

---

## 🎯 Introduction to Design Patterns

### What Are System Design Patterns?

```markdown
System Design Patterns = Proven solutions to common problems

Why they matter:
✅ Don't reinvent the wheel
✅ Learn from others' mistakes
✅ Communicate design decisions clearly
✅ Scale systems effectively
✅ Handle failures gracefully

Not cargo-culting:
❌ Don't use patterns just because they're popular
✅ Understand the problem first, then apply pattern
```

### Pattern Categories

```text
┌─────────────────────────────────────────────────────┐
│                 SYSTEM DESIGN PATTERNS              │
├─────────────────────────────────────────────────────┤
│                                                     │
│  API Design          │  Data Management            │
│  - REST              │  - Database per Service     │
│  - GraphQL           │  - Saga Pattern             │
│  - tRPC              │  - CQRS                     │
│  - gRPC              │  - Event Sourcing           │
│                      │                             │
│  Caching             │  Messaging                  │
│  - Cache-Aside       │  - Pub/Sub                  │
│  - Write-Through     │  - Message Queue            │
│  - Write-Behind      │  - Event-Driven             │
│  - Refresh-Ahead     │  - Stream Processing        │
│                      │                             │
│  Resilience          │  Scalability                │
│  - Circuit Breaker   │  - Load Balancing           │
│  - Retry             │  - Sharding                 │
│  - Timeout           │  - CDN                      │
│  - Bulkhead          │  - Horizontal Scaling       │
│                      │                             │
└─────────────────────────────────────────────────────┘
```

---

## 🌐 API Design Patterns

### 1. RESTful API Pattern

**Problem:** Need standard way to expose resources over HTTP

**Solution:** REST (Representational State Transfer)

```markdown
## REST Principles

### Resources
Everything is a resource with a URI:
- GET    /users          → List users
- GET    /users/123      → Get user 123
- POST   /users          → Create user
- PUT    /users/123      → Update user 123
- PATCH  /users/123      → Partial update
- DELETE /users/123      → Delete user 123

### HTTP Methods (Verbs)
- GET: Read (idempotent, safe)
- POST: Create
- PUT: Replace (idempotent)
- PATCH: Partial update
- DELETE: Remove (idempotent)

### Status Codes
- 200 OK: Success
- 201 Created: Resource created
- 204 No Content: Success, no body
- 400 Bad Request: Client error
- 401 Unauthorized: Authentication required
- 403 Forbidden: No permission
- 404 Not Found: Resource doesn't exist
- 500 Internal Server Error: Server error

### Stateless
Each request contains all information needed.
No session state on server.
```

**Example:**

```typescript
// REST API Design
app.get('/api/posts', async (req, res) => {
  const { page = 1, limit = 10, sort = 'createdAt' } = req.query;
  
  const posts = await db.posts.find({
    skip: (page - 1) * limit,
    limit: limit,
    sort: { [sort]: -1 }
  });
  
  res.json({
    data: posts,
    meta: {
      page,
      limit,
      total: await db.posts.count()
    },
    links: {
      self: `/api/posts?page=${page}`,
      next: `/api/posts?page=${page + 1}`,
      prev: page > 1 ? `/api/posts?page=${page - 1}` : null
    }
  });
});

// Nested resources
app.get('/api/posts/:postId/comments', async (req, res) => {
  const comments = await db.comments.find({
    postId: req.params.postId
  });
  res.json({ data: comments });
});
```

**When to Use:**
- ✅ Public APIs
- ✅ CRUD operations
- ✅ Resource-based systems
- ✅ Standard HTTP clients

**When NOT to Use:**
- ❌ Complex queries (over-fetching/under-fetching)
- ❌ Real-time updates (use WebSockets)
- ❌ Type safety across client/server (use tRPC/gRPC)

---

### 2. GraphQL Pattern

**Problem:** REST leads to over-fetching and multiple round trips

**Solution:** GraphQL - client specifies exactly what data it needs

```graphql
# GraphQL Schema
type User {
  id: ID!
  name: String!
  email: String!
  posts: [Post!]!
}

type Post {
  id: ID!
  title: String!
  content: String!
  author: User!
  comments: [Comment!]!
}

type Query {
  user(id: ID!): User
  posts(limit: Int, offset: Int): [Post!]!
}

type Mutation {
  createPost(title: String!, content: String!): Post!
  updatePost(id: ID!, title: String, content: String): Post!
}

type Subscription {
  postCreated: Post!
}
```

**Implementation:**

```typescript
// GraphQL Resolver
const resolvers = {
  Query: {
    user: async (_, { id }, context) => {
      return await context.db.users.findById(id);
    },
    posts: async (_, { limit = 10, offset = 0 }) => {
      return await db.posts.find().skip(offset).limit(limit);
    }
  },
  
  User: {
    // Nested resolver - only fetches if requested
    posts: async (user, _, context) => {
      return await context.db.posts.find({ authorId: user.id });
    }
  },
  
  Mutation: {
    createPost: async (_, { title, content }, context) => {
      if (!context.user) throw new Error('Unauthorized');
      return await context.db.posts.create({
        title,
        content,
        authorId: context.user.id
      });
    }
  },
  
  Subscription: {
    postCreated: {
      subscribe: () => pubsub.asyncIterator(['POST_CREATED'])
    }
  }
};

// Client Query (React)
const GET_USER_WITH_POSTS = gql`
  query GetUser($id: ID!) {
    user(id: $id) {
      id
      name
      posts {
        id
        title
      }
    }
  }
`;

function UserProfile({ userId }) {
  const { data, loading } = useQuery(GET_USER_WITH_POSTS, {
    variables: { id: userId }
  });
  
  if (loading) return <Spinner />;
  return <div>{data.user.name}</div>;
}
```

**Benefits:**
- ✅ No over-fetching (client gets exactly what it asks for)
- ✅ No under-fetching (get all data in one request)
- ✅ Strongly typed
- ✅ Introspection (self-documenting)
- ✅ Real-time subscriptions

**Drawbacks:**
- ❌ Complexity (learning curve)
- ❌ Caching harder than REST
- ❌ N+1 query problem (need DataLoader)
- ❌ Harder to monitor/rate-limit

---

### 3. tRPC Pattern (Type-Safe RPC)

**Problem:** Want type safety between frontend and backend without code generation

**Solution:** tRPC - End-to-end type safety with TypeScript

```typescript
// Backend: Define API router
import { initTRPC } from '@trpc/server';
import { z } from 'zod';

const t = initTRPC.create();

export const appRouter = t.router({
  // Query
  getUser: t.procedure
    .input(z.object({ id: z.string() }))
    .query(async ({ input }) => {
      return await db.users.findById(input.id);
    }),
  
  // Mutation
  createPost: t.procedure
    .input(z.object({
      title: z.string().min(1).max(100),
      content: z.string().min(1)
    }))
    .mutation(async ({ input, ctx }) => {
      if (!ctx.user) throw new TRPCError({ code: 'UNAUTHORIZED' });
      return await db.posts.create({
        ...input,
        authorId: ctx.user.id
      });
    }),
  
  // Subscription
  onPostCreated: t.procedure
    .subscription(() => {
      return observable((emit) => {
        const handler = (post) => emit.next(post);
        eventEmitter.on('postCreated', handler);
        return () => eventEmitter.off('postCreated', handler);
      });
    })
});

export type AppRouter = typeof appRouter;

// Frontend: Use with full type safety
import { createTRPCReact } from '@trpc/react-query';
import type { AppRouter } from './server/router';

const trpc = createTRPCReact<AppRouter>();

function UserProfile({ userId }: { userId: string }) {
  // Full autocomplete and type checking!
  const { data, isLoading } = trpc.getUser.useQuery({ id: userId });
  
  const createPost = trpc.createPost.useMutation();
  
  const handleCreatePost = async () => {
    await createPost.mutateAsync({
      title: 'Hello',
      content: 'World'
    });
  };
  
  if (isLoading) return <div>Loading...</div>;
  return <div>{data.name}</div>; // TypeScript knows 'name' exists!
}
```

**Benefits:**
- ✅ Full type safety (compile-time errors)
- ✅ No code generation needed
- ✅ Auto-complete in IDE
- ✅ Lightweight (no schemas, just TypeScript)
- ✅ React Query integration

**When to Use:**
- ✅ Full-stack TypeScript projects
- ✅ Monorepo setup
- ✅ Internal APIs (not public)
- ✅ Want rapid development

---

### 4. API Gateway Pattern

**Problem:** Clients need to call multiple microservices directly

**Solution:** Single entry point that routes requests to appropriate services

```text
┌──────────────┐
│   Clients    │
│  (Web, iOS,  │
│   Android)   │
└──────┬───────┘
       │
       ▼
┌──────────────────────────────────┐
│        API Gateway               │
│  - Authentication                │
│  - Rate Limiting                 │
│  - Request Routing               │
│  - Response Aggregation          │
│  - Protocol Translation          │
└──────┬────────┬────────┬─────────┘
       │        │        │
       ▼        ▼        ▼
    ┌────┐  ┌────┐  ┌────┐
    │User│  │Post│  │Cart│
    │Svc │  │Svc │  │Svc │
    └────┘  └────┘  └────┘
```

**Implementation:**

```typescript
// Using Express + http-proxy-middleware
import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import rateLimit from 'express-rate-limit';

const app = express();

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);

// Authentication middleware
app.use(async (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Unauthorized' });
  
  try {
    req.user = await verifyToken(token);
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid token' });
  }
});

// Route to user service
app.use('/api/users', createProxyMiddleware({
  target: 'http://user-service:3001',
  changeOrigin: true,
  pathRewrite: { '^/api/users': '' }
}));

// Route to post service
app.use('/api/posts', createProxyMiddleware({
  target: 'http://post-service:3002',
  changeOrigin: true,
  pathRewrite: { '^/api/posts': '' }
}));

// Aggregation endpoint (BFF pattern)
app.get('/api/dashboard', async (req, res) => {
  const [user, posts, notifications] = await Promise.all([
    fetch(`http://user-service:3001/users/${req.user.id}`),
    fetch(`http://post-service:3002/users/${req.user.id}/posts`),
    fetch(`http://notification-service:3003/users/${req.user.id}/notifications`)
  ]);
  
  res.json({
    user: await user.json(),
    posts: await posts.json(),
    notifications: await notifications.json()
  });
});
```

**Benefits:**
- ✅ Single entry point
- ✅ Cross-cutting concerns (auth, logging, rate limiting)
- ✅ Protocol translation (REST → gRPC)
- ✅ Response aggregation

**Considerations:**
- ⚠️ Single point of failure (mitigate with HA)
- ⚠️ Can become bottleneck
- ⚠️ Additional network hop

---

## 💾 Data Management Patterns

### 1. Database per Service Pattern

**Problem:** Microservices sharing a database creates tight coupling

**Solution:** Each service owns its own database

```text
┌─────────────────┐     ┌─────────────────┐
│  User Service   │     │  Order Service  │
│                 │     │                 │
│  ┌───────────┐  │     │  ┌───────────┐  │
│  │  User DB  │  │     │  │ Order DB  │  │
│  └───────────┘  │     │  └───────────┘  │
└─────────────────┘     └─────────────────┘
        ▲                       ▲
        │                       │
        └───────────┬───────────┘
                    │
              ┌─────┴─────┐
              │   Events  │
              │   (Sync)  │
              └───────────┘
```

**Implementation:**

```typescript
// User Service
class UserService {
  private db: UserDatabase;
  
  async createUser(userData: CreateUserDto) {
    const user = await this.db.users.create(userData);
    
    // Publish event for other services
    await eventBus.publish('user.created', {
      userId: user.id,
      email: user.email,
      name: user.name
    });
    
    return user;
  }
}

// Order Service (listens to user events)
class OrderService {
  private db: OrderDatabase;
  
  async initialize() {
    // Subscribe to user events
    await eventBus.subscribe('user.created', async (event) => {
      // Store denormalized user data needed for orders
      await this.db.userCache.create({
        userId: event.userId,
        email: event.email,
        name: event.name
      });
    });
  }
  
  async createOrder(userId: string, items: Item[]) {
    // Use cached user data (no cross-service query)
    const user = await this.db.userCache.findById(userId);
    if (!user) throw new Error('User not found');
    
    return await this.db.orders.create({
      userId,
      userEmail: user.email, // Denormalized
      items
    });
  }
}
```

**Benefits:**
- ✅ Service independence
- ✅ Technology flexibility (Postgres for one, MongoDB for another)
- ✅ Easier to scale services independently
- ✅ Loose coupling

**Challenges:**
- ❌ Data consistency across services
- ❌ No foreign keys across databases
- ❌ Complex queries spanning services

---

### 2. Saga Pattern

**Problem:** Distributed transactions across microservices

**Solution:** Sequence of local transactions with compensating actions

```markdown
## Choreography-Based Saga

Each service publishes events and listens for events.

Example: E-commerce order

1. Order Service: Create order → Publish "OrderCreated"
2. Inventory Service: Reserve items → Publish "InventoryReserved"
3. Payment Service: Charge customer → Publish "PaymentProcessed"
4. Shipping Service: Create shipment → Publish "ShipmentCreated"

If any step fails → Trigger compensating transactions:
- Payment failed → Release inventory
- Shipping failed → Refund payment, release inventory
```

**Implementation:**

```typescript
// Order Service
class OrderService {
  async createOrder(userId: string, items: Item[]) {
    // Step 1: Create order (pending)
    const order = await db.orders.create({
      userId,
      items,
      status: 'PENDING'
    });
    
    // Publish event
    await eventBus.publish('order.created', {
      orderId: order.id,
      userId,
      items
    });
    
    return order;
  }
  
  // Listen for success/failure events
  async initialize() {
    await eventBus.subscribe('payment.processed', async (event) => {
      await db.orders.update(event.orderId, { status: 'CONFIRMED' });
    });
    
    await eventBus.subscribe('payment.failed', async (event) => {
      await db.orders.update(event.orderId, { status: 'CANCELLED' });
      // Compensating action
      await eventBus.publish('order.cancelled', { orderId: event.orderId });
    });
  }
}

// Inventory Service
class InventoryService {
  async initialize() {
    await eventBus.subscribe('order.created', async (event) => {
      try {
        // Reserve inventory
        await this.reserveItems(event.items);
        await eventBus.publish('inventory.reserved', {
          orderId: event.orderId
        });
      } catch (err) {
        await eventBus.publish('inventory.failed', {
          orderId: event.orderId,
          reason: err.message
        });
      }
    });
    
    // Compensating action
    await eventBus.subscribe('order.cancelled', async (event) => {
      await this.releaseItems(event.orderId);
    });
  }
}

// Payment Service
class PaymentService {
  async initialize() {
    await eventBus.subscribe('inventory.reserved', async (event) => {
      try {
        await this.chargeCustomer(event.orderId);
        await eventBus.publish('payment.processed', {
          orderId: event.orderId
        });
      } catch (err) {
        await eventBus.publish('payment.failed', {
          orderId: event.orderId
        });
      }
    });
    
    // Compensating action
    await eventBus.subscribe('order.cancelled', async (event) => {
      await this.refundCustomer(event.orderId);
    });
  }
}
```

**Benefits:**
- ✅ No distributed transactions (ACID)
- ✅ Services remain decoupled
- ✅ Better scalability

**Challenges:**
- ❌ Complex to implement
- ❌ Hard to debug
- ❌ Eventual consistency

---

### 3. CQRS (Command Query Responsibility Segregation)

**Problem:** Read and write operations have different requirements

**Solution:** Separate read and write models

```text
           ┌──────────────┐
           │   Commands   │
           │   (Writes)   │
           └──────┬───────┘
                  │
                  ▼
          ┌──────────────┐
          │  Write Model │
          │  (Postgres)  │
          └──────┬───────┘
                 │
        ┌────────┴────────┐
        │   Event Bus     │
        └────────┬────────┘
                 │
                 ▼
          ┌──────────────┐
          │  Read Model  │
          │  (Optimized) │
          │   MongoDB/   │
          │ Elasticsearch│
          └──────┬───────┘
                 │
                 ▼
           ┌──────────────┐
           │   Queries    │
           │   (Reads)    │
           └──────────────┘
```

**Implementation:**

```typescript
// Write Model (Commands)
class PostCommandHandler {
  async createPost(command: CreatePostCommand) {
    const post = await writeDb.posts.create({
      title: command.title,
      content: command.content,
      authorId: command.authorId
    });
    
    // Publish event to sync read model
    await eventBus.publish('post.created', {
      postId: post.id,
      title: post.title,
      content: post.content,
      authorId: post.authorId,
      createdAt: post.createdAt
    });
    
    return post.id;
  }
  
  async updatePost(command: UpdatePostCommand) {
    await writeDb.posts.update(command.postId, {
      title: command.title,
      content: command.content
    });
    
    await eventBus.publish('post.updated', {
      postId: command.postId,
      title: command.title,
      content: command.content
    });
  }
}

// Read Model (Queries) - Optimized for reading
class PostQueryHandler {
  async initialize() {
    // Sync read model from events
    await eventBus.subscribe('post.created', async (event) => {
      // Denormalized view with author details
      const author = await readDb.users.findById(event.authorId);
      await readDb.postViews.create({
        postId: event.postId,
        title: event.title,
        content: event.content,
        authorName: author.name, // Denormalized!
        authorAvatar: author.avatar,
        createdAt: event.createdAt,
        commentCount: 0,
        likeCount: 0
      });
      
      // Also index in Elasticsearch for full-text search
      await elasticsearch.index({
        index: 'posts',
        id: event.postId,
        body: {
          title: event.title,
          content: event.content,
          authorName: author.name
        }
      });
    });
  }
  
  // Optimized read queries
  async getPostWithDetails(postId: string) {
    // Single query - all data denormalized
    return await readDb.postViews.findById(postId);
  }
  
  async searchPosts(query: string) {
    // Fast full-text search
    return await elasticsearch.search({
      index: 'posts',
      body: {
        query: {
          multi_match: {
            query,
            fields: ['title', 'content']
          }
        }
      }
    });
  }
}
```

**Benefits:**
- ✅ Optimized reads (denormalized, cached)
- ✅ Optimized writes (normalized, transactional)
- ✅ Scale read and write independently
- ✅ Multiple read models for different use cases

**When to Use:**
- ✅ Read/write ratio is very different
- ✅ Complex read queries
- ✅ Need multiple representations of data

---

## 🚀 Caching Patterns

### 1. Cache-Aside (Lazy Loading)

**Pattern:** Application checks cache first, loads from DB if miss

```typescript
async function getUser(userId: string): Promise<User> {
  const cacheKey = `user:${userId}`;
  
  // 1. Check cache
  const cached = await redis.get(cacheKey);
  if (cached) {
    console.log('Cache hit');
    return JSON.parse(cached);
  }
  
  console.log('Cache miss');
  
  // 2. Load from database
  const user = await db.users.findById(userId);
  if (!user) throw new Error('User not found');
  
  // 3. Store in cache
  await redis.setex(cacheKey, 3600, JSON.stringify(user)); // 1 hour TTL
  
  return user;
}

// Invalidate on update
async function updateUser(userId: string, updates: Partial<User>) {
  const user = await db.users.update(userId, updates);
  
  // Invalidate cache
  await redis.del(`user:${userId}`);
  
  return user;
}
```

**Pros:** Simple, works for most cases
**Cons:** Cache miss penalty, stale data possible

---

### 2. Write-Through Cache

**Pattern:** Write to cache and database simultaneously

```typescript
async function updateUser(userId: string, updates: Partial<User>) {
  const cacheKey = `user:${userId}`;
  
  // 1. Write to database
  const user = await db.users.update(userId, updates);
  
  // 2. Write to cache (synchronously)
  await redis.setex(cacheKey, 3600, JSON.stringify(user));
  
  return user;
}

async function getUser(userId: string): Promise<User> {
  const cacheKey = `user:${userId}`;
  const cached = await redis.get(cacheKey);
  
  if (cached) return JSON.parse(cached);
  
  // Cache miss - load and cache
  const user = await db.users.findById(userId);
  await redis.setex(cacheKey, 3600, JSON.stringify(user));
  return user;
}
```

**Pros:** Cache always fresh
**Cons:** Write latency (two writes), wasted cache space

---

### 3. Write-Behind (Write-Back) Cache

**Pattern:** Write to cache immediately, async persist to database

```typescript
class WriteBehindCache {
  private writeQueue: Map<string, any> = new Map();
  
  constructor() {
    // Flush queue every 5 seconds
    setInterval(() => this.flush(), 5000);
  }
  
  async updateUser(userId: string, updates: Partial<User>) {
    const cacheKey = `user:${userId}`;
    
    // 1. Update cache immediately
    const cached = await redis.get(cacheKey);
    const user = cached ? JSON.parse(cached) : await db.users.findById(userId);
    const updated = { ...user, ...updates };
    
    await redis.setex(cacheKey, 3600, JSON.stringify(updated));
    
    // 2. Queue for DB write (async)
    this.writeQueue.set(userId, updated);
    
    return updated;
  }
  
  private async flush() {
    if (this.writeQueue.size === 0) return;
    
    const batch = Array.from(this.writeQueue.entries());
    this.writeQueue.clear();
    
    // Batch write to database
    await Promise.all(
      batch.map(([userId, user]) => 
        db.users.update(userId, user)
      )
    );
    
    console.log(`Flushed ${batch.length} writes to DB`);
  }
}
```

**Pros:** Fast writes, reduced DB load
**Cons:** Data loss risk (cache failure before flush), complexity

---

### 4. Cache Invalidation Strategies

```typescript
// Strategy 1: TTL (Time To Live)
await redis.setex('user:123', 3600, JSON.stringify(user)); // Expires in 1 hour

// Strategy 2: Explicit Invalidation
async function updateUser(userId: string, updates: Partial<User>) {
  const user = await db.users.update(userId, updates);
  await redis.del(`user:${userId}`); // Invalidate
  return user;
}

// Strategy 3: Versioned Keys
async function updateUser(userId: string, updates: Partial<User>) {
  const user = await db.users.update(userId, updates);
  const version = user.updatedAt.getTime();
  await redis.setex(`user:${userId}:${version}`, 3600, JSON.stringify(user));
  await redis.set(`user:${userId}:current`, version);
  return user;
}

// Strategy 4: Pub/Sub Invalidation (Multi-server)
// Server 1: Updates user
async function updateUser(userId: string, updates: Partial<User>) {
  const user = await db.users.update(userId, updates);
  await redis.publish('cache:invalidate', JSON.stringify({
    key: `user:${userId}`
  }));
  return user;
}

// All servers: Listen for invalidation
redis.subscribe('cache:invalidate');
redis.on('message', (channel, message) => {
  const { key } = JSON.parse(message);
  cache.del(key); // Invalidate local cache
});
```

---

## 📨 Messaging Patterns

### 1. Pub/Sub Pattern

**Problem:** Multiple services need to react to the same event

**Solution:** Publisher broadcasts events, multiple subscribers react

```text
                    ┌─────────────┐
                    │  Publisher  │
                    └──────┬──────┘
                           │
                    ┌──────▼──────────┐
                    │   Event Bus     │
                    │  (Redis/Kafka)  │
                    └──┬────┬────┬────┘
                       │    │    │
            ┌──────────┘    │    └──────────┐
            ▼               ▼               ▼
      ┌──────────┐   ┌──────────┐   ┌──────────┐
      │Subscriber│   │Subscriber│   │Subscriber│
      │    1     │   │    2     │   │    3     │
      └──────────┘   └──────────┘   └──────────┘
```

**Implementation:**

```typescript
// Using Redis Pub/Sub
import Redis from 'ioredis';

const publisher = new Redis();
const subscriber = new Redis();

// Publisher
async function publishUserCreated(user: User) {
  await publisher.publish('user.created', JSON.stringify({
    userId: user.id,
    email: user.email,
    name: user.name
  }));
}

// Subscriber 1: Email Service
subscriber.subscribe('user.created');
subscriber.on('message', async (channel, message) => {
  if (channel === 'user.created') {
    const user = JSON.parse(message);
    await sendWelcomeEmail(user.email, user.name);
  }
});

// Subscriber 2: Analytics Service
const analyticsSubscriber = new Redis();
analyticsSubscriber.subscribe('user.created');
analyticsSubscriber.on('message', async (channel, message) => {
  if (channel === 'user.created') {
    const user = JSON.parse(message);
    await trackUserSignup(user.userId);
  }
});

// Subscriber 3: Notification Service
const notificationSubscriber = new Redis();
notificationSubscriber.subscribe('user.created');
notificationSubscriber.on('message', async (channel, message) => {
  if (channel === 'user.created') {
    const user = JSON.parse(message);
    await createNotification(user.userId, 'Welcome!');
  }
});
```

**Benefits:**
- ✅ Loose coupling
- ✅ Easy to add new subscribers
- ✅ Real-time updates

**Considerations:**
- ⚠️ No guaranteed delivery (message can be lost)
- ⚠️ No message persistence
- ⚠️ Need separate solution for reliability

---

### 2. Message Queue Pattern

**Problem:** Need reliable async processing with guaranteed delivery

**Solution:** Message queue with acknowledgment

```typescript
// Using RabbitMQ or AWS SQS
import amqp from 'amqplib';

// Producer
async function sendEmailJob(emailData: EmailData) {
  const connection = await amqp.connect('amqp://localhost');
  const channel = await connection.createChannel();
  
  await channel.assertQueue('email_queue', { durable: true });
  
  channel.sendToQueue(
    'email_queue',
    Buffer.from(JSON.stringify(emailData)),
    { persistent: true } // Survives broker restart
  );
  
  console.log('Email job queued');
}

// Consumer (Worker)
async function startEmailWorker() {
  const connection = await amqp.connect('amqp://localhost');
  const channel = await connection.createChannel();
  
  await channel.assertQueue('email_queue', { durable: true });
  channel.prefetch(1); // Process one at a time
  
  channel.consume('email_queue', async (msg) => {
    if (!msg) return;
    
    const emailData = JSON.parse(msg.content.toString());
    
    try {
      await sendEmail(emailData);
      channel.ack(msg); // Acknowledge success
      console.log('Email sent successfully');
    } catch (err) {
      console.error('Failed to send email:', err);
      channel.nack(msg, false, true); // Requeue for retry
    }
  });
}

// Start multiple workers for parallelism
startEmailWorker();
startEmailWorker();
startEmailWorker();
```

**Benefits:**
- ✅ Guaranteed delivery
- ✅ Load balancing (multiple workers)
- ✅ Retry logic
- ✅ Message persistence

**Use Cases:**
- Background jobs
- Email sending
- Image processing
- Report generation

---

### 3. Event Sourcing Pattern

**Problem:** Need complete audit trail of all changes

**Solution:** Store events, not current state

```typescript
// Event Store
interface Event {
  id: string;
  aggregateId: string;
  type: string;
  data: any;
  timestamp: Date;
  version: number;
}

class EventStore {
  private events: Event[] = [];
  
  async append(event: Event) {
    await db.events.insert(event);
    this.events.push(event);
  }
  
  async getEvents(aggregateId: string): Promise<Event[]> {
    return await db.events.find({ aggregateId }).sort({ version: 1 });
  }
}

// Aggregate
class BankAccount {
  private id: string;
  private balance: number = 0;
  private version: number = 0;
  
  // Apply events to build current state
  static async load(accountId: string): Promise<BankAccount> {
    const events = await eventStore.getEvents(accountId);
    const account = new BankAccount(accountId);
    
    for (const event of events) {
      account.applyEvent(event);
    }
    
    return account;
  }
  
  private applyEvent(event: Event) {
    switch (event.type) {
      case 'AccountOpened':
        this.balance = event.data.initialBalance;
        break;
      case 'MoneyDeposited':
        this.balance += event.data.amount;
        break;
      case 'MoneyWithdrawn':
        this.balance -= event.data.amount;
        break;
    }
    this.version = event.version;
  }
  
  // Command: Deposit money
  async deposit(amount: number) {
    const event: Event = {
      id: uuid(),
      aggregateId: this.id,
      type: 'MoneyDeposited',
      data: { amount },
      timestamp: new Date(),
      version: this.version + 1
    };
    
    await eventStore.append(event);
    this.applyEvent(event);
    
    return this;
  }
  
  async withdraw(amount: number) {
    if (this.balance < amount) {
      throw new Error('Insufficient funds');
    }
    
    const event: Event = {
      id: uuid(),
      aggregateId: this.id,
      type: 'MoneyWithdrawn',
      data: { amount },
      timestamp: new Date(),
      version: this.version + 1
    };
    
    await eventStore.append(event);
    this.applyEvent(event);
    
    return this;
  }
}

// Usage
const account = await BankAccount.load('account-123');
await account.deposit(100);
await account.withdraw(50);

// Rebuild state at any point in time
const events = await eventStore.getEvents('account-123');
const eventsUntilYesterday = events.filter(e => 
  e.timestamp < yesterday
);
// Replay events to get balance yesterday
```

**Benefits:**
- ✅ Complete audit trail
- ✅ Time travel (rebuild state at any point)
- ✅ Event replay for debugging
- ✅ Easy to add projections

**Challenges:**
- ❌ Complex to implement
- ❌ Event schema evolution
- ❌ Storage grows over time

---

## 🛡️ Resilience Patterns

### 1. Circuit Breaker Pattern

**Problem:** Failing service brings down dependent services

**Solution:** Stop calling failing service, fail fast

```typescript
enum CircuitState {
  CLOSED,  // Normal operation
  OPEN,    // Rejecting requests
  HALF_OPEN // Testing if service recovered
}

class CircuitBreaker {
  private state: CircuitState = CircuitState.CLOSED;
  private failureCount: number = 0;
  private lastFailureTime: number = 0;
  private successCount: number = 0;
  
  private threshold: number = 5; // Open after 5 failures
  private timeout: number = 60000; // Try again after 60s
  private successThreshold: number = 2; // Close after 2 successes
  
  async execute<T>(fn: () => Promise<T>): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      if (Date.now() - this.lastFailureTime > this.timeout) {
        this.state = CircuitState.HALF_OPEN;
        console.log('Circuit entering HALF_OPEN state');
      } else {
        throw new Error('Circuit breaker is OPEN');
      }
    }
    
    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (err) {
      this.onFailure();
      throw err;
    }
  }
  
  private onSuccess() {
    this.failureCount = 0;
    
    if (this.state === CircuitState.HALF_OPEN) {
      this.successCount++;
      if (this.successCount >= this.successThreshold) {
        this.state = CircuitState.CLOSED;
        this.successCount = 0;
        console.log('Circuit CLOSED');
      }
    }
  }
  
  private onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    this.successCount = 0;
    
    if (this.failureCount >= this.threshold) {
      this.state = CircuitState.OPEN;
      console.log('Circuit OPEN');
    }
  }
}

// Usage
const breaker = new CircuitBreaker();

async function callExternalAPI() {
  try {
    return await breaker.execute(async () => {
      const response = await fetch('https://api.example.com/data');
      if (!response.ok) throw new Error('API error');
      return await response.json();
    });
  } catch (err) {
    console.log('Circuit breaker prevented call or API failed');
    return getCachedData(); // Fallback
  }
}
```

**States:**
- **CLOSED:** Normal operation
- **OPEN:** Rejecting requests (service is down)
- **HALF_OPEN:** Testing if service recovered

---

### 2. Retry Pattern with Exponential Backoff

**Problem:** Transient failures should be retried

**Solution:** Retry with increasing delays

```typescript
async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 1000
): Promise<T> {
  for (let attempt = 0; attempt <= maxRetries; attempt++) {
    try {
      return await fn();
    } catch (err) {
      if (attempt === maxRetries) {
        throw err; // Final attempt failed
      }
      
      // Exponential backoff: 1s, 2s, 4s, 8s...
      const delay = baseDelay * Math.pow(2, attempt);
      const jitter = Math.random() * 1000; // Add randomness
      
      console.log(`Attempt ${attempt + 1} failed. Retrying in ${delay}ms`);
      await new Promise(resolve => setTimeout(resolve, delay + jitter));
    }
  }
  
  throw new Error('Should not reach here');
}

// Usage
const data = await retryWithBackoff(async () => {
  const response = await fetch('https://api.example.com/data');
  if (!response.ok) throw new Error('API error');
  return await response.json();
}, 3, 1000);

// With timeout per attempt
async function retryWithTimeout<T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  timeout: number = 5000
): Promise<T> {
  return retryWithBackoff(async () => {
    return await Promise.race([
      fn(),
      new Promise<T>((_, reject) => 
        setTimeout(() => reject(new Error('Timeout')), timeout)
      )
    ]);
  }, maxRetries);
}
```

---

### 3. Bulkhead Pattern

**Problem:** One failing component exhausts all resources

**Solution:** Isolate resources for different components

```typescript
// Resource pool pattern
class ConnectionPool {
  private pools: Map<string, number> = new Map();
  
  constructor(private limits: Record<string, number>) {
    Object.keys(limits).forEach(service => {
      this.pools.set(service, 0);
    });
  }
  
  async execute<T>(service: string, fn: () => Promise<T>): Promise<T> {
    const limit = this.limits[service];
    const current = this.pools.get(service) || 0;
    
    if (current >= limit) {
      throw new Error(`${service} pool exhausted (${limit} max)`);
    }
    
    this.pools.set(service, current + 1);
    
    try {
      return await fn();
    } finally {
      this.pools.set(service, this.pools.get(service)! - 1);
    }
  }
}

// Usage
const pool = new ConnectionPool({
  'payment-service': 10,
  'email-service': 5,
  'analytics-service': 20
});

// Payment service gets max 10 concurrent connections
async function processPayment() {
  return await pool.execute('payment-service', async () => {
    return await fetch('https://payment-api.com/charge');
  });
}

// Email service gets max 5 concurrent connections
async function sendEmail() {
  return await pool.execute('email-service', async () => {
    return await fetch('https://email-api.com/send');
  });
}
```

**Benefits:**
- ✅ Failure isolation
- ✅ Prevents resource exhaustion
- ✅ Predictable degradation

---

## 📊 Observability Patterns

### 1. Structured Logging

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'app.log' })
  ]
});

// Structured logging
logger.info('User logged in', {
  userId: '123',
  email: 'user@example.com',
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  duration: 123
});

// Contextual logging
class RequestLogger {
  constructor(private requestId: string) {}
  
  info(message: string, meta: object = {}) {
    logger.info(message, {
      requestId: this.requestId,
      ...meta
    });
  }
  
  error(message: string, error: Error, meta: object = {}) {
    logger.error(message, {
      requestId: this.requestId,
      error: {
        message: error.message,
        stack: error.stack
      },
      ...meta
    });
  }
}

// Usage in request handler
app.use((req, res, next) => {
  req.log = new RequestLogger(req.id);
  next();
});

app.post('/api/posts', async (req, res) => {
  req.log.info('Creating post', { userId: req.user.id });
  
  try {
    const post = await createPost(req.body);
    req.log.info('Post created', { postId: post.id });
    res.json(post);
  } catch (err) {
    req.log.error('Failed to create post', err);
    res.status(500).json({ error: 'Internal error' });
  }
});
```

---

### 2. Distributed Tracing

```typescript
// Using OpenTelemetry
import { trace } from '@opentelemetry/api';

const tracer = trace.getTracer('my-service');

async function processOrder(orderId: string) {
  const span = tracer.startSpan('process-order');
  span.setAttribute('order.id', orderId);
  
  try {
    // Child span
    await tracer.startActiveSpan('validate-order', async (childSpan) => {
      await validateOrder(orderId);
      childSpan.end();
    });
    
    await tracer.startActiveSpan('charge-payment', async (childSpan) => {
      await chargePayment(orderId);
      childSpan.end();
    });
    
    await tracer.startActiveSpan('ship-order', async (childSpan) => {
      await shipOrder(orderId);
      childSpan.end();
    });
    
    span.setStatus({ code: SpanStatusCode.OK });
  } catch (err) {
    span.recordException(err);
    span.setStatus({ 
      code: SpanStatusCode.ERROR,
      message: err.message
    });
    throw err;
  } finally {
    span.end();
  }
}
```

---

## 🎯 Real-World Examples

### Example 1: Twitter-like Feed System

```markdown
## System Design

### Requirements
- Users can post tweets (280 chars)
- Users can follow other users
- Users see feed of tweets from people they follow
- Real-time updates
- Scale: 100M users, 500M tweets/day

### Architecture

1. **Write Path (Post Tweet)**
   - User posts tweet → Tweet Service
   - Store tweet in Cassandra (wide column store)
   - Publish event to Kafka
   - Fan-out service consumes event
   - Write to Redis (feed cache) for all followers

2. **Read Path (Get Feed)**
   - User requests feed
   - Check Redis cache (user's feed)
   - If miss, query Cassandra (followers' tweets)
   - Merge and sort by timestamp
   - Cache result

3. **Patterns Used**
   - Event-driven architecture
   - CQRS (separate read/write)
   - Cache-aside pattern
   - Pub/Sub pattern
   - Fan-out on write (for active users)
   - Fan-out on read (for inactive users)
```

### Example 2: E-commerce Checkout

```markdown
## Saga Pattern Implementation

### Flow
1. Order Service: Create order (PENDING)
2. Inventory Service: Reserve items
3. Payment Service: Charge customer
4. Shipping Service: Create shipment
5. Order Service: Mark order CONFIRMED

### Compensating Actions
If payment fails:
- Release inventory reservation
- Cancel order
- Send notification

### Implementation
- Choreography-based saga
- Event sourcing for audit trail
- Circuit breaker for payment service
- Retry with exponential backoff
- Bulkhead pattern for service isolation
```

---

## 📚 Pattern Selection Guide

```markdown
## When to Use What

### API Patterns
- REST: Public APIs, CRUD, standard clients
- GraphQL: Complex queries, mobile apps, flexible data
- tRPC: Full-stack TypeScript, internal APIs, type safety
- gRPC: Microservices, high performance, strong contracts

### Data Patterns
- Database per Service: Microservices, service independence
- Saga: Distributed transactions, eventual consistency OK
- CQRS: Read-heavy or write-heavy workloads
- Event Sourcing: Audit trail, time travel, complex domains

### Caching
- Cache-Aside: General purpose, most common
- Write-Through: Consistency important
- Write-Behind: High write volume, async acceptable
- Refresh-Ahead: Predictable access patterns

### Resilience
- Circuit Breaker: Protect against cascading failures
- Retry: Transient failures, network issues
- Timeout: Prevent hanging requests
- Bulkhead: Isolate failures, resource limits

### Messaging
- Pub/Sub: Real-time updates, fan-out
- Message Queue: Guaranteed delivery, background jobs
- Event Sourcing: Audit trail, event replay
```

---

## 🎬 Summary

### Key Takeaways

1. **Patterns solve recurring problems** - Don't reinvent solutions
2. **Understand trade-offs** - Every pattern has costs
3. **Start simple** - Add complexity only when needed
4. **Monitor everything** - Patterns are useless if you can't observe behavior
5. **Iterate** - Refactor as you learn

### Next Steps

- **[SCALABILITY.md](./SCALABILITY.md)** - Scaling strategies
- **[CASE_STUDIES.md](./CASE_STUDIES.md)** - Real-world system designs
- **[FUNDAMENTALS.md](./FUNDAMENTALS.md)** - Core design principles

---

**Remember: The best pattern is the one that solves your problem with the least complexity.** 🚀