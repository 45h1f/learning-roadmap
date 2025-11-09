# 🚀 Astro - Zero-JavaScript Framework

**The modern web framework for content-focused websites**

---

## 📋 Overview

**Astro** is a revolutionary web framework that delivers **zero JavaScript by default**, making it perfect for blogs, documentation sites, marketing pages, and any content-focused website. It's the fastest way to build websites that prioritize performance.

**Key Stats:**
- ⚡ **100/100** Lighthouse scores by default
- 🎯 **Zero JS** shipped to browser (unless you need it)
- 🔧 **Use any framework** - React, Vue, Svelte, Solid together
- 🚀 **Island Architecture** - Interactive components only where needed
- 📝 **Content Collections** - Type-safe content management

**Release:** 2021 → Stable 4.0+ (2024)  
**Company:** Fred K. Schott & team (Open Source)  
**GitHub:** 40,000+ stars

---

## 🔥 Why Learn Astro?

### Performance Benefits
- ⚡ **Fastest load times** - Static HTML by default
- 🎯 **Zero runtime** - No JavaScript framework overhead
- 📦 **Small bundles** - Only ship what's needed
- 🌐 **SEO perfect** - Search engines love static HTML

### Developer Experience
- 🎨 **Use any UI framework** - React, Vue, Svelte, Solid, Preact
- 📝 **Content Collections** - Type-safe Markdown/MDX
- 🔄 **Server-Side Rendering** - Dynamic pages when needed
- 🖼️ **Image optimization** - Built-in
- 🎯 **TypeScript** - First-class support

### Use Cases
✅ Blogs & personal sites  
✅ Documentation sites  
✅ Marketing pages  
✅ Landing pages  
✅ E-commerce (content-heavy)  
✅ Portfolio sites  
✅ Company websites  

❌ Real-time dashboards  
❌ Complex web apps (use Next.js instead)  
❌ Heavy client-side interactions  

---

## 🚀 Quick Start

### Installation
```bash
# Create new Astro project
npm create astro@latest

# Or with Bun (faster)
bun create astro@latest

# Follow the interactive prompts
```

### Project Structure
```
my-astro-site/
├── src/
│   ├── pages/           # File-based routing
│   │   ├── index.astro  # Homepage (/)
│   │   ├── about.astro  # About page (/about)
│   │   └── blog/
│   │       ├── [...slug].astro
│   │       └── index.astro
│   ├── layouts/         # Page layouts
│   │   └── Layout.astro
│   ├── components/      # Reusable components
│   │   ├── Header.astro
│   │   └── Card.jsx     # Can use React!
│   └── content/         # Content collections
│       └── blog/
│           ├── post-1.md
│           └── post-2.md
├── public/              # Static assets
└── astro.config.mjs     # Configuration
```

### First Astro Component
```astro
---
// src/pages/index.astro
// Code runs at BUILD TIME (not browser)
const title = "Welcome to Astro";
const currentYear = new Date().getFullYear();
---

<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width" />
    <title>{title}</title>
  </head>
  <body>
    <h1>{title}</h1>
    <p>Built with Astro - Zero JavaScript!</p>
    <footer>© {currentYear}</footer>
  </body>
</html>
```

### Run Development Server
```bash
npm run dev
# or
bun dev

# Open http://localhost:4321
```

---

## 🎨 Island Architecture (The Magic!)

**Concept:** Ship HTML by default. Add interactivity only where needed.

### Static Component (No JS)
```astro
---
// src/components/Card.astro
interface Props {
  title: string;
  description: string;
}

const { title, description } = Astro.props;
---

<div class="card">
  <h2>{title}</h2>
  <p>{description}</p>
</div>

<style>
  .card {
    border: 1px solid #ccc;
    padding: 1rem;
    border-radius: 8px;
  }
</style>
```

### Interactive Island (React Component)
```jsx
// src/components/Counter.jsx
import { useState } from 'react';

export default function Counter() {
  const [count, setCount] = useState(0);
  
  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
}
```

### Using Components Together
```astro
---
// src/pages/index.astro
import Layout from '../layouts/Layout.astro';
import Card from '../components/Card.astro';
import Counter from '../components/Counter.jsx';
---

<Layout title="My Site">
  <!-- Static HTML - No JS -->
  <Card 
    title="Welcome" 
    description="This is pure HTML"
  />
  
  <!-- Interactive Island - Loads React -->
  <Counter client:load />
  
  <!-- Lazy load on scroll -->
  <Counter client:visible />
  
  <!-- Load on idle -->
  <Counter client:idle />
</Layout>
```

---

## 📝 Content Collections (Type-Safe Content)

### Define Collection Schema
```typescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blogCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.date(),
    author: z.string(),
    image: z.string().optional(),
    tags: z.array(z.string()),
  }),
});

export const collections = {
  'blog': blogCollection,
};
```

### Create Content
```markdown
---
# src/content/blog/my-first-post.md
title: "My First Post"
description: "This is my first blog post"
pubDate: 2024-01-15
author: "John Doe"
tags: ["astro", "blog"]
---

# Welcome to My Blog

This is **Markdown** content!

- List item 1
- List item 2

## Code Example

\`\`\`javascript
console.log("Hello Astro!");
\`\`\`
```

### Query Content
```astro
---
// src/pages/blog/index.astro
import { getCollection } from 'astro:content';
import Layout from '../../layouts/Layout.astro';

// Type-safe! ✨
const posts = await getCollection('blog');
const sortedPosts = posts.sort((a, b) => 
  b.data.pubDate.valueOf() - a.data.pubDate.valueOf()
);
---

<Layout title="Blog">
  <h1>Blog Posts</h1>
  <ul>
    {sortedPosts.map(post => (
      <li>
        <a href={`/blog/${post.slug}`}>
          <h2>{post.data.title}</h2>
          <p>{post.data.description}</p>
          <time>{post.data.pubDate.toLocaleDateString()}</time>
        </a>
      </li>
    ))}
  </ul>
</Layout>
```

### Dynamic Routes
```astro
---
// src/pages/blog/[...slug].astro
import { getCollection } from 'astro:content';
import Layout from '../../layouts/Layout.astro';

export async function getStaticPaths() {
  const posts = await getCollection('blog');
  return posts.map(post => ({
    params: { slug: post.slug },
    props: { post },
  }));
}

const { post } = Astro.props;
const { Content } = await post.render();
---

<Layout title={post.data.title}>
  <article>
    <h1>{post.data.title}</h1>
    <time>{post.data.pubDate.toLocaleDateString()}</time>
    <Content />
  </article>
</Layout>
```

---

## 🎯 Client Directives

Control when interactive components load:

```astro
---
import Counter from '../components/Counter.jsx';
---

<!-- Load immediately -->
<Counter client:load />

<!-- Load when visible (lazy) -->
<Counter client:visible />

<!-- Load when browser idle -->
<Counter client:idle />

<!-- Load on media query -->
<Counter client:media="(max-width: 768px)" />

<!-- Render only on client (skip SSR) -->
<Counter client:only="react" />
```

**Best Practice:** Use `client:visible` for most interactive components!

---

## 🔧 Configuration

### astro.config.mjs
```javascript
import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import vue from '@astrojs/vue';
import tailwind from '@astrojs/tailwind';

export default defineConfig({
  // Enable integrations
  integrations: [
    react(),
    vue(),
    tailwind(),
  ],
  
  // Output mode
  output: 'static', // or 'server' or 'hybrid'
  
  // Site URL (for sitemap/RSS)
  site: 'https://example.com',
  
  // Base path
  base: '/',
  
  // Image optimization
  image: {
    domains: ['images.unsplash.com'],
  },
});
```

---

## 🖼️ Image Optimization

### Local Images
```astro
---
import { Image } from 'astro:assets';
import myImage from '../assets/my-image.png';
---

<!-- Optimized automatically! -->
<Image 
  src={myImage} 
  alt="Description"
  width={800}
  height={600}
/>
```

### Remote Images
```astro
---
import { Image } from 'astro:assets';
---

<Image 
  src="https://example.com/image.jpg"
  alt="Remote image"
  width={800}
  height={600}
  format="webp"
/>
```

---

## 🌐 Server-Side Rendering (SSR)

### Enable SSR
```javascript
// astro.config.mjs
export default defineConfig({
  output: 'server', // or 'hybrid'
  adapter: vercel(), // or netlify(), cloudflare(), etc.
});
```

### API Endpoints
```typescript
// src/pages/api/users.json.ts
export async function GET({ params, request }) {
  const users = [
    { id: 1, name: 'Alice' },
    { id: 2, name: 'Bob' },
  ];
  
  return new Response(JSON.stringify(users), {
    status: 200,
    headers: {
      'Content-Type': 'application/json',
    },
  });
}

export async function POST({ request }) {
  const data = await request.json();
  // Save to database
  return new Response(JSON.stringify({ success: true }), {
    status: 201,
  });
}
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Install Astro
- [ ] Create first site
- [ ] Learn component syntax
- [ ] Understand file-based routing
- [ ] Build 3-page site
- [ ] Deploy to Vercel/Netlify

### Week 2: Content Collections
- [ ] Set up content collections
- [ ] Create blog with Markdown
- [ ] Dynamic routes
- [ ] Pagination
- [ ] RSS feed
- [ ] Sitemap

### Week 3: Islands
- [ ] Add React components
- [ ] Client directives
- [ ] Image optimization
- [ ] Tailwind CSS
- [ ] SEO optimization

### Week 4: Advanced
- [ ] SSR setup
- [ ] API endpoints
- [ ] Multiple frameworks (React + Vue)
- [ ] Production deployment
- [ ] Performance testing

**Time to Proficiency:** 2-3 weeks  
**Difficulty:** ⭐⭐ (Easy to learn)

---

## 🛠️ Essential Integrations

### Install Integrations
```bash
# Tailwind CSS
npx astro add tailwind

# React
npx astro add react

# Vue
npx astro add vue

# Svelte
npx astro add svelte

# MDX (Markdown + JSX)
npx astro add mdx

# Sitemap
npx astro add sitemap
```

---

## 🎯 Real-World Examples

### Blog Site
```astro
---
// src/pages/index.astro
import { getCollection } from 'astro:content';
import Layout from '../layouts/Layout.astro';

const posts = await getCollection('blog');
const latestPosts = posts.slice(0, 5);
---

<Layout title="My Blog">
  <header>
    <h1>Welcome to My Blog</h1>
    <p>Thoughts on web development</p>
  </header>
  
  <main>
    <h2>Latest Posts</h2>
    {latestPosts.map(post => (
      <article>
        <h3>
          <a href={`/blog/${post.slug}`}>
            {post.data.title}
          </a>
        </h3>
        <time>{post.data.pubDate.toLocaleDateString()}</time>
        <p>{post.data.description}</p>
      </article>
    ))}
  </main>
</Layout>
```

### Portfolio Site
```astro
---
// src/pages/projects.astro
import Layout from '../layouts/Layout.astro';

const projects = [
  {
    title: 'E-commerce Site',
    tech: ['Next.js', 'Stripe', 'PostgreSQL'],
    link: 'https://example.com',
    github: 'https://github.com/...',
  },
  // More projects...
];
---

<Layout title="Projects">
  <h1>My Projects</h1>
  <div class="grid">
    {projects.map(project => (
      <div class="card">
        <h2>{project.title}</h2>
        <div class="tech">
          {project.tech.map(t => <span>{t}</span>)}
        </div>
        <div class="links">
          <a href={project.link}>Live Demo</a>
          <a href={project.github}>GitHub</a>
        </div>
      </div>
    ))}
  </div>
</Layout>

<style>
  .grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 2rem;
  }
  
  .card {
    border: 1px solid #ddd;
    padding: 1.5rem;
    border-radius: 8px;
  }
</style>
```

---

## 🚀 Deployment

### Vercel
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Automatic deployment on git push
```

### Netlify
```bash
# netlify.toml
[build]
  command = "npm run build"
  publish = "dist"
```

### Cloudflare Pages
```bash
# Build command: npm run build
# Build output directory: dist
```

### Static Hosting (GitHub Pages)
```bash
# Build
npm run build

# Output in dist/ folder
# Upload to GitHub Pages
```

---

## 💡 Pro Tips

1. **Use Content Collections** - Type safety for content
2. **client:visible** - Best for most interactive components
3. **Image component** - Always use for optimization
4. **Keep it static** - Avoid SSR unless needed
5. **Tailwind + Astro** - Perfect combination
6. **MDX for rich content** - Mix Markdown with components
7. **View Transitions API** - Smooth page transitions
8. **Zero-runtime CSS** - Scoped styles are free

---

## 📚 Resources

### Official
- **Docs**: https://docs.astro.build
- **GitHub**: https://github.com/withastro/astro
- **Discord**: https://astro.build/chat
- **Blog**: https://astro.build/blog

### Tutorials
- **Astro Crash Course** - Traversy Media (YouTube)
- **Build a Blog** - Official tutorial
- **Astro 4.0** - Theo t3.gg (YouTube)

### Templates
- **astro.new** - Official starter templates
- **Astro Themes** - https://astro.build/themes

---

## 🎯 Projects to Build

### Beginner
1. **Personal Portfolio**
   - About, Projects, Contact pages
   - Deploy to Vercel
   
2. **Simple Blog**
   - 5 blog posts in Markdown
   - Home page listing
   - Individual post pages

### Intermediate
3. **Documentation Site**
   - Multiple sections
   - Search functionality
   - Code syntax highlighting
   - Dark mode

4. **Company Website**
   - Landing page
   - Services page
   - Team members
   - Contact form (API route)

### Advanced
5. **Content-Heavy E-commerce**
   - Product pages (static)
   - Blog integration
   - Newsletter signup
   - Image gallery

---

## ⚡ Performance

**Out-of-the-box Lighthouse Scores:**
- Performance: 100
- Accessibility: 100
- Best Practices: 100
- SEO: 100

**Why?**
- Zero JavaScript by default
- Optimized HTML/CSS
- Automatic image optimization
- No client-side routing overhead

---

## 💼 Career Impact

### Salary Boost
- **Astro skill**: +$5-10K
- **Niche expertise**: High demand for fast sites
- **SEO optimization**: Valuable for companies

### Job Opportunities
- Content sites & blogs
- Marketing agencies
- E-commerce (content-heavy)
- Documentation teams
- Developer advocates

### Companies Using Astro
- Firebase (docs)
- Sentry (marketing site)
- The Guardian (experimental)
- Many agencies & startups

---

## 🆚 Astro vs Others

### Astro vs Next.js
- **Use Astro**: Content sites, blogs, marketing
- **Use Next.js**: Web apps, dashboards, SaaS

### Astro vs Gatsby
- **Astro**: Simpler, faster builds, zero JS
- **Gatsby**: More plugins, heavier

### Astro vs Hugo/Jekyll
- **Astro**: Modern DX, use any framework
- **Hugo/Jekyll**: Simpler, less flexible

---

## ✅ Checklist

### Setup
- [ ] Install Astro
- [ ] Create first site
- [ ] Configure VS Code
- [ ] Install Prettier Astro plugin

### Learn Core Concepts
- [ ] Component syntax
- [ ] File-based routing
- [ ] Layouts
- [ ] Props
- [ ] Islands

### Build Projects
- [ ] Personal site
- [ ] Blog with content collections
- [ ] Production deployment

---

## 🚨 When NOT to Use Astro

❌ Complex dashboards  
❌ Real-time applications  
❌ Heavy client-side state  
❌ Single-page applications (SPAs)  
❌ When you need Next.js features  

**For those, use Next.js or React frameworks**

---

## 🎉 Why Developers Love Astro

> "Astro is like a breath of fresh air in the web framework world"

- **Simple**: Easy to learn
- **Fast**: 100/100 Lighthouse scores
- **Flexible**: Use any framework
- **Modern**: Great DX
- **Performant**: Zero JS overhead

---

**Last Updated**: January 2025  
**Status**: ✅ Complete Guide  
**Priority**: 🟡 High (Content-focused sites)

*Build the fastest websites with Astro! 🚀*