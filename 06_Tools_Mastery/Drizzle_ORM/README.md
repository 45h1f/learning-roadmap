# 🌧️ Drizzle ORM - TypeScript-First ORM

**Modern, lightweight, SQL-like ORM for TypeScript**

---

## 📚 What is Drizzle ORM?

Drizzle is a TypeScript-first ORM that gives you full control over your SQL while maintaining type safety. It's lighter and faster than Prisma, with SQL-like syntax that feels natural for developers who know SQL.

**Key Features:**
- 📝 TypeScript-first with full type inference
- ⚡ Lightweight (zero dependencies)
- 🎯 SQL-like syntax
- 🚀 Better performance than Prisma
- 🔧 Works with PostgreSQL, MySQL, SQLite
- 🌐 Edge-ready (works in Cloudflare Workers)
- 🔄 Migration system included
- 💪 Full SQL control

---

## 🎯 Why Learn Drizzle?

### **vs Prisma:**
✅ More SQL control  
✅ Lighter bundle size  
✅ Faster queries  
✅ Better for edge computing  
✅ No schema.prisma file needed  

### **vs Raw SQL:**
✅ Full type safety  
✅ Auto-completion  
✅ Migrations built-in  
✅ Less boilerplate  

### **Best For:**
- Full-stack TypeScript apps
- Edge computing
- Performance-critical apps
- Developers who like SQL
- Projects using tRPC

---

## 🚀 Quick Start

### Installation
```bash
# Install Drizzle ORM
npm install drizzle-orm

# Install driver (choose one)
npm install pg              # PostgreSQL
npm install mysql2          # MySQL
npm install better-sqlite3  # SQLite

# Install dev tools
npm install -D drizzle-kit
```

### Basic Setup (PostgreSQL)
```typescript
// db/schema.ts
import { pgTable, serial, text, timestamp, integer } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: serial('id').primaryKey(),
  name: text('name').notNull(),
  email: text('email').notNull().unique(),
  age: integer('age'),
  createdAt: timestamp('created_at').defaultNow(),
});

export const posts = pgTable('posts', {
  id: serial('id').primaryKey(),
  title: text('title').notNull(),
  content: text('content'),
  authorId: integer('author_id').references(() => users.id),
  publishedAt: timestamp('published_at'),
  createdAt: timestamp('created_at').defaultNow(),
});
```

### Database Connection
```typescript
// db/index.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from './schema';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool, { schema });
```

### Type-Safe Queries
```typescript
import { db } from './db';
import { users, posts } from './db/schema';
import { eq, and, like, desc } from 'drizzle-orm';

// SELECT all users
const allUsers = await db.select().from(users);

// SELECT with WHERE
const user = await db
  .select()
  .from(users)
  .where(eq(users.email, 'john@example.com'));

// SELECT with multiple conditions
const activeAdults = await db
  .select()
  .from(users)
  .where(and(
    eq(users.status, 'active'),
    gte(users.age, 18)
  ));

// SELECT with LIKE
const searchUsers = await db
  .select()
  .from(users)
  .where(like(users.name, '%John%'));

// INSERT
const newUser = await db
  .insert(users)
  .values({
    name: 'Alice',
    email: 'alice@example.com',
    age: 25,
  })
  .returning();

// UPDATE
await db
  .update(users)
  .set({ name: 'Bob Smith' })
  .where(eq(users.id, 1));

// DELETE
await db
  .delete(users)
  .where(eq(users.id, 1));

// JOIN
const usersWithPosts = await db
  .select()
  .from(users)
  .leftJoin(posts, eq(users.id, posts.authorId));

// ORDER BY with LIMIT
const recentPosts = await db
  .select()
  .from(posts)
  .orderBy(desc(posts.createdAt))
  .limit(10);
```

---

## 📖 Core Concepts

### 1. Schema Definition
```typescript
import { pgTable, serial, varchar, boolean, timestamp } from 'drizzle-orm/pg-core';

export const products = pgTable('products', {
  id: serial('id').primaryKey(),
  name: varchar('name', { length: 255 }).notNull(),
  price: integer('price').notNull(),
  inStock: boolean('in_stock').default(true),
  createdAt: timestamp('created_at').defaultNow(),
});
```

### 2. Relations
```typescript
import { relations } from 'drizzle-orm';

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}));

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.authorId],
    references: [users.id],
  }),
}));
```

### 3. Migrations
```typescript
// drizzle.config.ts
import type { Config } from 'drizzle-kit';

export default {
  schema: './src/db/schema.ts',
  out: './drizzle',
  driver: 'pg',
  dbCredentials: {
    connectionString: process.env.DATABASE_URL!,
  },
} satisfies Config;
```

```bash
# Generate migrations
npx drizzle-kit generate:pg

# Run migrations
npx drizzle-kit push:pg

# Open Drizzle Studio (GUI)
npx drizzle-kit studio
```

### 4. Transactions
```typescript
await db.transaction(async (tx) => {
  const user = await tx.insert(users).values({
    name: 'John',
    email: 'john@example.com',
  }).returning();

  await tx.insert(posts).values({
    title: 'First Post',
    authorId: user[0].id,
  });
});
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Install Drizzle ORM
- [ ] Create schema
- [ ] Basic CRUD operations
- [ ] Simple queries

### Week 2: Advanced
- [ ] Relations & joins
- [ ] Migrations
- [ ] Transactions
- [ ] Query builder

### Week 3: Production
- [ ] Connection pooling
- [ ] Error handling
- [ ] Performance optimization
- [ ] Edge deployment

---

## 🛠️ Common Patterns

### Pagination
```typescript
const page = 1;
const pageSize = 10;

const paginatedUsers = await db
  .select()
  .from(users)
  .limit(pageSize)
  .offset((page - 1) * pageSize);
```

### Aggregations
```typescript
import { count, avg, sum } from 'drizzle-orm';

const stats = await db
  .select({
    totalUsers: count(users.id),
    avgAge: avg(users.age),
  })
  .from(users);
```

### Subqueries
```typescript
const sq = db
  .select({ id: posts.authorId, postCount: count() })
  .from(posts)
  .groupBy(posts.authorId)
  .as('sq');

const prolificAuthors = await db
  .select()
  .from(users)
  .leftJoin(sq, eq(users.id, sq.id))
  .where(gt(sq.postCount, 10));
```

---

## 🔥 Projects to Build

### Beginner
1. **Todo App with Drizzle**
   - Users, tasks tables
   - CRUD operations
   - Filtering & sorting

### Intermediate
2. **Blog Platform**
   - Users, posts, comments
   - Relations & joins
   - Pagination
   - Full-text search

### Advanced
3. **E-commerce Backend**
   - Products, orders, users
   - Transactions
   - Complex queries
   - Performance optimization

---

## 📚 Resources

### Official
- [Drizzle Docs](https://orm.drizzle.team/)
- [Drizzle GitHub](https://github.com/drizzle-team/drizzle-orm)
- [Drizzle Discord](https://discord.gg/drizzle)

### Tutorials
- [Drizzle Crash Course](https://www.youtube.com/watch?v=_SLxGYzv6jo) - YouTube
- [Full-stack with Drizzle](https://www.youtube.com/watch?v=qCLV0Iaq9zU)

### Comparisons
- [Drizzle vs Prisma](https://orm.drizzle.team/docs/prisma)
- [Migration Guide from Prisma](https://orm.drizzle.team/docs/prisma-to-drizzle)

---

## 💡 Pro Tips

1. **Use Drizzle Studio** - Visual database browser
2. **Type inference** - Let TypeScript infer types
3. **Prepared statements** - For repeated queries
4. **Edge compatibility** - Works in Cloudflare Workers
5. **SQL-first** - Write SQL when needed
6. **Zod integration** - Validate with Zod schemas
7. **tRPC pairing** - Perfect combo with tRPC

---

## ⚡ Integration Examples

### With Next.js
```typescript
// app/api/users/route.ts
import { NextResponse } from 'next/server';
import { db } from '@/db';
import { users } from '@/db/schema';

export async function GET() {
  const allUsers = await db.select().from(users);
  return NextResponse.json(allUsers);
}
```

### With tRPC
```typescript
import { db } from './db';
import { users } from './db/schema';
import { eq } from 'drizzle-orm';

export const appRouter = router({
  getUser: publicProcedure
    .input(z.string())
    .query(async ({ input }) => {
      return await db
        .select()
        .from(users)
        .where(eq(users.id, input));
    }),
});
```

### With Bun
```typescript
import { drizzle } from 'drizzle-orm/bun-sqlite';
import { Database } from 'bun:sqlite';

const sqlite = new Database('sqlite.db');
export const db = drizzle(sqlite);
```

---

## ✅ Checklist

### Installation & Setup
- [ ] Install Drizzle ORM
- [ ] Install database driver
- [ ] Set up schema file
- [ ] Configure drizzle.config.ts
- [ ] Test connection

### Learn Core Features
- [ ] Define tables
- [ ] CRUD operations
- [ ] Filters (WHERE)
- [ ] Joins
- [ ] Transactions
- [ ] Migrations

### Build Projects
- [ ] Simple CRUD app
- [ ] App with relations
- [ ] Production app

---

## 🎯 When to Use Drizzle

### ✅ Use Drizzle When:
- Building TypeScript apps
- Need SQL control
- Performance matters
- Edge deployment (Cloudflare Workers)
- Want lightweight ORM
- Comfortable with SQL

### ❌ Maybe Use Prisma When:
- Need larger ecosystem
- Want more abstraction
- Team prefers Prisma
- Need advanced features (Prisma Migrate, Studio)

---

## 💼 Career Impact

**Drizzle Skills = Modern Developer**

- **Salary Boost**: +$5-10K
- **Job Opportunities**: Startups, modern companies
- **Stack Relevance**: 2025+ standard
- **Pairs With**: Next.js, tRPC, Bun, Edge computing

**Companies Using**:
- Modern startups
- Edge-first companies
- Performance-focused teams
- TypeScript-first organizations

---

## 🚀 Next Steps

1. **Install Drizzle** → `npm install drizzle-orm`
2. **Create Schema** → Define your tables
3. **Run Migrations** → Set up database
4. **Build CRUD App** → Practice queries
5. **Add Relations** → Master joins
6. **Deploy** → Production experience

---

**Status**: 🚧 Full content coming soon!

For now, check:
- [Official Docs](https://orm.drizzle.team/)
- [MODERN_TOOLS_2025.md](../MODERN_TOOLS_2025.md) - Complete modern tools guide

---

**Last Updated**: January 2025  
**Priority**: 🟡 HIGH (Month 2-3)