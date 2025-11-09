# 🦕 Deno - Secure TypeScript Runtime

**The modern, secure JavaScript/TypeScript runtime by Node.js creator**

---

## 📋 Overview

**Deno** is a secure runtime for JavaScript and TypeScript, created by Ryan Dahl (the original creator of Node.js) to address Node's design mistakes. Deno 2.0 brings full Node.js compatibility while maintaining its security-first approach.

**Key Features:**
- 🔒 **Secure by default** - Explicit permissions required
- 📝 **Native TypeScript** - No config needed
- 🌐 **Web Standard APIs** - Fetch, WebSocket, etc.
- 📦 **No node_modules** - Import from URLs
- 🔧 **Built-in tools** - Formatter, linter, tester
- ⚡ **Fast** - Built on Rust & V8

**Release:** 2018 → Deno 2.0 (2024)  
**Creator:** Ryan Dahl  
**Language:** Rust  
**GitHub:** 90,000+ stars

---

## 🔥 Why Learn Deno?

### Security Benefits
- 🔒 **No file access** without permission
- 🌐 **No network access** without permission
- 🔐 **No environment variables** without permission
- 🛡️ **Sandboxed by default**

### Developer Experience
- 📝 **TypeScript works immediately** - No tsconfig.json
- 🎯 **No package.json** needed
- 🔧 **All tools included** - No separate installs
- 🌍 **Import from URLs** - Like Go/Rust
- 💻 **Modern APIs** - Web standards

### Use Cases
✅ CLI tools  
✅ APIs & microservices  
✅ Edge functions  
✅ Secure applications  
✅ Scripts & automation  
✅ Backend services  

---

## 🚀 Quick Start

### Installation

```bash
# macOS/Linux
curl -fsSL https://deno.land/install.sh | sh

# Windows (PowerShell)
irm https://deno.land/install.ps1 | iex

# Homebrew
brew install deno

# Verify installation
deno --version
```

### First Deno Program

```typescript
// hello.ts
console.log("Hello from Deno! 🦕");

const name = "World";
console.log(`Welcome, ${name}!`);
```

```bash
# Run TypeScript directly!
deno run hello.ts

# No compilation needed!
```

---

## 🔒 Security & Permissions

### Permission Flags

```bash
# No permissions (default)
deno run script.ts
# Error if tries to access file/network

# Allow network
deno run --allow-net script.ts

# Allow file read
deno run --allow-read script.ts

# Allow file write
deno run --allow-write script.ts

# Allow environment variables
deno run --allow-env script.ts

# Allow all (development only!)
deno run --allow-all script.ts
deno run -A script.ts

# Specific permissions
deno run --allow-net=api.github.com script.ts
deno run --allow-read=/tmp script.ts
```

### Permission Example

```typescript
// secure-fetch.ts
const response = await fetch("https://api.github.com/users/denoland");
const data = await response.json();
console.log(data);
```

```bash
# This fails (no network permission)
deno run secure-fetch.ts

# This works
deno run --allow-net=api.github.com secure-fetch.ts
```

---

## 📦 Module System

### Import from URLs

```typescript
// No npm install needed!
import { serve } from "https://deno.land/std@0.210.0/http/server.ts";
import { parse } from "https://deno.land/std@0.210.0/flags/mod.ts";

// Third-party modules
import { Application } from "https://deno.land/x/oak@v12.6.1/mod.ts";
```

### Import Maps (Optional)

```json
// deno.json
{
  "imports": {
    "oak": "https://deno.land/x/oak@v12.6.1/mod.ts",
    "std/": "https://deno.land/std@0.210.0/"
  }
}
```

```typescript
// Now you can use short imports
import { Application } from "oak";
import { serve } from "std/http/server.ts";
```

### Node.js Compatibility (Deno 2.0)

```typescript
// Import npm packages directly!
import express from "npm:express@4";
import { createClient } from "npm:@supabase/supabase-js@2";

const app = express();
app.get("/", (req, res) => res.send("Express on Deno!"));
app.listen(3000);
```

---

## 🌐 HTTP Server

### Simple Server

```typescript
// server.ts
Deno.serve({ port: 8000 }, (_req) => {
  return new Response("Hello from Deno server! 🦕");
});
```

```bash
deno run --allow-net server.ts
```

### REST API

```typescript
// api.ts
interface User {
  id: number;
  name: string;
  email: string;
}

const users: User[] = [
  { id: 1, name: "Alice", email: "alice@example.com" },
  { id: 2, name: "Bob", email: "bob@example.com" },
];

Deno.serve({ port: 8000 }, (req) => {
  const url = new URL(req.url);
  
  // GET /api/users
  if (url.pathname === "/api/users" && req.method === "GET") {
    return Response.json(users);
  }
  
  // GET /api/users/:id
  if (url.pathname.startsWith("/api/users/") && req.method === "GET") {
    const id = parseInt(url.pathname.split("/")[3]);
    const user = users.find((u) => u.id === id);
    
    if (!user) {
      return Response.json({ error: "Not found" }, { status: 404 });
    }
    
    return Response.json(user);
  }
  
  // POST /api/users
  if (url.pathname === "/api/users" && req.method === "POST") {
    const body = await req.json();
    const newUser: User = {
      id: users.length + 1,
      name: body.name,
      email: body.email,
    };
    users.push(newUser);
    
    return Response.json(newUser, { status: 201 });
  }
  
  return new Response("Not Found", { status: 404 });
});
```

```bash
deno run --allow-net api.ts
```

---

## 🧪 Built-in Testing

```typescript
// math.ts
export function add(a: number, b: number): number {
  return a + b;
}

export function multiply(a: number, b: number): number {
  return a * b;
}
```

```typescript
// math.test.ts
import { assertEquals } from "https://deno.land/std@0.210.0/assert/mod.ts";
import { add, multiply } from "./math.ts";

Deno.test("add function", () => {
  assertEquals(add(2, 3), 5);
  assertEquals(add(-1, 1), 0);
});

Deno.test("multiply function", () => {
  assertEquals(multiply(2, 3), 6);
  assertEquals(multiply(0, 5), 0);
});

Deno.test("async test", async () => {
  const result = await Promise.resolve(42);
  assertEquals(result, 42);
});
```

```bash
# Run all tests
deno test

# Run specific test file
deno test math.test.ts

# Watch mode
deno test --watch
```

---

## 🔧 Built-in Tools

### Formatter

```bash
# Format files
deno fmt

# Check formatting
deno fmt --check

# Format specific files
deno fmt src/
```

### Linter

```bash
# Lint files
deno lint

# Lint specific files
deno lint src/

# Lint with auto-fix
deno lint --fix
```

### Bundler

```bash
# Bundle for distribution
deno bundle mod.ts bundle.js

# Compile to executable
deno compile --allow-net server.ts
# Creates ./server binary
```

### Documentation

```bash
# Generate documentation
deno doc mod.ts

# Generate HTML docs
deno doc --html --name="My Project" mod.ts
```

---

## 📁 File Operations

### Reading Files

```typescript
// read.ts
const text = await Deno.readTextFile("./data.txt");
console.log(text);

const bytes = await Deno.readFile("./image.png");
console.log(bytes);

// JSON file
const jsonText = await Deno.readTextFile("./config.json");
const config = JSON.parse(jsonText);
```

```bash
deno run --allow-read read.ts
```

### Writing Files

```typescript
// write.ts
await Deno.writeTextFile("./output.txt", "Hello Deno!");

const data = { name: "Deno", version: "2.0" };
await Deno.writeTextFile("./config.json", JSON.stringify(data, null, 2));

const bytes = new Uint8Array([1, 2, 3]);
await Deno.writeFile("./data.bin", bytes);
```

```bash
deno run --allow-write write.ts
```

### File Info

```typescript
const fileInfo = await Deno.stat("./file.txt");
console.log(fileInfo.isFile); // true
console.log(fileInfo.size); // bytes
console.log(fileInfo.mtime); // modified time
```

---

## 🌍 Environment Variables

```typescript
// env.ts

// Read environment variable
const apiKey = Deno.env.get("API_KEY");
console.log(apiKey);

// Set environment variable
Deno.env.set("MY_VAR", "value");

// Delete environment variable
Deno.env.delete("MY_VAR");

// Get all environment variables
const allEnv = Deno.env.toObject();
console.log(allEnv);
```

```bash
# Need permission
deno run --allow-env env.ts

# Specific env var
deno run --allow-env=API_KEY env.ts

# Set env var
API_KEY=secret deno run --allow-env=API_KEY env.ts
```

### .env File Support

```typescript
import { load } from "https://deno.land/std@0.210.0/dotenv/mod.ts";

const env = await load();
console.log(env.DATABASE_URL);
```

---

## ⚙️ Configuration (deno.json)

```json
{
  "compilerOptions": {
    "lib": ["deno.window"],
    "strict": true
  },
  "imports": {
    "oak": "https://deno.land/x/oak@v12.6.1/mod.ts",
    "std/": "https://deno.land/std@0.210.0/",
    "@/": "./src/"
  },
  "tasks": {
    "dev": "deno run --allow-net --allow-env --watch server.ts",
    "start": "deno run --allow-net --allow-env server.ts",
    "test": "deno test --allow-net"
  },
  "fmt": {
    "options": {
      "useTabs": false,
      "lineWidth": 80,
      "indentWidth": 2,
      "singleQuote": true
    }
  },
  "lint": {
    "rules": {
      "tags": ["recommended"],
      "exclude": ["no-unused-vars"]
    }
  }
}
```

### Run Tasks

```bash
deno task dev
deno task start
deno task test
```

---

## 🎯 Real-World Examples

### CLI Tool

```typescript
// cli.ts
import { parse } from "https://deno.land/std@0.210.0/flags/mod.ts";

const args = parse(Deno.args);

if (args.help || args.h) {
  console.log(`
Usage: deno run cli.ts [options]

Options:
  --name, -n    Your name
  --help, -h    Show help
  `);
  Deno.exit(0);
}

const name = args.name || args.n || "World";
console.log(`Hello, ${name}! 🦕`);
```

```bash
deno run cli.ts --name Alice
deno compile --allow-all cli.ts
./cli --name Bob
```

### Web Scraper

```typescript
// scraper.ts
import { DOMParser } from "https://deno.land/x/deno_dom@v0.1.38/deno-dom-wasm.ts";

const url = "https://example.com";
const response = await fetch(url);
const html = await response.text();

const doc = new DOMParser().parseFromString(html, "text/html");
const title = doc?.querySelector("title")?.textContent;

console.log(`Title: ${title}`);
```

```bash
deno run --allow-net scraper.ts
```

### File Watcher

```typescript
// watcher.ts
const watcher = Deno.watchFs("./src");

for await (const event of watcher) {
  console.log(`File ${event.kind}:`, event.paths);
}
```

```bash
deno run --allow-read watcher.ts
```

---

## 🚀 Deployment

### Deno Deploy (Official Platform)

```bash
# Install deployctl
deno install --allow-all --no-check -r -f https://deno.land/x/deploy/deployctl.ts

# Deploy
deployctl deploy --project=my-project server.ts

# Automatic deployment from GitHub
```

### Docker

```dockerfile
FROM denoland/deno:alpine

WORKDIR /app

COPY . .

RUN deno cache server.ts

EXPOSE 8000

CMD ["deno", "run", "--allow-net", "--allow-env", "server.ts"]
```

### Self-Contained Binary

```bash
# Compile to executable
deno compile --allow-net --allow-env --output=myapp server.ts

# Now you have a standalone binary
./myapp
```

---

## 🎓 Learning Path

### Week 1: Basics
- [ ] Install Deno
- [ ] Learn permission system
- [ ] Create HTTP server
- [ ] Understand imports
- [ ] Write tests

### Week 2: APIs
- [ ] Build REST API
- [ ] File operations
- [ ] Environment variables
- [ ] Error handling
- [ ] Deploy to Deno Deploy

### Week 3: Advanced
- [ ] CLI tools
- [ ] WebSocket server
- [ ] Database integration
- [ ] Node.js compatibility
- [ ] Production deployment

**Time to Proficiency:** 2-3 weeks  
**Difficulty:** ⭐⭐⭐ (Intermediate)

---

## 💡 Pro Tips

1. **Start secure** - Always use minimal permissions
2. **Use deno.json** - Configure once, run anywhere
3. **Lock dependencies** - `deno cache --lock=lock.json`
4. **TypeScript by default** - No config needed
5. **Standard library** - Use Deno's std library
6. **Tasks** - Define common commands in deno.json
7. **Deno Deploy** - Free edge deployment
8. **Node compatibility** - Import npm packages with `npm:`

---

## 📚 Resources

### Official
- **Docs**: https://docs.deno.com
- **Standard Library**: https://deno.land/std
- **Third-party**: https://deno.land/x
- **Discord**: https://discord.gg/deno
- **Deploy**: https://deno.com/deploy

### Tutorials
- **Deno in 100 Seconds** - Fireship (YouTube)
- **Deno Crash Course** - Traversy Media
- **Official Tutorial** - docs.deno.com/runtime/tutorials

### Frameworks
- **Fresh**: Full-stack framework (like Next.js)
- **Oak**: Middleware framework (like Express)
- **Hono**: Fast web framework

---

## 🆚 Deno vs Node.js

| Feature | Deno | Node.js |
|---------|------|---------|
| TypeScript | ✅ Native | 🟡 Needs setup |
| Security | ✅ Secure by default | ❌ No restrictions |
| Imports | 🌐 URLs | 📦 npm/node_modules |
| Tools | ✅ All built-in | ❌ Separate installs |
| APIs | 🌍 Web standards | 🟡 Node-specific |
| Package manager | ✅ Not needed | 📦 npm/yarn/pnpm |
| Compatibility | ✅ Node modules | N/A |

---

## ✅ Checklist

### Setup
- [ ] Install Deno
- [ ] Configure VS Code
- [ ] Create first script
- [ ] Understand permissions
- [ ] Learn imports

### Core Skills
- [ ] HTTP server
- [ ] File operations
- [ ] Testing
- [ ] Formatting & linting
- [ ] Environment variables

### Advanced
- [ ] CLI tools
- [ ] Database integration
- [ ] Node.js packages
- [ ] Production deployment
- [ ] Performance optimization

---

## 💼 Career Impact

### Salary Boost
- **Deno expertise**: +$5-10K
- **Security-focused**: +$5-10K
- **Modern runtime**: Shows you're current

### Job Opportunities
- Backend Developer
- CLI Tool Developer
- Edge Computing Engineer
- Security-focused roles

### Companies Using
- Netlify (edge functions)
- Supabase (edge functions)
- Slack
- Many startups

---

## 🎯 Projects to Build

### Beginner
1. **CLI Todo App** - File-based storage
2. **REST API** - Simple CRUD
3. **File Watcher** - Monitor directory changes

### Intermediate
4. **URL Shortener** - With database
5. **Web Scraper** - Extract data from sites
6. **Chat Server** - WebSocket-based

### Advanced
7. **Full API Backend** - With authentication
8. **Static Site Generator** - Like Astro
9. **Development Tool** - Deployment automation

---

## 🚨 When to Use Deno

### ✅ Use Deno When:
- Building new projects
- Security is priority
- Want TypeScript by default
- Building CLI tools
- Edge/serverless deployment
- Want modern APIs

### 🟡 Use Node.js When:
- Legacy project
- Need specific npm package
- Team familiarity
- Large existing ecosystem needed

---

## 🔮 Future of Deno

### Roadmap
- ✅ Node.js compatibility (Done in 2.0)
- 🔜 Better npm support
- 🔜 More built-in tools
- 🔜 Performance improvements
- 🔜 Growing ecosystem

### Community
- 90,000+ GitHub stars
- Active development
- Strong backing (VC-funded)
- Growing adoption

---

## 🎉 Why Developers Love Deno

> "Node.js done right"

- **Secure**: Permissions by default
- **Simple**: No node_modules
- **Modern**: TypeScript & Web APIs
- **Complete**: All tools included
- **Fast**: Rust-powered

---

## 📝 Quick Reference

```bash
# Run
deno run script.ts
deno run --allow-all script.ts

# Permissions
--allow-net[=<allow-net>]      # Network
--allow-read[=<allow-read>]    # File read
--allow-write[=<allow-write>]  # File write
--allow-env[=<allow-env>]      # Environment
--allow-run[=<allow-run>]      # Subprocess
--allow-all                     # All permissions

# Tools
deno fmt                        # Format
deno lint                       # Lint
deno test                       # Test
deno bundle                     # Bundle
deno compile                    # Compile

# Tasks
deno task dev                   # Run task
deno cache --lock=lock.json     # Cache deps

# Install
deno install script.ts          # Install as command
```

---

**Last Updated**: January 2025  
**Status**: ✅ Complete Guide  
**Priority**: 🟡 High (Security-focused, modern runtime)

*Build secure applications with Deno! 🦕*