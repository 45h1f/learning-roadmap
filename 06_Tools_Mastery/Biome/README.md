# 🌿 Biome - Ultra-Fast Linter & Formatter

**One tool to replace ESLint + Prettier (100x faster!)**

---

## 📋 Overview

**Biome** is a performant toolchain for web development, written in Rust. It provides fast, zero-config linting and formatting for JavaScript, TypeScript, JSX, and JSON.

**Key Features:**
- ⚡ **100x faster** than ESLint
- 🎯 **One tool** replaces ESLint + Prettier
- 🚀 **Zero dependencies**
- 📝 **Better error messages**
- 🔧 **Auto-fix** by default
- 💻 **IDE integration** (VS Code, others)

**Release:** 2023 (Formerly "Rome Tools")  
**Language:** Rust  
**GitHub:** https://github.com/biomejs/biome  
**Stars:** 10,000+

---

## 🔥 Why Learn Biome?

### Performance Benefits
- ⚡ Lints 100k lines in **milliseconds**
- 🚀 100x faster than ESLint
- ⏱️ Instant feedback in IDE
- 💪 Handles monorepos easily

### Developer Experience
- 🎯 **One tool** instead of two (ESLint + Prettier)
- 🔧 **Zero config** to get started
- 📝 **Clear error messages**
- 🔄 **Auto-fix** everything
- 💰 **Less dependencies** in package.json

### Why Switch?
```
ESLint + Prettier Setup:
- 2 config files
- 50+ dependencies
- ~2 seconds to lint
- Setup complexity

Biome Setup:
- 1 config file (optional)
- 1 dependency
- ~20ms to lint
- Works out of the box
```

---

## 🚀 Quick Start

### Installation
```bash
# Install Biome
npm install --save-dev --save-exact @biomejs/biome

# Or with Bun
bun add -d @biomejs/biome

# Initialize (creates biome.json)
npx @biomejs/biome init
```

### Basic Commands
```bash
# Format files
npx @biomejs/biome format --write ./src

# Lint files
npx @biomejs/biome lint ./src

# Check everything (lint + format)
npx @biomejs/biome check --apply ./src

# CI mode (no fixes)
npx @biomejs/biome ci ./src
```

### Add to package.json
```json
{
  "scripts": {
    "format": "biome format --write .",
    "lint": "biome lint .",
    "check": "biome check --apply .",
    "ci": "biome ci ."
  }
}
```

---

## ⚙️ Configuration

### biome.json (Optional)
```json
{
  "$schema": "https://biomejs.dev/schemas/1.5.0/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "style": {
        "noNonNullAssertion": "off"
      },
      "suspicious": {
        "noExplicitAny": "warn"
      }
    }
  },
  "formatter": {
    "enabled": true,
    "formatWithErrors": false,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 80,
    "lineEnding": "lf"
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "trailingComma": "es5",
      "semicolons": "always",
      "arrowParentheses": "always"
    }
  },
  "files": {
    "ignore": [
      "node_modules",
      "dist",
      "build",
      ".next",
      "coverage"
    ]
  }
}
```

### Minimal Config
```json
{
  "formatter": {
    "indentWidth": 2
  },
  "linter": {
    "rules": {
      "recommended": true
    }
  }
}
```

---

## 💻 IDE Integration

### VS Code
```bash
# Install extension
# Search "Biome" in VS Code extensions
# Extension ID: biomejs.biome
```

#### settings.json
```json
{
  "[javascript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[typescript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[json]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "quickfix.biome": "explicit",
    "source.organizeImports.biome": "explicit"
  }
}
```

### Other IDEs
- **IntelliJ/WebStorm**: Plugin available
- **Neovim**: LSP support
- **Sublime Text**: Package available

---

## 🎯 Features Deep Dive

### 1. Formatting
```bash
# Format all files
biome format --write .

# Check formatting (no changes)
biome format .

# Format specific files
biome format --write src/index.ts src/app.ts

# Format stdin
echo "const x=1" | biome format --stdin-file-path=test.js
```

**What gets formatted:**
- JavaScript/TypeScript
- JSX/TSX
- JSON
- More coming soon

### 2. Linting
```bash
# Lint files
biome lint ./src

# Lint and auto-fix
biome lint --apply ./src

# Lint with specific rules
biome lint --apply-unsafe ./src

# Explain a rule
biome explain noUnusedVariables
```

**Rules Categories:**
- `a11y` - Accessibility
- `complexity` - Code complexity
- `correctness` - Logical errors
- `performance` - Performance issues
- `security` - Security vulnerabilities
- `style` - Code style
- `suspicious` - Suspicious patterns

### 3. Import Sorting
```typescript
// Before
import { z } from 'zod';
import React from 'react';
import { Button } from './components/Button';
import type { User } from './types';

// After (automatic)
import React from 'react';
import type { User } from './types';
import { z } from 'zod';

import { Button } from './components/Button';
```

### 4. Check Command (All-in-One)
```bash
# Lint + Format + Organize Imports
biome check --apply ./src

# This replaces:
# eslint --fix .
# prettier --write .
# organize-imports-cli
```

---

## 🔄 Migration from ESLint + Prettier

### Step 1: Remove Old Tools
```bash
# Uninstall ESLint + Prettier
npm uninstall eslint prettier \
  eslint-config-prettier \
  eslint-plugin-react \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser
```

### Step 2: Install Biome
```bash
npm install --save-dev --save-exact @biomejs/biome
npx @biomejs/biome init
```

### Step 3: Migrate Config
```bash
# Biome can help migrate (experimental)
npx @biomejs/biome migrate eslint --write
npx @biomejs/biome migrate prettier --write
```

### Step 4: Update Scripts
```json
{
  "scripts": {
    "format": "biome format --write .",
    "lint": "biome lint --apply .",
    "check": "biome check --apply .",
    "ci": "biome ci ."
  }
}
```

### Step 5: Delete Old Config Files
```bash
rm .eslintrc.js .prettierrc .prettierignore
```

### Step 6: Update CI/CD
```yaml
# .github/workflows/ci.yml
- name: Run Biome
  run: npm run ci
```

---

## 🎓 Learning Path

### Day 1: Install & Setup
- [ ] Install Biome in project
- [ ] Run `biome init`
- [ ] Format codebase
- [ ] Configure VS Code

### Day 2: Learn Commands
- [ ] `biome format`
- [ ] `biome lint`
- [ ] `biome check`
- [ ] Understand flags

### Day 3: Configuration
- [ ] Customize biome.json
- [ ] Set up rules
- [ ] Configure formatter
- [ ] Test in IDE

### Week 2: Migration
- [ ] Remove ESLint + Prettier
- [ ] Migrate configs
- [ ] Update CI/CD
- [ ] Train team

**Time to Learn:** 1-2 days  
**Migration Time:** 2-4 hours

---

## 📊 Performance Comparison

### Lint Time (100k lines of code)
```
ESLint:     ~2,000ms
Biome:      ~20ms

Speed: 100x faster! ⚡
```

### Format Time
```
Prettier:   ~500ms
Biome:      ~10ms

Speed: 50x faster! ⚡
```

### Memory Usage
```
ESLint + Prettier: ~500MB
Biome:            ~50MB

10x less memory!
```

---

## 🛠️ Real-World Examples

### Next.js Project
```json
{
  "$schema": "https://biomejs.dev/schemas/1.5.0/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "rules": {
      "recommended": true,
      "correctness": {
        "useExhaustiveDependencies": "warn"
      }
    }
  },
  "formatter": {
    "indentWidth": 2,
    "lineWidth": 100
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "semicolons": "always"
    }
  },
  "files": {
    "ignore": [".next", "node_modules"]
  }
}
```

### React + TypeScript
```json
{
  "linter": {
    "rules": {
      "recommended": true,
      "suspicious": {
        "noExplicitAny": "error"
      },
      "correctness": {
        "noUnusedVariables": "error"
      }
    }
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "double",
      "trailingComma": "all"
    }
  }
}
```

### Monorepo
```json
{
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "style": {
        "useImportType": "error"
      }
    }
  }
}
```

---

## 🔧 CI/CD Integration

### GitHub Actions
```yaml
name: CI

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Bun
        uses: oven-sh/setup-bun@v1
      
      - name: Install dependencies
        run: bun install
      
      - name: Run Biome
        run: bun run ci
```

### Pre-commit Hook
```bash
# Install husky
npm install --save-dev husky

# Add pre-commit hook
npx husky add .husky/pre-commit "npm run check"
```

### lint-staged
```json
{
  "lint-staged": {
    "*.{js,ts,jsx,tsx,json}": [
      "biome check --apply --no-errors-on-unmatched"
    ]
  }
}
```

---

## 💡 Pro Tips

1. **Use `check` command** - Runs everything at once
2. **Enable IDE integration** - Instant feedback
3. **Start with recommended rules** - Then customize
4. **Use in CI** - `biome ci` for checks without fixes
5. **Organize imports** - Enable in config
6. **Monorepo support** - Extend configs
7. **Explain rules** - `biome explain <rule>`
8. **Safe vs unsafe fixes** - Be careful with `--apply-unsafe`

---

## ⚠️ Current Limitations

### Not Yet Supported
- ❌ Plugins (no custom rules yet)
- ❌ CSS/SCSS formatting
- ❌ Vue/Svelte (coming soon)
- ❌ Some ESLint rules (90%+ covered)

### Workarounds
- **Custom rules**: Wait for plugin system
- **CSS**: Use Prettier for now
- **Vue**: Use Volar/Vetur

**Note:** Biome is rapidly evolving. Check docs for updates!

---

## 📚 Resources

### Official
- **Docs**: https://biomejs.dev/
- **GitHub**: https://github.com/biomejs/biome
- **Discord**: https://discord.gg/BypW39g6Yc
- **Playground**: https://biomejs.dev/playground

### Tutorials
- **Biome Guide** - Official docs (comprehensive)
- **Migrating from ESLint** - Official guide
- **Theo's Review** - YouTube (t3.gg)

### Comparison
- **Biome vs ESLint**: https://biomejs.dev/internals/benchmarks/
- **Migration Guide**: https://biomejs.dev/guides/migrate-eslint-prettier/

---

## ✅ Checklist

### Setup
- [ ] Install Biome
- [ ] Run `biome init`
- [ ] Configure VS Code
- [ ] Test formatting
- [ ] Test linting

### Configuration
- [ ] Customize rules
- [ ] Set formatter options
- [ ] Configure ignore files
- [ ] Enable import sorting

### Migration (if applicable)
- [ ] Remove ESLint
- [ ] Remove Prettier
- [ ] Migrate config
- [ ] Update scripts
- [ ] Update CI/CD

### Team Adoption
- [ ] Document setup
- [ ] Share config
- [ ] Update contributing guide
- [ ] Train team members

---

## 💼 Career Impact

### Why It Matters
- **Faster development** - Instant feedback
- **Less complexity** - One tool instead of many
- **Modern skill** - Shows you're up-to-date
- **Better DX** - Improved developer experience

### Salary Impact
- **Biome experience**: +$2-5K (emerging skill)
- **Modern tooling**: Signals up-to-date developer
- **Performance-focused**: Valued by companies

---

## 🆚 Biome vs Others

### Biome vs ESLint
| Feature | Biome | ESLint |
|---------|-------|--------|
| Speed | ⚡⚡⚡ 100x faster | 🐌 Slow |
| Setup | 🎯 Zero config | 😓 Complex |
| Rules | 🟡 90%+ | 🟢 100% |
| Plugins | ❌ Not yet | ✅ Yes |
| Format | ✅ Built-in | ❌ Need Prettier |

### Biome vs Prettier
| Feature | Biome | Prettier |
|---------|-------|----------|
| Speed | ⚡⚡⚡ 50x faster | 🐌 Slower |
| Lint | ✅ Yes | ❌ No |
| Config | ✅ JSON | ✅ Many formats |
| Languages | 🟡 JS/TS/JSON | 🟢 Many |

### When to Use Biome
✅ TypeScript/JavaScript projects  
✅ Want speed  
✅ New projects  
✅ Tired of config complexity  
✅ Monorepos  

### When to Stick with ESLint/Prettier
❌ Need specific ESLint plugins  
❌ Need CSS/SCSS formatting  
❌ Need Vue/Svelte support  
❌ Large team resistant to change  

---

## 🎯 Projects to Try

### Beginner
1. **Format existing project**
   - Install Biome
   - Run format on all files
   - See the difference

### Intermediate
2. **Migrate Next.js app**
   - Remove ESLint + Prettier
   - Set up Biome
   - Configure rules

### Advanced
3. **Monorepo setup**
   - Root config
   - Package-specific configs
   - CI/CD integration

---

## 🚀 Future of Biome

### Roadmap
- 🔜 Plugin system
- 🔜 CSS/SCSS support
- 🔜 Vue/Svelte support
- 🔜 More linting rules
- 🔜 Auto-fix improvements

### Community
- Growing fast (10,000+ stars)
- Active development
- Strong backing
- Great documentation

---

## 🎉 Why Developers Love Biome

> "Finally, a tool that just works!"

- **Fast**: 100x faster
- **Simple**: One tool, zero config
- **Modern**: Built with Rust
- **Reliable**: Consistent results
- **Developer-friendly**: Great error messages

---

## 📝 Quick Reference

```bash
# Common commands
biome format --write .           # Format all
biome lint --apply .             # Lint and fix
biome check --apply .            # Format + Lint + Organize
biome ci .                       # CI check (no fixes)

# Flags
--write                          # Write changes
--apply                          # Apply safe fixes
--apply-unsafe                   # Apply all fixes
--changed                        # Only changed files (git)
--staged                         # Only staged files (git)
--no-errors-on-unmatched        # Don't fail on no matches

# Config
biome init                       # Create biome.json
biome explain <rule>             # Explain a rule
biome migrate eslint             # Migrate from ESLint
```

---

**Last Updated**: January 2025  
**Status**: ✅ Complete Guide  
**Priority**: 🟢 Medium (Great for new projects)

*Make your development 100x faster with Biome! 🌿*