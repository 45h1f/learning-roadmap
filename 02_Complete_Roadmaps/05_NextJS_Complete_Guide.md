# 🚀 Next.js Complete Guide - Modern Full-Stack Framework

> **Master Next.js 14+ with App Router, Server Components, and Edge Computing**

---

## 📋 Table of Contents

1. [Introduction & Modern Next.js](#introduction--modern-nextjs)
2. [Next.js Fundamentals](#nextjs-fundamentals)
3. [App Router Deep Dive](#app-router-deep-dive)
4. [Server Components & RSC](#server-components--rsc)
5. [Client Components](#client-components)
6. [Routing & Navigation](#routing--navigation)
7. [Data Fetching](#data-fetching)
8. [Caching & Revalidation](#caching--revalidation)
9. [Server Actions](#server-actions)
10. [Metadata & SEO](#metadata--seo)
11. [Styling Solutions](#styling-solutions)
12. [API Routes](#api-routes)
13. [Middleware](#middleware)
14. [Authentication](#authentication)
15. [Database Integration](#database-integration)
16. [Image & Font Optimization](#image--font-optimization)
17. [Performance Optimization](#performance-optimization)
18. [Deployment](#deployment)
19. [Testing Next.js Apps](#testing-nextjs-apps)
20. [Real-World Projects](#real-world-projects)

---

## Introduction & Modern Next.js

### What is Next.js?

Next.js is a **React framework** that provides:
- **Server-Side Rendering (SSR)** - Dynamic HTML generation
- **Static Site Generation (SSG)** - Pre-built pages at build time
- **Incremental Static Regeneration (ISR)** - Update static content
- **Server Components** - React components that run on the server
- **Built-in Routing** - File-system based routing
- **API Routes** - Backend endpoints in the same project
- **Edge Runtime** - Deploy to the edge globally
- **Optimization** - Automatic code splitting, image optimization

### Why Next.js in 2025?

```typescript
// ❌ Traditional React (Client-Side Only)
// - All JavaScript sent to client
// - SEO challenges
// - Slower initial page load
// - Complex state management

// ✅ Next.js (Hybrid Rendering)
// - Server Components = Zero JavaScript to client
// - Perfect SEO
// - Fast initial loads
// - Simplified data fetching
```

### Next.js 14+ Major Features

- **App Router** - New routing system with layouts and templates
- **React Server Components** - Run React on the server
- **Server Actions** - Server-side mutations without API routes
- **Streaming** - Progressive rendering
- **Turbopack** - Faster dev server (beta)
- **Partial Prerendering** - Hybrid static/dynamic rendering
- **Edge Runtime** - Run close to users globally

---

## Next.js Fundamentals

### Installation & Setup

```bash
# Using Bun (recommended)
bunx create-next-app@latest my-app

# Using npm
npx create-next-app@latest my-app

# Using pnpm
pnpm create next-app my-app

# Configuration prompts:
# ✅ TypeScript - YES
# ✅ ESLint - YES
# ✅ Tailwind CSS - YES
# ✅ src/ directory - YES (optional)
# ✅ App Router - YES
# ✅ Import alias - YES (@/*)
```

### Project Structure (App Router)

```
my-app/
├── app/                    # App Router directory
│   ├── layout.tsx         # Root layout (required)
│   ├── page.tsx           # Home page (/)
│   ├── loading.tsx        # Loading UI
│   ├── error.tsx          # Error UI
│   ├── not-found.tsx      # 404 page
│   ├── globals.css        # Global styles
│   ├── about/             # /about route
│   │   └── page.tsx
│   ├── blog/              # /blog routes
│   │   ├── page.tsx       # /blog
│   │   └── [slug]/        # /blog/:slug
│   │       └── page.tsx
│   └── api/               # API routes
│       └── users/
│           └── route.ts
├── components/            # Reusable components
├── lib/                   # Utility functions
├── public/                # Static assets
├── next.config.js         # Next.js configuration
├── package.json
└── tsconfig.json
```

### Configuration (next.config.js)

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable React strict mode
  reactStrictMode: true,

  // Image optimization domains
  images: {
    domains: ['example.com', 'cdn.example.com'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**.amazonaws.com',
      },
    ],
  },

  // Environment variables (public)
  env: {
    CUSTOM_KEY: 'my-value',
  },

  // Redirects
  async redirects() {
    return [
      {
        source: '/old-blog/:slug',
        destination: '/blog/:slug',
        permanent: true,
      },
    ];
  },

  // Rewrites (proxying)
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'https://api.example.com/:path*',
      },
    ];
  },

  // Headers
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
        ],
      },
    ];
  },

  // Experimental features
  experimental: {
    serverActions: true,
    typedRoutes: true,
  },
};

module.exports = nextConfig;
```

---

## App Router Deep Dive

### Root Layout (Required)

```typescript
// app/layout.tsx
import './globals.css';
import { Inter } from 'next/font/google';

const inter = Inter({ subsets: ['latin'] });

export const metadata = {
  title: 'My App',
  description: 'Built with Next.js',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <nav>
          {/* Navigation here */}
        </nav>
        <main>{children}</main>
        <footer>
          {/* Footer here */}
        </footer>
      </body>
    </html>
  );
}
```

### Pages

```typescript
// app/page.tsx - Home page (/)
export default function HomePage() {
  return (
    <div>
      <h1>Welcome Home</h1>
    </div>
  );
}

// app/about/page.tsx - About page (/about)
export default function AboutPage() {
  return <h1>About Us</h1>;
}

// app/blog/[slug]/page.tsx - Dynamic route (/blog/:slug)
export default function BlogPost({
  params,
}: {
  params: { slug: string };
}) {
  return <h1>Post: {params.slug}</h1>;
}
```

### Nested Layouts

```typescript
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="dashboard">
      <aside>
        {/* Sidebar navigation */}
        <nav>Dashboard Nav</nav>
      </aside>
      <section>{children}</section>
    </div>
  );
}

// app/dashboard/page.tsx
export default function DashboardPage() {
  return <h1>Dashboard Home</h1>;
}

// Layout wraps all /dashboard/* routes automatically
```

### Loading States

```typescript
// app/blog/loading.tsx
export default function Loading() {
  return (
    <div className="animate-pulse">
      <div className="h-8 bg-gray-200 rounded w-3/4 mb-4"></div>
      <div className="h-4 bg-gray-200 rounded w-full mb-2"></div>
      <div className="h-4 bg-gray-200 rounded w-5/6"></div>
    </div>
  );
}

// Automatically shown while page.tsx loads
```

### Error Handling

```typescript
// app/error.tsx
'use client'; // Error components must be Client Components

import { useEffect } from 'react';

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    // Log to error reporting service
    console.error(error);
  }, [error]);

  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  );
}
```

### Not Found (404)

```typescript
// app/not-found.tsx
import Link from 'next/link';

export default function NotFound() {
  return (
    <div>
      <h2>Not Found</h2>
      <p>Could not find requested resource</p>
      <Link href="/">Return Home</Link>
    </div>
  );
}

// Or trigger programmatically:
import { notFound } from 'next/navigation';

export default async function UserPage({ params }: { params: { id: string } }) {
  const user = await getUser(params.id);
  
  if (!user) {
    notFound(); // Shows not-found.tsx
  }
  
  return <div>{user.name}</div>;
}
```

### Templates (Re-mount on Navigation)

```typescript
// app/template.tsx
// Unlike layouts, templates re-mount on navigation
export default function Template({ children }: { children: React.ReactNode }) {
  return <div className="fade-in">{children}</div>;
}
```

---

## Server Components & RSC

### What are Server Components?

Server Components run **only on the server**. They:
- **Never send JavaScript to the client**
- **Can access backend resources directly** (databases, APIs)
- **Improve performance** - Less JavaScript = Faster loads
- **Are the default** in App Router

### Server Component Example

```typescript
// app/posts/page.tsx (Server Component by default)
import { db } from '@/lib/db';

export default async function PostsPage() {
  // Direct database access - NO API route needed!
  const posts = await db.post.findMany();

  return (
    <div>
      <h1>Blog Posts</h1>
      {posts.map((post) => (
        <article key={post.id}>
          <h2>{post.title}</h2>
          <p>{post.excerpt}</p>
        </article>
      ))}
    </div>
  );
}

// ✅ Benefits:
// - No useState, useEffect, or React Query needed
// - Direct database access (secure, server-only)
// - Zero JavaScript sent to client for this component
// - Automatic data fetching
```

### Server Component Rules

```typescript
// ✅ CAN DO in Server Components:
// - Access databases directly
// - Use environment variables (secret keys)
// - Call server-side APIs
// - Read files from filesystem
// - Use async/await for data fetching
// - Import server-only packages

// ❌ CANNOT DO in Server Components:
// - Use useState, useEffect, useContext
// - Use browser APIs (window, document, localStorage)
// - Add event listeners (onClick, onChange)
// - Use React hooks
```

### Async Server Components

```typescript
// Server Components can be async!
export default async function ProductPage({ params }: { params: { id: string } }) {
  // Multiple parallel fetches
  const [product, reviews, recommendations] = await Promise.all([
    fetchProduct(params.id),
    fetchReviews(params.id),
    fetchRecommendations(params.id),
  ]);

  return (
    <div>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
      
      <ReviewsList reviews={reviews} />
      <Recommendations items={recommendations} />
    </div>
  );
}
```

### Server-Only Code

```typescript
// lib/server-utils.ts
import 'server-only'; // Ensures this only runs on server

import { db } from './db';

export async function getSecretData() {
  // This code will never be in client bundle
  const data = await db.secrets.findMany();
  return data;
}

// If accidentally imported in a Client Component, build will fail
```

---

## Client Components

### When to Use Client Components

Use `'use client'` when you need:
- **Interactivity** - onClick, onChange, onSubmit
- **React Hooks** - useState, useEffect, useContext
- **Browser APIs** - window, localStorage, geolocation
- **Event listeners** - keyboard, mouse events
- **Custom hooks** - Your own React hooks
- **React Context** - Context providers and consumers

### Creating Client Components

```typescript
// components/Counter.tsx
'use client'; // This directive marks it as a Client Component

import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}
```

### Composing Server and Client Components

```typescript
// app/dashboard/page.tsx (Server Component)
import { ClientButton } from '@/components/ClientButton';
import { db } from '@/lib/db';

export default async function DashboardPage() {
  // Server-side data fetching
  const data = await db.dashboard.findUnique({ where: { id: 1 } });

  return (
    <div>
      <h1>Dashboard</h1>
      
      {/* Server-rendered data */}
      <p>Total Users: {data.userCount}</p>
      
      {/* Client component for interactivity */}
      <ClientButton />
    </div>
  );
}
```

### Passing Props from Server to Client

```typescript
// ✅ Good: Serializable props
<ClientComponent 
  title="Hello"
  count={42}
  items={['a', 'b', 'c']}
  user={{ name: 'John', email: 'john@example.com' }}
/>

// ❌ Bad: Non-serializable props
<ClientComponent 
  callback={() => console.log('test')} // Functions can't be serialized
  date={new Date()} // Use ISO string instead
/>

// ✅ Fix: Convert to serializable format
<ClientComponent 
  onAction="someAction" // Use string identifier instead
  dateString={new Date().toISOString()}
/>
```

### Client Component Patterns

```typescript
// components/SearchForm.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export function SearchForm() {
  const [query, setQuery] = useState('');
  const router = useRouter();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    router.push(`/search?q=${encodeURIComponent(query)}`);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search..."
      />
      <button type="submit">Search</button>
    </form>
  );
}
```

---

## Routing & Navigation

### File-Based Routing

```
app/
├── page.tsx                    → /
├── about/page.tsx              → /about
├── blog/
│   ├── page.tsx                → /blog
│   └── [slug]/page.tsx         → /blog/:slug
├── shop/
│   └── [...categories]/        → /shop/electronics/phones
│       page.tsx                   /shop/a/b/c
├── dashboard/
│   ├── (marketing)/            → Route groups (no URL segment)
│   │   ├── about/page.tsx      → /dashboard/about
│   │   └── contact/page.tsx    → /dashboard/contact
│   └── (admin)/
│       └── users/page.tsx      → /dashboard/users
└── [lang]/                     → /en, /fr, /es
    └── page.tsx
```

### Dynamic Routes

```typescript
// app/blog/[slug]/page.tsx
export default function BlogPost({ params }: { params: { slug: string } }) {
  return <h1>Post: {params.slug}</h1>;
}

// app/shop/[category]/[product]/page.tsx
export default function Product({
  params,
}: {
  params: { category: string; product: string };
}) {
  return (
    <div>
      <p>Category: {params.category}</p>
      <p>Product: {params.product}</p>
    </div>
  );
}
```

### Catch-All Routes

```typescript
// app/docs/[...slug]/page.tsx
// Matches: /docs/a, /docs/a/b, /docs/a/b/c
export default function DocsPage({ params }: { params: { slug: string[] } }) {
  return <p>Path: {params.slug.join('/')}</p>;
}

// app/shop/[[...categories]]/page.tsx
// Optional catch-all: Matches /shop AND /shop/a, /shop/a/b
export default function ShopPage({
  params,
}: {
  params: { categories?: string[] };
}) {
  const path = params.categories?.join('/') || 'all';
  return <p>Shopping: {path}</p>;
}
```

### Route Groups

```typescript
// Route groups organize files without affecting URLs
app/
├── (marketing)/          // Group name in parentheses
│   ├── layout.tsx        // Shared layout for marketing pages
│   ├── about/page.tsx    → /about (not /marketing/about)
│   └── contact/page.tsx  → /contact
└── (shop)/
    ├── layout.tsx        // Different layout for shop pages
    └── products/page.tsx → /products
```

### Parallel Routes

```typescript
// app/dashboard/@user/page.tsx
// app/dashboard/@stats/page.tsx
// app/dashboard/layout.tsx

export default function DashboardLayout({
  children,
  user,
  stats,
}: {
  children: React.ReactNode;
  user: React.ReactNode;
  stats: React.ReactNode;
}) {
  return (
    <div>
      <div>{user}</div>
      <div>{stats}</div>
      <div>{children}</div>
    </div>
  );
}

// Renders multiple pages in the same layout simultaneously
```

### Intercepting Routes

```typescript
// app/feed/page.tsx - Photo feed
// app/feed/[id]/page.tsx - Full photo page
// app/feed/(.)[id]/page.tsx - Intercept when navigating from feed

// Shows modal when clicking from feed, but full page on direct navigation
```

### Link Component

```typescript
import Link from 'next/link';

export function Navigation() {
  return (
    <nav>
      {/* Basic link */}
      <Link href="/about">About</Link>

      {/* Dynamic link */}
      <Link href={`/blog/${slug}`}>Read More</Link>

      {/* With query params */}
      <Link href={{ pathname: '/search', query: { q: 'nextjs' } }}>
        Search Next.js
      </Link>

      {/* Replace history instead of push */}
      <Link href="/login" replace>
        Login
      </Link>

      {/* Prefetch disabled (default is true) */}
      <Link href="/dashboard" prefetch={false}>
        Dashboard
      </Link>

      {/* Scroll to top disabled */}
      <Link href="/blog" scroll={false}>
        Blog
      </Link>
    </nav>
  );
}
```

### Programmatic Navigation

```typescript
'use client';

import { useRouter, usePathname, useSearchParams } from 'next/navigation';

export function NavigationExample() {
  const router = useRouter();
  const pathname = usePathname(); // Current path
  const searchParams = useSearchParams(); // Query params

  const handleNavigate = () => {
    // Push new route
    router.push('/dashboard');

    // Replace current route
    router.replace('/dashboard');

    // Go back
    router.back();

    // Go forward
    router.forward();

    // Refresh current route
    router.refresh();
  };

  // Get query param
  const query = searchParams.get('q');

  // Build new URL with query params
  const newParams = new URLSearchParams(searchParams.toString());
  newParams.set('page', '2');
  router.push(`${pathname}?${newParams.toString()}`);

  return <button onClick={handleNavigate}>Navigate</button>;
}
```

---

## Data Fetching

### Fetch API (Extended)

Next.js extends the native `fetch` API with caching and revalidation:

```typescript
// app/posts/page.tsx

// Default: Cache forever (until redeployed)
export default async function Posts() {
  const res = await fetch('https://api.example.com/posts');
  const posts = await res.json();
  return <PostsList posts={posts} />;
}

// Revalidate every 60 seconds
export default async function Posts() {
  const res = await fetch('https://api.example.com/posts', {
    next: { revalidate: 60 },
  });
  const posts = await res.json();
  return <PostsList posts={posts} />;
}

// No caching (always fresh)
export default async function Posts() {
  const res = await fetch('https://api.example.com/posts', {
    cache: 'no-store',
  });
  const posts = await res.json();
  return <PostsList posts={posts} />;
}

// With tags for on-demand revalidation
export default async function Posts() {
  const res = await fetch('https://api.example.com/posts', {
    next: { tags: ['posts'] },
  });
  const posts = await res.json();
  return <PostsList posts={posts} />;
}
```

### Direct Database Access

```typescript
// app/users/page.tsx
import { db } from '@/lib/db';

export default async function UsersPage() {
  // Direct Prisma query (or any ORM)
  const users = await db.user.findMany({
    where: { active: true },
    orderBy: { createdAt: 'desc' },
    take: 10,
  });

  return (
    <div>
      {users.map((user) => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  );
}
```

### Parallel Data Fetching

```typescript
export default async function ProductPage({ params }: { params: { id: string } }) {
  // Fetch in parallel
  const [product, reviews, related] = await Promise.all([
    fetchProduct(params.id),
    fetchReviews(params.id),
    fetchRelatedProducts(params.id),
  ]);

  return (
    <div>
      <ProductDetails product={product} />
      <Reviews reviews={reviews} />
      <RelatedProducts products={related} />
    </div>
  );
}
```

### Sequential Data Fetching

```typescript
export default async function Page() {
  // Wait for user first
  const user = await fetchUser();
  
  // Then fetch user's posts
  const posts = await fetchUserPosts(user.id);
  
  return <UserProfile user={user} posts={posts} />;
}
```

### Request Deduplication

```typescript
// Next.js automatically deduplicates identical requests in the same render pass

// lib/data.ts
export async function getPost(id: string) {
  const res = await fetch(`https://api.example.com/posts/${id}`);
  return res.json();
}

// app/post/[id]/page.tsx
import { getPost } from '@/lib/data';

export default async function PostPage({ params }: { params: { id: string } }) {
  const post = await getPost(params.id); // First call
  return <Post data={post} />;
}

// components/PostComments.tsx
import { getPost } from '@/lib/data';

export async function PostComments({ id }: { id: string }) {
  const post = await getPost(id); // Deduplicated! Only one fetch happens
  return <Comments comments={post.comments} />;
}
```

### Streaming with Suspense

```typescript
// app/dashboard/page.tsx
import { Suspense } from 'react';

export default function DashboardPage() {
  return (
    <div>
      <h1>Dashboard</h1>
      
      {/* Streams immediately */}
      <UserInfo />
      
      {/* Shows fallback while loading */}
      <Suspense fallback={<LoadingSkeleton />}>
        <SlowData />
      </Suspense>
      
      {/* Multiple independent streams */}
      <Suspense fallback={<p>Loading stats...</p>}>
        <Stats />
      </Suspense>
      
      <Suspense fallback={<p>Loading chart...</p>}>
        <Chart />
      </Suspense>
    </div>
  );
}

async function SlowData() {
  const data = await fetchSlowData(); // Takes 3 seconds
  return <div>{data}</div>;
}

// Page starts rendering immediately, streams in SlowData when ready
```

---

## Caching & Revalidation

### Caching Layers in Next.js

1. **Request Memoization** - Deduplicates identical requests in one render
2. **Data Cache** - Stores fetch results across requests
3. **Full Route Cache** - Pre-rendered HTML and RSC payload
4. **Router Cache** - Client-side cache in user's browser

### Time-Based Revalidation

```typescript
// Revalidate every 60 seconds
export default async function Page() {
  const data = await fetch('https://api.example.com/data', {
    next: { revalidate: 60 },
  });
  return <div>{data}</div>;
}

// Page-level revalidation
export const revalidate = 3600; // 1 hour

export default async function Page() {
  const data = await fetch('https://api.example.com/data');
  return <div>{data}</div>;
}
```

### On-Demand Revalidation

```typescript
// app/api/revalidate/route.ts
import { revalidatePath, revalidateTag } from 'next/cache';
import { NextRequest } from 'next/server';

export async function POST(request: NextRequest) {
  const secret = request.nextUrl.searchParams.get('secret');
  
  if (secret !== process.env.REVALIDATE_SECRET) {
    return Response.json({ message: 'Invalid secret' }, { status: 401 });
  }

  // Revalidate specific path
  revalidatePath('/blog');
  
  // Revalidate all blog posts
  revalidatePath('/blog/[slug]', 'page');
  
  // Revalidate by cache tag
  revalidateTag('posts');

  return Response.json({ revalidated: true, now: Date.now() });
}

// Usage in fetch:
const res = await fetch('https://api.example.com/posts', {
  next: { tags: ['posts'] },
});

// Call webhook to revalidate:
// POST /api/revalidate?secret=YOUR_SECRET
```

### Opting Out of Caching

```typescript
// Dynamic rendering (no cache)
export const dynamic = 'force-dynamic';

export default async function Page() {
  const data = await fetch('https://api.example.com/data');
  return <div>{data}</div>;
}

// Or per-request:
const data = await fetch('https://api.example.com/data', {
  cache: 'no-store',
});

// Dynamic functions automatically opt out of caching:
import { cookies, headers } from 'next/headers';

export default async function Page() {
  const cookieStore = cookies();
  const headersList = headers();
  // Page is now dynamic
}
```

### Segment Config Options

```typescript
// app/page.tsx

// Force static (cached) or dynamic (no cache)
export const dynamic = 'auto' | 'force-dynamic' | 'error' | 'force-static';

// Revalidation interval
export const revalidate = false | 0 | number; // seconds

// Control which dynamic APIs make the route dynamic
export const dynamicParams = true | false;

// Choose runtime
export const runtime = 'nodejs' | 'edge';

// Control fetch cache behavior
export const fetchCache = 'auto' | 'default-cache' | 'only-cache' | 'force-cache' | 'force-no-store' | 'default-no-store' | 'only-no-store';
```

---

## Server Actions

### What are Server Actions?

Server Actions are **asynchronous functions that run on the server** and can be called directly from Client Components. They replace the need for API routes for mutations.

### Basic Server Action

```typescript
// app/actions.ts
'use server';

import { db } from '@/lib/db';
import { revalidatePath } from 'next/cache';

export async function createPost(formData: FormData) {
  const title = formData.get('title') as string;
  const content = formData.get('content') as string;

  await db.post.create({
    data: { title, content },
  });

  revalidatePath('/blog');
}
```

### Using in Forms

```typescript
// app/blog/new/page.tsx
import { createPost } from '@/app/actions';

export default function NewPostPage() {
  return (
    <form action={createPost}>
      <input name="title" type="text" placeholder="Title" required />
      <textarea name="content" placeholder="Content" required />
      <button type="submit">Create Post</button>
    </form>
  );
}

// No JavaScript needed! Works without JS enabled
```

### Using in Client Components

```typescript
// components/CreatePostForm.tsx
'use client';

import { createPost } from '@/app/actions';
import { useFormStatus } from 'react-dom';

function SubmitButton() {
  const { pending } = useFormStatus();
  
  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Creating...' : 'Create Post'}
    </button>
  );
}

export function CreatePostForm() {
  return (
    <form action={createPost}>
      <input name="title" type="text" placeholder="Title" required />
      <textarea name="content" placeholder="Content" required />
      <SubmitButton />
    </form>
  );
}
```

### Server Actions with Validation

```typescript
// app/actions.ts
'use server';

import { z } from 'zod';
import { db } from '@/lib/db';
import { revalidatePath } from 'next/cache';

const CreatePostSchema = z.object({
  title: z.string().min(1).max(100),
  content: z.string().min(1).max(5000),
});

export async function createPost(formData: FormData) {
  // Validate
  const validatedFields = CreatePostSchema.safeParse({
    title: formData.get('title'),
    content: formData.get('content'),
  });

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
      message: 'Invalid fields',
    };
  }

  const { title, content } = validatedFields.data;

  try {
    await db.post.create({
      data: { title, content },
    });
  } catch (error) {
    return { message: 'Database Error: Failed to create post' };
  }

  revalidatePath('/blog');
  redirect('/blog');
}
```

### Using with useFormState

```typescript
// app/actions.ts
'use server';

import { z } from 'zod';

type State = {
  errors?: {
    title?: string[];
    content?: string[];
  };
  message?: string | null;
};

const CreatePostSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  content: z.string().min(10, 'Content must be at least 10 characters'),
});

export async function createPost(prevState: State, formData: FormData): Promise<State> {
  const validatedFields = CreatePostSchema.safeParse({
    title: formData.get('title'),
    content: formData.get('content'),
  });

  if (!validatedFields.success) {
    return {
      errors: validatedFields.error.flatten().fieldErrors,
      message: 'Invalid fields. Failed to create post.',
    };
  }

  // Create post...
  
  return { message: 'Post created successfully!' };
}

// components/CreatePostForm.tsx
'use client';

import { useFormState } from 'react-dom';
import { createPost } from '@/app/actions';

export function CreatePostForm() {
  const initialState = { message: null, errors: {} };
  const [state, dispatch] = useFormState(createPost, initialState);

  return (
    <form action={dispatch}>
      <div>
        <label htmlFor="title">Title</label>
        <input id="title" name="title" type="text" />
        {state.errors?.title && <p className="error">{state.errors.title[0]}</p>}
      </div>

      <div>
        <label htmlFor="content">Content</label>
        <textarea id="content" name="content" />
        {state.errors?.content && <p className="error">{state.errors.content[0]}</p>}
      </div>

      {state.message && <p className="success">{state.message}</p>}
      
      <button type="submit">Create Post</button>
    </form>
  );
}
```

### Programmatic Server Actions

```typescript
// Call Server Actions from event handlers
'use client';

import { updateUser } from '@/app/actions';
import { useState } from 'react';

export function UserProfile({ userId }: { userId: string }) {
  const [name, setName] = useState('');

  const handleUpdate = async () => {
    await updateUser(userId, name);
    alert('Profile updated!');
  };

  return (
    <div>
      <input value={name} onChange={(e) => setName(e.target.value)} />
      <button onClick={handleUpdate}>Update</button>
    </div>
  );
}
```

---

## Metadata & SEO

### Static Metadata

```typescript
// app/page.tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'My App',
  description: 'Welcome to my app',
  keywords: ['next.js', 'react', 'typescript'],
  authors: [{ name: 'Your Name' }],
  openGraph: {
    title: 'My App',
    description: 'Welcome to my app',
    url: 'https://example.com',
    siteName: 'My App',
    images: [
      {
        url: 'https://example.com/og.png',
        width: 1200,
        height: 630,
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'My App',
    description: 'Welcome to my app',
    images: ['https://example.com/og.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
};

export default function Page() {
  return <h1>Home</h1>;
}
```

### Dynamic Metadata

```typescript
// app/blog/[slug]/page.tsx
import { Metadata } from 'next';

type Props = {
  params: { slug: string };
  searchParams: { [key: string]: string | string[] | undefined };
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const post = await fetchPost(params.slug);

  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      description: post.excerpt,
      images: [post.coverImage],
    },
  };
}

export default async function BlogPost({ params }: Props) {
  const post = await fetchPost(params.slug);
  return <article>{post.content}</article>;
}
```

### Metadata Files (Special Files)

```typescript
// app/favicon.ico - Favicon
// app/icon.png - App icon
// app/apple-icon.png - Apple touch icon

// app/opengraph-image.tsx - Generate OG image
import { ImageResponse } from 'next/og';

export const runtime = 'edge';
export const alt = 'My App';
export const size = { width: 1200, height: 630 };
export const contentType = 'image/png';

export default async function Image() {
  return new ImageResponse(
    (
      <div
        style={{
          fontSize: 128,
          background: 'white',
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        Hello world!
      </div>
    ),
    {
      ...size,
    }
  );
}

// app/robots.ts - Robots.txt
export default function robots() {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: '/private/',
    },
    sitemap: 'https://example.com/sitemap.xml',
  };
}

// app/sitemap.ts - Sitemap
export default function sitemap() {
  return [
    {
      url: 'https://example.com',
      lastModified: new Date(),
      changeFrequency: 'yearly',
      priority: 1,
    },
    {
      url: 'https://example.com/about',
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 0.8,
    },
  ];
}
```

### JSON-LD Structured Data

```typescript
// app/blog/[slug]/page.tsx
export default async function BlogPost({ params }: { params: { slug: string } }) {
  const post = await fetchPost(params.slug);

  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: post.title,
    image: post.coverImage,
    author: {
      '@type': 'Person',
      name: post.author.name,
    },
    datePublished: post.publishedAt,
    dateModified: post.updatedAt,
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(jsonLd) }}
      />
      <article>
        <h1>{post.title}</h1>
        <div>{post.content}</div>
      </article>
    </>
  );
}
```

---

## Styling Solutions

### Tailwind CSS (Recommended)

```typescript
// Already configured with create-next-app

// app/page.tsx
export default function Page() {
  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 className="text-3xl font-bold text-gray-900">
            Dashboard
          </h1>
        </div>
      </header>
      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <div className="px-4 py-6 sm:px-0">
          <div className="border-4 border-dashed border-gray-200 rounded-lg h-96" />
        </div>
      </main>
    </div>
  );
}
```

### CSS Modules

```css
/* app/styles.module.css */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.title {
  font-size: 2rem;
  color: #333;
  margin-bottom: 1rem;
}
```

```typescript
// app/page.tsx
import styles from './styles.module.css';

export default function Page() {
  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Hello World</h1>
    </div>
  );
}
```

### Global Styles

```css
/* app/globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --foreground-rgb: 0, 0, 0;
  --background-rgb: 255, 255, 255;
}

@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-rgb: 0, 0, 0;
  }
}

body {
  color: rgb(var(--foreground-rgb));
  background: rgb(var(--background-rgb));
}

@layer components {
  .btn-primary {
    @apply bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded;
  }
}
```

### CSS-in-JS (Styled Components)

```bash
bun add styled-components
bun add -d @types/styled-components
```

```typescript
// lib/registry.tsx
'use client';

import React, { useState } from 'react';
import { useServerInsertedHTML } from 'next/navigation';
import { ServerStyleSheet, StyleSheetManager } from 'styled-components';

export default function StyledComponentsRegistry({
  children,
}: {
  children: React.ReactNode;
}) {
  const [styledComponentsStyleSheet] = useState(() => new ServerStyleSheet());

  useServerInsertedHTML(() => {
    const styles = styledComponentsStyleSheet.getStyleElement();
    styledComponentsStyleSheet.instance.clearTag();
    return <>{styles}</>;
  });

  if (typeof window !== 'undefined') return <>{children}</>;

  return (
    <StyleSheetManager sheet={styledComponentsStyleSheet.instance}>
      {children}
    </StyleSheetManager>
  );
}

// app/layout.tsx
import StyledComponentsRegistry from '@/lib/registry';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html>
      <body>
        <StyledComponentsRegistry>{children}</StyledComponentsRegistry>
      </body>
    </html>
  );
}

// components/Button.tsx
'use client';

import styled from 'styled-components';

const Button = styled.button`
  background: #0070f3;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;
  cursor: pointer;

  &:hover {
    background: #0051cc;
  }
`;

export default Button;
```

---

## API Routes

### Route Handlers

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/lib/db';

// GET /api/users
export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams;
  const query = searchParams.get('query');

  const users = await db.user.findMany({
    where: query ? { name: { contains: query } } : {},
  });

  return NextResponse.json(users);
}

// POST /api/users
export async function POST(request: NextRequest) {
  const body = await request.json();
  
  const user = await db.user.create({
    data: {
      name: body.name,
      email: body.email,
    },
  });

  return NextResponse.json(user, { status: 201 });
}
```

### Dynamic Route Handlers

```typescript
// app/api/users/[id]/route.ts
import { NextRequest, NextResponse } from 'next/server';

type Params = {
  params: {
    id: string;
  };
};

// GET /api/users/:id
export async function GET(request: NextRequest, { params }: Params) {
  const user = await db.user.findUnique({
    where: { id: params.id },
  });

  if (!user) {
    return NextResponse.json({ error: 'User not found' }, { status: 404 });
  }

  return NextResponse.json(user);
}

// PATCH /api/users/:id
export async function PATCH(request: NextRequest, { params }: Params) {
  const body = await request.json();
  
  const user = await db.user.update({
    where: { id: params.id },
    data: body,
  });

  return NextResponse.json(user);
}

// DELETE /api/users/:id
export async function DELETE(request: NextRequest, { params }: Params) {
  await db.user.delete({
    where: { id: params.id },
  });

  return NextResponse.json({ message: 'User deleted' });
}
```

### Request & Response Helpers

```typescript
// app/api/example/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { cookies, headers } from 'next/headers';

export async function GET(request: NextRequest) {
  // Request URL
  const url = request.nextUrl;
  const searchParams = url.searchParams;
  const query = searchParams.get('q');

  // Headers
  const authorization = request.headers.get('authorization');
  const headersList = headers();
  const referer = headersList.get('referer');

  // Cookies
  const cookieStore = cookies();
  const token = cookieStore.get('token');

  // Response with headers
  return NextResponse.json(
    { message: 'Success' },
    {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'Cache-Control': 'no-store',
      },
    }
  );
}

export async function POST(request: NextRequest) {
  // JSON body
  const body = await request.json();

  // FormData
  const formData = await request.formData();
  const name = formData.get('name');

  // Set cookie
  const response = NextResponse.json({ success: true });
  response.cookies.set('token', 'abc123', {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    maxAge: 60 * 60 * 24 * 7, // 1 week
  });

  return response;
}
```

### Error Handling

```typescript
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

const UserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email(),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate
    const validatedData = UserSchema.parse(body);
    
    // Create user
    const user = await db.user.create({
      data: validatedData,
    });
    
    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Invalid data', details: error.errors },
        { status: 400 }
      );
    }
    
    console.error('Error creating user:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

---

## Middleware

### Basic Middleware

```typescript
// middleware.ts (root level)
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Log every request
  console.log(`${request.method} ${request.url}`);

  // Continue
  return NextResponse.next();
}

// Optionally specify which routes to run on
export const config = {
  matcher: '/dashboard/:path*',
};
```

### Authentication Middleware

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value;

  // Redirect to login if no token
  if (!token) {
    return NextResponse.redirect(new URL('/login', request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/profile/:path*'],
};
```

### Rewrite & Redirect

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Rewrite (change URL internally, user doesn't see it)
  if (request.nextUrl.pathname.startsWith('/docs')) {
    return NextResponse.rewrite(new URL('/documentation', request.url));
  }

  // Redirect (user sees new URL)
  if (request.nextUrl.pathname === '/old-page') {
    return NextResponse.redirect(new URL('/new-page', request.url));
  }

  // Add custom header
  const response = NextResponse.next();
  response.headers.set('x-custom-header', 'value');
  return response;
}
```

### Geo-location & A/B Testing

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Get geo info (works on Vercel)
  const country = request.geo?.country || 'US';
  const city = request.geo?.city || 'Unknown';

  // A/B test bucket
  const bucket = Math.random() < 0.5 ? 'A' : 'B';

  // Pass to page via header
  const response = NextResponse.next();
  response.headers.set('x-country', country);
  response.headers.set('x-city', city);
  response.headers.set('x-bucket', bucket);

  // Or use cookie
  response.cookies.set('bucket', bucket);

  return response;
}
```

### Rate Limiting

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

export async function middleware(request: NextRequest) {
  const ip = request.ip ?? '127.0.0.1';
  const { success, pending, limit, reset, remaining } = await ratelimit.limit(ip);

  if (!success) {
    return NextResponse.json(
      { error: 'Too many requests' },
      { status: 429 }
    );
  }

  return NextResponse.next();
}

export const config = {
  matcher: '/api/:path*',
};
```

---

## Authentication

### NextAuth.js Setup

```bash
bun add next-auth @auth/prisma-adapter
```

```typescript
// app/api/auth/[...nextauth]/route.ts
import NextAuth from 'next-auth';
import GithubProvider from 'next-auth/providers/github';
import GoogleProvider from 'next-auth/providers/google';
import { PrismaAdapter } from '@auth/prisma-adapter';
import { db } from '@/lib/db';

const handler = NextAuth({
  adapter: PrismaAdapter(db),
  providers: [
    GithubProvider({
      clientId: process.env.GITHUB_ID!,
      clientSecret: process.env.GITHUB_SECRET!,
    }),
    GoogleProvider({
      clientId: process.env.GOOGLE_ID!,
      clientSecret: process.env.GOOGLE_SECRET!,
    }),
  ],
  callbacks: {
    async session({ session, user }) {
      if (session.user) {
        session.user.id = user.id;
      }
      return session;
    },
  },
  pages: {
    signIn: '/auth/signin',
    error: '/auth/error',
  },
});

export { handler as GET, handler as POST };
```

### Session Provider

```typescript
// app/providers.tsx
'use client';

import { SessionProvider } from 'next-auth/react';

export function Providers({ children }: { children: React.ReactNode }) {
  return <SessionProvider>{children}</SessionProvider>;
}

// app/layout.tsx
import { Providers } from './providers';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html>
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

### Using Auth in Client Components

```typescript
// components/UserButton.tsx
'use client';

import { useSession, signIn, signOut } from 'next-auth/react';

export function UserButton() {
  const { data: session, status } = useSession();

  if (status === 'loading') {
    return <p>Loading...</p>;
  }

  if (session) {
    return (
      <div>
        <p>Welcome, {session.user?.name}</p>
        <button onClick={() => signOut()}>Sign out</button>
      </div>
    );
  }

  return <button onClick={() => signIn()}>Sign in</button>;
}
```

### Using Auth in Server Components

```typescript
// app/dashboard/page.tsx
import { getServerSession } from 'next-auth';
import { redirect } from 'next/navigation';

export default async function DashboardPage() {
  const session = await getServerSession();

  if (!session) {
    redirect('/auth/signin');
  }

  return (
    <div>
      <h1>Dashboard</h1>
      <p>Welcome, {session.user?.name}</p>
    </div>
  );
}
```

### Protected API Routes

```typescript
// app/api/protected/route.ts
import { getServerSession } from 'next-auth';
import { NextResponse } from 'next/server';

export async function GET() {
  const session = await getServerSession();

  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  return NextResponse.json({ data: 'Protected data' });
}
```

---

## Database Integration

### Prisma Setup

```bash
bun add prisma @prisma/client
bunx prisma init
```

```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model Post {
  id        String   @id @default(cuid())
  title     String
  content   String?
  published Boolean  @default(false)
  authorId  String
  author    User     @relation(fields: [authorId], references: [id])
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```

```bash
# Generate Prisma client
bunx prisma generate

# Create migration
bunx prisma migrate dev --name init

# Open Prisma Studio
bunx prisma studio
```

### Database Client

```typescript
// lib/db.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const db =
  globalForPrisma.prisma ??
  new PrismaClient({
    log: ['query'],
  });

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = db;
```

### Using in Server Components

```typescript
// app/posts/page.tsx
import { db } from '@/lib/db';

export default async function PostsPage() {
  const posts = await db.post.findMany({
    where: { published: true },
    include: { author: true },
    orderBy: { createdAt: 'desc' },
  });

  return (
    <div>
      {posts.map((post) => (
        <article key={post.id}>
          <h2>{post.title}</h2>
          <p>By {post.author.name}</p>
          <p>{post.content}</p>
        </article>
      ))}
    </div>
  );
}
```

### Drizzle ORM (Alternative)

```bash
bun add drizzle-orm postgres
bun add -d drizzle-kit
```

```typescript
// lib/schema.ts
import { pgTable, text, timestamp, boolean } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: text('id').primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const posts = pgTable('posts', {
  id: text('id').primaryKey(),
  title: text('title').notNull(),
  content: text('content'),
  published: boolean('published').default(false),
  authorId: text('author_id').references(() => users.id),
  createdAt: timestamp('created_at').defaultNow(),
});

// lib/db.ts
import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema';

const client = postgres(process.env.DATABASE_URL!);
export const db = drizzle(client, { schema });
```

---

## Image & Font Optimization

### Next.js Image Component

```typescript
import Image from 'next/image';

export default function Page() {
  return (
    <div>
      {/* Local image (in public/) */}
      <Image
        src="/profile.jpg"
        alt="Profile"
        width={500}
        height={500}
        priority // Load immediately
      />

      {/* Remote image */}
      <Image
        src="https://example.com/photo.jpg"
        alt="Photo"
        width={800}
        height={600}
        quality={90} // 1-100, default 75
      />

      {/* Responsive image (fill container) */}
      <div style={{ position: 'relative', width: '100%', height: '400px' }}>
        <Image
          src="/hero.jpg"
          alt="Hero"
          fill
          style={{ objectFit: 'cover' }}
        />
      </div>

      {/* With blur placeholder */}
      <Image
        src="/photo.jpg"
        alt="Photo"
        width={500}
        height={500}
        placeholder="blur"
        blurDataURL="data:image/png;base64,..." // Or import local image
      />
    </div>
  );
}
```

### Font Optimization

```typescript
// app/layout.tsx
import { Inter, Roboto_Mono } from 'next/font/google';

// Variable font
const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
});

// Fixed weight
const robotoMono = Roboto_Mono({
  weight: ['400', '700'],
  subsets: ['latin'],
  display: 'swap',
});

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={inter.className}>
      <body>
        <h1 className={robotoMono.className}>Monospace Heading</h1>
        {children}
      </body>
    </html>
  );
}
```

### Local Fonts

```typescript
// app/layout.tsx
import localFont from 'next/font/local';

const myFont = localFont({
  src: './fonts/my-font.woff2',
  display: 'swap',
});

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={myFont.className}>
      <body>{children}</body>
    </html>
  );
}
```

---

## Performance Optimization

### Code Splitting & Lazy Loading

```typescript
// Lazy load component
import dynamic from 'next/dynamic';

const HeavyComponent = dynamic(() => import('@/components/HeavyComponent'), {
  loading: () => <p>Loading...</p>,
  ssr: false, // Disable server-side rendering
});

export default function Page() {
  return (
    <div>
      <h1>Page Content</h1>
      <HeavyComponent />
    </div>
  );
}
```

### Optimistic Updates

```typescript
// app/actions.ts
'use