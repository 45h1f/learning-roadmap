# ⚡ Cloudflare Workers - Edge Computing Platform

**Deploy serverless functions to 280+ cities worldwide in seconds**

---

## 📋 Overview

**Cloudflare Workers** is a serverless edge computing platform that runs your code in 280+ data centers around the world, providing ultra-low latency and zero cold starts.

**Key Features:**
- 🌍 **280+ locations** - Deploy globally instantly
- ⚡ **0ms cold starts** - Always ready
- 🚀 **V8 Isolates** - Lightweight, not containers
- 💰 **100k requests/day free** - Generous free tier
- 🔧 **Web Standards API** - Familiar APIs
- 📦 **KV, R2, D1** - Edge storage solutions

**Release:** 2017  
**Company:** Cloudflare  
**Runtime:** V8 JavaScript engine

---

## 🔥 Why Learn Cloudflare Workers?

### Performance Benefits
- ⚡ **Sub-10ms response times** globally
- 🚀 **No cold starts** (unlike Lambda)
- 🌐 **Closest to users** - Edge deployment
- 📈 **Scales automatically** - No configuration

### Developer Experience
- 🎯 **Simple deployment** - One command
- 💻 **Local development** - Wrangler CLI
- 📝 **TypeScript support** - Full type safety
- 🔄 **Web Standards** - Fetch API, Request/Response
- 🆓 **Generous free tier** - 100k requests/day

### Use Cases
✅ API endpoints  
✅ Authentication middleware  
✅ A/B testing  
✅ Image optimization  
✅ Edge caching  
✅ Geolocation services  
✅ Webhooks  
✅ URL shorteners  

---

## 🚀 Quick Start

### Installation
```bash
# Install Wrangler CLI
npm install -g wrangler

# Or with Bun
bun add -g wrangler

# Login to Cloudflare
wrangler login
```

### Create First Worker
```bash
# Create new worker
wrangler init my-worker

# Answer prompts:
# - TypeScript: Yes
# - Framework: None (or choose)
# - Git: Yes

cd my-worker
```

### First Worker Code
```typescript
// src/index.ts
export default {
  async fetch(request: Request): Promise<Response> {
    return new Response('Hello from the Edge!', {
      headers: {
        'content-type': 'text/plain',
      },
    });
  },
};
```

### Deploy
```bash
# Deploy to production
wrangler deploy

# Your worker is live! 🎉
# URL: https://my-worker.your-subdomain.workers.dev
```

---

## 📝 Core Concepts

### 1. Request/Response Pattern
```typescript
export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    
    // Route handling
    if (url.pathname === '/api/users') {
      return new Response(JSON.stringify({ users: [] }), {
        headers: { 'content-type': 'application/json' },
      });
    }
    
    return new Response('Not Found', { status: 404 });
  },
};
```

### 2. Environment Variables
```typescript
// wrangler.toml
[vars]
ENVIRONMENT = "production"

[secrets]
# Set with: wrangler secret put API_KEY
# API_KEY = "secret"

// In worker
export interface Env {
  ENVIRONMENT: string;
  API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const apiKey = env.API_KEY;
    const environment = env.ENVIRONMENT;
    
    return new Response(`Running in ${environment}`);
  },
};
```

### 3. Headers & CORS
```typescript
function corsHeaders(origin: string = '*') {
  return {
    'Access-Control-Allow-Origin': origin,
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };
}

export default {
  async fetch(request: Request): Promise<Response> {
    // Handle preflight
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: corsHeaders(),
      });
    }
    
    return new Response(JSON.stringify({ message: 'Success' }), {
      headers: {
        'content-type': 'application/json',
        ...corsHeaders(),
      },
    });
  },
};
```

---

## 🗄️ Storage Options

### KV (Key-Value Storage)
```typescript
export interface Env {
  MY_KV: KVNamespace;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Write
    await env.MY_KV.put('key', 'value');
    
    // Read
    const value = await env.MY_KV.get('key');
    
    // Delete
    await env.MY_KV.delete('key');
    
    // List
    const list = await env.MY_KV.list();
    
    return new Response(value);
  },
};
```

```toml
# wrangler.toml
[[kv_namespaces]]
binding = "MY_KV"
id = "your-kv-id"
```

### R2 (Object Storage)
```typescript
export interface Env {
  MY_BUCKET: R2Bucket;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Upload file
    await env.MY_BUCKET.put('file.txt', 'Hello R2');
    
    // Download file
    const object = await env.MY_BUCKET.get('file.txt');
    if (!object) {
      return new Response('Not Found', { status: 404 });
    }
    
    return new Response(object.body);
  },
};
```

### D1 (SQL Database)
```typescript
export interface Env {
  DB: D1Database;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Query
    const { results } = await env.DB.prepare(
      'SELECT * FROM users WHERE id = ?'
    ).bind(1).all();
    
    // Insert
    await env.DB.prepare(
      'INSERT INTO users (name, email) VALUES (?, ?)'
    ).bind('Alice', 'alice@example.com').run();
    
    return new Response(JSON.stringify(results), {
      headers: { 'content-type': 'application/json' },
    });
  },
};
```

---

## 🎯 Real-World Examples

### 1. JSON API
```typescript
interface Todo {
  id: number;
  title: string;
  completed: boolean;
}

const todos: Todo[] = [
  { id: 1, title: 'Learn Cloudflare Workers', completed: false },
  { id: 2, title: 'Build API', completed: true },
];

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    
    // GET /api/todos
    if (url.pathname === '/api/todos' && request.method === 'GET') {
      return Response.json(todos);
    }
    
    // GET /api/todos/:id
    if (url.pathname.startsWith('/api/todos/') && request.method === 'GET') {
      const id = parseInt(url.pathname.split('/')[3]);
      const todo = todos.find(t => t.id === id);
      
      if (!todo) {
        return Response.json({ error: 'Not found' }, { status: 404 });
      }
      
      return Response.json(todo);
    }
    
    // POST /api/todos
    if (url.pathname === '/api/todos' && request.method === 'POST') {
      const body = await request.json() as { title: string };
      const newTodo: Todo = {
        id: todos.length + 1,
        title: body.title,
        completed: false,
      };
      todos.push(newTodo);
      
      return Response.json(newTodo, { status: 201 });
    }
    
    return new Response('Not Found', { status: 404 });
  },
};
```

### 2. Authentication Middleware
```typescript
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const authHeader = request.headers.get('Authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response('Unauthorized', { status: 401 });
    }
    
    const token = authHeader.replace('Bearer ', '');
    
    // Verify token (simple example)
    if (token !== env.API_KEY) {
      return new Response('Forbidden', { status: 403 });
    }
    
    return new Response('Authenticated!');
  },
};
```

### 3. Proxy with Caching
```typescript
export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    
    // Create cache key
    const cacheKey = new Request(url.toString(), request);
    const cache = caches.default;
    
    // Check cache
    let response = await cache.match(cacheKey);
    
    if (!response) {
      // Fetch from origin
      response = await fetch(`https://api.example.com${url.pathname}`);
      
      // Clone and cache
      response = new Response(response.body, response);
      response.headers.set('Cache-Control', 's-maxage=3600');
      await cache.put(cacheKey, response.clone());
    }
    
    return response;
  },
};
```

### 4. Geolocation-Based Response
```typescript
export default {
  async fetch(request: Request): Promise<Response> {
    const country = request.cf?.country || 'Unknown';
    const city = request.cf?.city || 'Unknown';
    const timezone = request.cf?.timezone || 'Unknown';
    
    return Response.json({
      country,
      city,
      timezone,
      message: `Hello from ${city}, ${country}!`,
    });
  },
};
```

### 5. Image Resize
```typescript
export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    const width = parseInt(url.searchParams.get('width') || '800');
    
    // Fetch original image
    const imageUrl = url.searchParams.get('url');
    if (!imageUrl) {
      return new Response('Missing url parameter', { status: 400 });
    }
    
    const imageResponse = await fetch(imageUrl);
    
    // Resize using Cloudflare Image Resizing
    return fetch(imageUrl, {
      cf: {
        image: {
          width,
          quality: 85,
          format: 'auto',
        },
      },
    });
  },
};
```

---

## ⚙️ Configuration (wrangler.toml)

```toml
name = "my-worker"
main = "src/index.ts"
compatibility_date = "2024-01-01"

# Environment variables
[vars]
ENVIRONMENT = "production"
API_URL = "https://api.example.com"

# KV Namespace
[[kv_namespaces]]
binding = "MY_KV"
id = "your-kv-namespace-id"

# R2 Bucket
[[r2_buckets]]
binding = "MY_BUCKET"
bucket_name = "my-bucket"

# D1 Database
[[d1_databases]]
binding = "DB"
database_name = "my-database"
database_id = "your-database-id"

# Routes
[routes]
pattern = "example.com/*"
zone_name = "example.com"

# Secrets (set with wrangler secret put)
# API_KEY
# DATABASE_PASSWORD
```

---

## 🧪 Local Development

```bash
# Start local dev server
wrangler dev

# With remote resources
wrangler dev --remote

# Tail logs
wrangler tail

# Test locally
curl http://localhost:8787
```

---

## 🚀 Deployment

```bash
# Deploy to production
wrangler deploy

# Deploy to staging
wrangler deploy --env staging

# Rollback
wrangler rollback
```

### Multiple Environments
```toml
# wrangler.toml
[env.staging]
name = "my-worker-staging"
vars = { ENVIRONMENT = "staging" }

[env.production]
name = "my-worker-production"
vars = { ENVIRONMENT = "production" }
```

```bash
# Deploy to staging
wrangler deploy --env staging

# Deploy to production
wrangler deploy --env production
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Install Wrangler
- [ ] Create first worker
- [ ] Deploy to edge
- [ ] Learn Request/Response
- [ ] Environment variables

### Week 2: Storage
- [ ] KV for caching
- [ ] R2 for files
- [ ] D1 for SQL
- [ ] Build CRUD API

### Week 3: Advanced
- [ ] Authentication
- [ ] Caching strategies
- [ ] Image optimization
- [ ] Geolocation features

### Week 4: Production
- [ ] Multiple environments
- [ ] Monitoring & logs
- [ ] Custom domains
- [ ] CI/CD integration

**Time to Proficiency:** 2-3 weeks  
**Difficulty:** ⭐⭐⭐ (Intermediate)

---

## 💡 Pro Tips

1. **Use TypeScript** - Full type safety
2. **Cache everything** - Edge caching is powerful
3. **KV for reads** - Fast global reads
4. **R2 for large files** - Cost-effective storage
5. **Geolocation** - Free with every request
6. **Wrangler dev** - Test locally first
7. **Tail logs** - Debug production issues
8. **Web Standards** - Use Fetch API

---

## 📊 Pricing

### Free Tier
- ✅ **100,000 requests/day**
- ✅ **10ms CPU time/request**
- ✅ **1 GB KV reads/day**
- ✅ **1,000 KV writes/day**

### Paid ($5/month)
- ✅ **10 million requests**
- ✅ **50ms CPU time/request**
- ✅ **Unlimited KV**
- ✅ **R2 storage**
- ✅ **D1 database**

**Note:** Extremely generous free tier for learning!

---

## 🆚 Cloudflare Workers vs Others

### vs AWS Lambda
| Feature | Workers | Lambda |
|---------|---------|--------|
| Cold Start | 0ms ⚡ | 100ms+ 🐌 |
| Locations | 280+ 🌍 | ~30 regions |
| Pricing | $5/10M 💰 | ~$20/10M |
| Runtime | V8 Isolates | Containers |

### vs Vercel Edge
| Feature | Workers | Vercel Edge |
|---------|---------|-------------|
| Flexibility | ✅ Full control | 🟡 Limited |
| Pricing | ✅ Generous | 🟡 Good |
| Storage | ✅ KV, R2, D1 | 🟡 KV only |
| Vendor Lock | ✅ Less | ❌ More |

---

## 📚 Resources

### Official
- **Docs**: https://developers.cloudflare.com/workers/
- **Examples**: https://workers.cloudflare.com/examples
- **Discord**: https://discord.gg/cloudflaredev
- **Blog**: https://blog.cloudflare.com/

### Tutorials
- **Cloudflare Workers Guide** - Fireship (YouTube)
- **Edge Computing** - Theo t3.gg
- **Workers Tutorial** - Official docs

### Frameworks
- **Hono**: Fast web framework for Workers
- **itty-router**: Tiny router
- **Toucan**: Sentry for Workers

---

## ✅ Checklist

### Setup
- [ ] Install Wrangler
- [ ] Login to Cloudflare
- [ ] Create first worker
- [ ] Deploy successfully
- [ ] Test in browser

### Learn Core
- [ ] Request/Response pattern
- [ ] Environment variables
- [ ] Headers & CORS
- [ ] Error handling
- [ ] TypeScript types

### Storage
- [ ] KV namespace
- [ ] R2 bucket
- [ ] D1 database
- [ ] Caching strategies

### Production
- [ ] Multiple environments
- [ ] Custom domain
- [ ] Monitoring
- [ ] CI/CD pipeline

---

## 💼 Career Impact

### Salary Boost
- **Edge computing skills**: +$10-15K
- **Cloudflare expertise**: +$5-10K
- **Serverless architecture**: +$10-15K

### Job Opportunities
- Edge Computing Engineer
- Serverless Developer
- Platform Engineer
- DevOps Engineer

### Companies Using
- Cloudflare (obviously)
- Discord
- Shopify
- Many startups

---

## 🎯 Projects to Build

### Beginner
1. **Hello World API** - Basic routing
2. **URL Shortener** - KV storage
3. **Proxy Server** - Caching

### Intermediate
4. **Authentication Service** - JWT validation
5. **Image Optimizer** - Resize on-the-fly
6. **Geolocation API** - Location-based responses

### Advanced
7. **Full API Backend** - CRUD with D1
8. **CDN** - Smart caching & routing
9. **A/B Testing Platform** - Edge logic

---

## 🚨 Limitations

### Current Constraints
- ⏱️ **CPU time**: 10ms (free), 50ms (paid)
- 💾 **Memory**: 128 MB
- 📦 **Size**: 1 MB after compression
- 🔄 **Subrequests**: 50 per request

### Not Suitable For
- ❌ Long-running processes (>50ms)
- ❌ Heavy computation
- ❌ Large file processing
- ❌ WebSockets (use Durable Objects)

**For those, consider:** Durable Objects or traditional servers

---

## 🔮 Future Features

- Cron Triggers (available)
- Durable Objects (available)
- Queues (available)
- Analytics Engine (available)
- AI Inference (beta)

---

## 🎉 Why Developers Love Workers

> "Deploy globally in seconds, no configuration needed"

- **Fast**: 0ms cold starts
- **Global**: 280+ locations
- **Simple**: One command deploy
- **Cheap**: Generous free tier
- **Powerful**: Full V8 engine

---

**Last Updated**: January 2025  
**Status**: ✅ Complete Guide  
**Priority**: 🟡 High (Edge computing is the future)

*Deploy to the edge in seconds with Cloudflare Workers! ⚡*