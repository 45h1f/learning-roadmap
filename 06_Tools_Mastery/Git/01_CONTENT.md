# Git Mastery - Complete Guide 🔧

> Master the most essential tool in software development - Git version control

**Last Updated**: 2025
**Difficulty**: Beginner to Advanced
**Time to Master**: 2-4 weeks

---

## 📋 Table of Contents

1. [What is Git?](#what-is-git)
2. [Why Git Matters](#why-git-matters)
3. [Installation](#installation)
4. [Core Concepts](#core-concepts)
5. [Basic Commands](#basic-commands)
6. [Branching & Merging](#branching--merging)
7. [Advanced Features](#advanced-features)
8. [Best Practices](#best-practices)
9. [Common Workflows](#common-workflows)
10. [Troubleshooting](#troubleshooting)

---

## What is Git?

**Git** is a distributed version control system that tracks changes in your code over time.

### Key Features:
- **Version Control**: Track every change to your files
- **Collaboration**: Multiple people can work on the same project
- **Branching**: Work on features independently
- **History**: See who changed what and when
- **Backup**: Your code is stored safely

### Git vs GitHub:
- **Git**: Version control system (software on your computer)
- **GitHub**: Cloud hosting service for Git repositories (website)
- **Other hosts**: GitLab, Bitbucket, Gitea

---

## Why Git Matters

### Industry Standard
- **100%** of professional developers use Git
- Required for **every** software job
- Used by all major tech companies

### Benefits
✅ Never lose code again
✅ Experiment safely with branches
✅ Collaborate without conflicts
✅ Track who made what changes
✅ Revert mistakes easily
✅ Code review process
✅ Open source contributions

---

## Installation

### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install git
```

### macOS
```bash
# Using Homebrew
brew install git

# Or download from: https://git-scm.com/
```

### Windows
```bash
# Download Git for Windows from: https://git-scm.com/
# Or use: winget install Git.Git
```

### Verify Installation
```bash
git --version
# Should output: git version 2.40.0 (or higher)
```

---

## Core Concepts

### 1. Repository (Repo)
A folder tracked by Git containing your project files and history.

```
my-project/
├── .git/          ← Git's internal folder (don't touch!)
├── src/
├── tests/
└── README.md
```

### 2. Commit
A snapshot of your project at a specific point in time.

**Anatomy of a commit:**
- **Hash**: Unique ID (e.g., `a3b5c2d`)
- **Author**: Who made the change
- **Date**: When it was made
- **Message**: What changed
- **Changes**: The actual code diff

### 3. Branch
An independent line of development.

```
main      ●────●────●────●
               \
feature        ●────●
```

### 4. Remote
A version of your repository hosted elsewhere (GitHub, GitLab, etc.)

### 5. Three States of Files

```
Working Directory → Staging Area → Repository
    (modified)      (staged)      (committed)
```

---

## Basic Commands

### Configuration (First Time Setup)

```bash
# Set your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default editor
git config --global core.editor "vim"  # or "code" for VS Code

# Set default branch name
git config --global init.defaultBranch main

# View all settings
git config --list

# View specific setting
git config user.name
```

### Creating a Repository

```bash
# Method 1: Start a new repository
mkdir my-project
cd my-project
git init
# Output: Initialized empty Git repository in .../my-project/.git/

# Method 2: Clone existing repository
git clone https://github.com/username/repo.git
cd repo
```

### Basic Workflow

```bash
# 1. Check status
git status
# Shows: modified files, staged files, untracked files

# 2. Add files to staging area
git add filename.txt          # Add specific file
git add .                     # Add all changes
git add *.js                  # Add all JavaScript files
git add src/                  # Add entire directory

# 3. Commit changes
git commit -m "Add feature X"
git commit -m "Fix bug in user authentication"

# 4. View history
git log
git log --oneline             # Compact view
git log --graph --all         # Visual branch graph

# 5. Push to remote
git push origin main
```

### Checking Status & Differences

```bash
# Status of working directory
git status
git status -s                 # Short format

# See what changed
git diff                      # Unstaged changes
git diff --staged             # Staged changes
git diff HEAD                 # All changes since last commit
git diff main feature         # Compare branches

# Show specific commit
git show a3b5c2d
git show HEAD~2               # 2 commits ago
```

---

## Branching & Merging

### Why Branches?

Branches let you:
- Work on features without affecting main code
- Experiment safely
- Collaborate on different features simultaneously
- Keep production code stable

### Branch Commands

```bash
# List branches
git branch                    # Local branches
git branch -a                 # All branches (including remote)
git branch -r                 # Remote branches only

# Create branch
git branch feature-login
git branch bugfix/issue-123

# Switch branch
git checkout feature-login
git switch feature-login      # Modern way (Git 2.23+)

# Create and switch in one command
git checkout -b feature-signup
git switch -c feature-signup  # Modern way

# Rename branch
git branch -m old-name new-name
git branch -m new-name        # Rename current branch

# Delete branch
git branch -d feature-login   # Safe delete (won't delete unmerged)
git branch -D feature-login   # Force delete
```

### Merging Branches

```bash
# Merge feature into main
git checkout main
git merge feature-login

# Merge strategies:
# 1. Fast-forward (no conflicts, linear history)
# 2. Three-way merge (creates merge commit)
# 3. Squash merge (combine all commits into one)

# Squash merge
git merge --squash feature-login
git commit -m "Add login feature"

# Abort merge if conflicts
git merge --abort
```

### Merge Conflicts

When Git can't automatically merge changes:

```bash
# After merge conflict
git status  # Shows conflicted files

# Open conflicted file, you'll see:
<<<<<<< HEAD
current code
=======
incoming code
>>>>>>> feature-branch

# Fix the conflict:
# 1. Edit file to resolve
# 2. Remove conflict markers
# 3. Keep the code you want

# Then:
git add resolved-file.js
git commit -m "Merge feature-branch and resolve conflicts"
```

---

## Advanced Features

### Rebasing

**Rebase** rewrites history to create a linear timeline.

```bash
# Rebase feature onto main
git checkout feature
git rebase main

# Interactive rebase (edit commits)
git rebase -i HEAD~3  # Last 3 commits

# In interactive mode:
# pick   = keep commit as is
# reword = change commit message
# edit   = pause to amend commit
# squash = combine with previous commit
# drop   = remove commit
```

**When to use:**
- ✅ Clean up local commits before pushing
- ✅ Update feature branch with latest main
- ❌ DON'T rebase public/shared branches

### Stashing

Save work temporarily without committing:

```bash
# Stash current changes
git stash
git stash save "WIP: implementing auth"

# List stashes
git stash list

# Apply stash
git stash apply              # Keep stash
git stash pop                # Apply and remove stash
git stash apply stash@{2}    # Apply specific stash

# Show stash contents
git stash show -p stash@{0}

# Delete stash
git stash drop stash@{0}
git stash clear              # Delete all stashes
```

### Cherry-Picking

Apply specific commits from one branch to another:

```bash
# Pick specific commit
git cherry-pick a3b5c2d

# Pick multiple commits
git cherry-pick a3b5c2d b4c6d3e

# Pick without committing (stage only)
git cherry-pick -n a3b5c2d
```

### Tagging

Mark important points in history (releases, versions):

```bash
# Create tag
git tag v1.0.0
git tag v1.0.0 -a -m "Release version 1.0.0"  # Annotated tag

# List tags
git tag
git tag -l "v1.*"  # Pattern matching

# Push tags
git push origin v1.0.0
git push origin --tags  # Push all tags

# Delete tag
git tag -d v1.0.0              # Local
git push origin :refs/tags/v1.0.0  # Remote
```

### Resetting & Reverting

```bash
# Reset (changes history - use carefully!)
git reset --soft HEAD~1   # Undo commit, keep changes staged
git reset --mixed HEAD~1  # Undo commit, unstage changes
git reset --hard HEAD~1   # Undo commit, discard changes

# Revert (safe - creates new commit)
git revert a3b5c2d        # Undo specific commit
git revert HEAD           # Undo last commit

# Unstage file
git reset HEAD filename.js
git restore --staged filename.js  # Modern way
```

### Searching History

```bash
# Search commits
git log --grep="bug fix"
git log --author="John"
git log --since="2 weeks ago"
git log --until="2025-01-01"

# Search code
git log -S "function_name"    # When function was added/removed
git log -G "regex pattern"    # Regex search

# Find who changed what
git blame filename.js
git blame -L 10,20 filename.js  # Specific lines

# Show file history
git log --follow filename.js
```

---

## Best Practices

### Commit Messages

**Good commit messages:**
```bash
git commit -m "Add user authentication with JWT tokens"
git commit -m "Fix memory leak in data processing module"
git commit -m "Update dependencies to latest versions"
```

**Bad commit messages:**
```bash
git commit -m "fix"
git commit -m "changes"
git commit -m "asdfasdf"
```

**Conventional Commits Format:**
```
<type>: <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting, missing semi-colons, etc.
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

**Examples:**
```bash
git commit -m "feat: add user profile page"
git commit -m "fix: resolve null pointer exception in auth"
git commit -m "docs: update API documentation"
```

### Branching Strategy

**Git Flow:**
```
main          ●────────●────────●  (production)
               \      /
develop         ●────●────●       (integration)
                 \  /
feature           ●●              (features)
```

**GitHub Flow (simpler):**
```
main          ●────●────●────●
               \  /  \  /
feature         ●●    ●●
```

**Branch Naming:**
```bash
feature/user-authentication
bugfix/login-error
hotfix/security-patch
release/v1.2.0
```

### .gitignore

Ignore files that shouldn't be tracked:

```bash
# Create .gitignore file
cat > .gitignore << EOF
# Dependencies
node_modules/
venv/
__pycache__/

# Environment variables
.env
.env.local

# Build outputs
dist/
build/
*.pyc

# IDE files
.vscode/
.idea/
*.swp

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/
EOF

git add .gitignore
git commit -m "Add .gitignore file"
```

---

## Common Workflows

### Feature Branch Workflow

```bash
# 1. Update main
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/add-comments

# 3. Work on feature
# ... make changes ...
git add .
git commit -m "feat: implement comment system"

# 4. Keep feature updated
git checkout main
git pull origin main
git checkout feature/add-comments
git rebase main

# 5. Push and create Pull Request
git push origin feature/add-comments
# Go to GitHub and create Pull Request

# 6. After PR is merged
git checkout main
git pull origin main
git branch -d feature/add-comments
```

### Hotfix Workflow

```bash
# 1. Create hotfix branch from main
git checkout main
git checkout -b hotfix/critical-bug

# 2. Fix the bug
# ... make changes ...
git commit -m "fix: resolve critical security vulnerability"

# 3. Merge to main
git checkout main
git merge hotfix/critical-bug
git push origin main

# 4. Tag the fix
git tag v1.2.1
git push origin v1.2.1

# 5. Merge back to develop if using Git Flow
git checkout develop
git merge hotfix/critical-bug
git push origin develop

# 6. Delete hotfix branch
git branch -d hotfix/critical-bug
```

### Updating Fork

```bash
# 1. Add upstream remote (original repo)
git remote add upstream https://github.com/original/repo.git

# 2. Fetch upstream changes
git fetch upstream

# 3. Merge upstream into your fork
git checkout main
git merge upstream/main

# 4. Push to your fork
git push origin main
```

---

## Troubleshooting

### Undo Last Commit (Not Pushed)

```bash
# Keep changes, undo commit
git reset --soft HEAD~1

# Undo commit and changes
git reset --hard HEAD~1
```

### Undo Pushed Commit

```bash
# Create revert commit (safe)
git revert HEAD
git push origin main

# Force push (dangerous - only if alone)
git reset --hard HEAD~1
git push origin main --force
```

### Recover Deleted Branch

```bash
# Find commit hash
git reflog

# Recreate branch
git checkout -b recovered-branch a3b5c2d
```

### Fix Wrong Branch

```bash
# Move commits to correct branch
git log --oneline  # Find commit hashes

git checkout correct-branch
git cherry-pick a3b5c2d b4c6d3e

git checkout wrong-branch
git reset --hard HEAD~2
```

### Merge vs Rebase: Which to Use?

**Use Merge when:**
- Working on public/shared branches
- Want to preserve complete history
- Multiple people on same branch

**Use Rebase when:**
- Cleaning up local commits
- Updating feature branch
- Want linear history

### Large File Issues

```bash
# Remove file from Git history
git filter-branch --tree-filter 'rm -f path/to/large-file' HEAD

# Or use BFG Repo Cleaner (faster)
# Download from: https://rtyley.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files large-file.zip
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Authentication Issues

```bash
# Use SSH instead of HTTPS
git remote set-url origin git@github.com:username/repo.git

# Generate SSH key
ssh-keygen -t ed25519 -C "your.email@example.com"
# Add to GitHub: Settings → SSH Keys

# Or use personal access token
# GitHub: Settings → Developer settings → Personal access tokens
```

---

## Essential Git Aliases

Add to `~/.gitconfig`:

```bash
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = log --graph --oneline --all
    amend = commit --amend --no-edit
    undo = reset --soft HEAD~1
```

Usage:
```bash
git st          # Instead of git status
git co main     # Instead of git checkout main
git visual      # Pretty graph view
```

---

## Advanced Tips

### Useful Commands

```bash
# Show all changes in working directory
git diff

# Show changes in specific file
git diff filename.js

# Show file at specific commit
git show a3b5c2d:path/to/file.js

# Find when bug was introduced
git bisect start
git bisect bad         # Current version is bad
git bisect good v1.0   # v1.0 was good
# Git will checkout commits for you to test
git bisect bad         # If current is bad
git bisect good        # If current is good
# Repeat until found
git bisect reset       # End bisect

# Clean untracked files
git clean -n           # Dry run (see what would be deleted)
git clean -fd          # Delete untracked files and directories

# Archive repository
git archive --format=zip --output=project.zip main
```

### Git Hooks

Automate tasks on Git events:

```bash
# Location: .git/hooks/

# pre-commit: Run before commit
#!/bin/bash
npm test || exit 1

# pre-push: Run before push
#!/bin/bash
npm run lint || exit 1

# Make executable
chmod +x .git/hooks/pre-commit
```

---

## Git Cheat Sheet

```bash
# Setup
git config --global user.name "name"
git config --global user.email "email"
git init
git clone <url>

# Basic
git status
git add <file>
git add .
git commit -m "message"
git push origin <branch>
git pull origin <branch>

# Branching
git branch
git branch <name>
git checkout <branch>
git checkout -b <branch>
git merge <branch>
git branch -d <branch>

# Remote
git remote -v
git remote add origin <url>
git remote remove origin
git fetch
git pull
git push

# History
git log
git log --oneline
git log --graph
git diff
git show <commit>

# Undo
git reset HEAD <file>
git checkout -- <file>
git reset --soft HEAD~1
git reset --hard HEAD~1
git revert <commit>

# Stash
git stash
git stash list
git stash pop
git stash apply

# Tags
git tag
git tag <name>
git tag -a <name> -m "message"
git push origin <tag>
```

---

## Learning Resources

### Official Documentation
- https://git-scm.com/doc
- https://git-scm.com/book/en/v2

### Interactive Learning
- https://learngitbranching.js.org/
- https://www.katacoda.com/courses/git

### Practice
- Create multiple branches and merge them
- Intentionally create conflicts and resolve
- Practice rebasing
- Contribute to open source projects

### Videos
- Git & GitHub Crash Course (freeCodeCamp)
- Git Tutorial for Beginners (Programming with Mosh)

---

## Next Steps

After mastering Git:
1. ✅ Complete the exercises in `02_EXERCISES.md`
2. ✅ Review code examples in `03_CODE_EXAMPLES.md`
3. ✅ Practice with real projects
4. ✅ Learn GitHub Actions for CI/CD
5. ✅ Contribute to open source

---

## Common Mistakes to Avoid

❌ Committing directly to main
❌ Large commits with many changes
❌ Vague commit messages
❌ Not pulling before pushing
❌ Force pushing on shared branches
❌ Committing sensitive data (passwords, API keys)
❌ Not using .gitignore

---

**Congratulations! You're on your way to Git mastery!** 🎉

Practice daily, and Git will become second nature. See you in the exercises!