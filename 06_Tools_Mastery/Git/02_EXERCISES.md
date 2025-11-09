# Git Exercises & Practice Challenges 🎯

> Hands-on exercises to master Git through practice

**Difficulty Levels**: 🟢 Beginner | 🟡 Intermediate | 🔴 Advanced

---

## 📋 Table of Contents

1. [Setup Exercises](#setup-exercises)
2. [Basic Git Operations](#basic-git-operations)
3. [Branching Exercises](#branching-exercises)
4. [Merge Conflict Resolution](#merge-conflict-resolution)
5. [Advanced Git](#advanced-git)
6. [Real-World Scenarios](#real-world-scenarios)
7. [Challenge Projects](#challenge-projects)

---

## Setup Exercises

### Exercise 1.1: Install and Configure Git 🟢

**Goal**: Set up Git on your machine

**Tasks**:
```bash
# 1. Verify Git installation
git --version

# 2. Configure your identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 3. Set default editor
git config --global core.editor "vim"  # or "code" for VS Code

# 4. Set default branch name
git config --global init.defaultBranch main

# 5. Enable colored output
git config --global color.ui auto

# 6. View all configuration
git config --list

# 7. View specific config
git config user.name
git config user.email
```

**Validation**:
- [ ] Git version is 2.30 or higher
- [ ] User name is set correctly
- [ ] User email is set correctly
- [ ] Default branch is 'main'

---

### Exercise 1.2: Create Your First Repository 🟢

**Goal**: Initialize a Git repository

**Tasks**:
```bash
# 1. Create project directory
mkdir my-first-repo
cd my-first-repo

# 2. Initialize Git
git init

# 3. Check status
git status

# 4. Create a README
echo "# My First Repository" > README.md

# 5. Add file to staging
git add README.md

# 6. Check status again
git status

# 7. Make first commit
git commit -m "Initial commit: Add README"

# 8. View commit history
git log
```

**Expected Output**:
```
Initialized empty Git repository in .../my-first-repo/.git/
On branch main
nothing to commit, working tree clean
```

**Validation**:
- [ ] `.git` folder exists
- [ ] README.md is committed
- [ ] `git log` shows your commit

---

## Basic Git Operations

### Exercise 2.1: Stage and Commit Files 🟢

**Goal**: Practice basic Git workflow

**Setup**:
```bash
mkdir git-basics
cd git-basics
git init
```

**Tasks**:
```bash
# 1. Create multiple files
echo "console.log('Hello');" > app.js
echo "body { margin: 0; }" > style.css
echo "<!DOCTYPE html>" > index.html

# 2. Check status (should show untracked files)
git status

# 3. Stage only JavaScript file
git add app.js

# 4. Check status again
git status

# 5. Stage remaining files
git add style.css index.html

# 6. Commit all staged files
git commit -m "Add HTML, CSS, and JavaScript files"

# 7. Create a .gitignore file
echo "node_modules/" > .gitignore
echo "*.log" >> .gitignore
echo ".env" >> .gitignore

# 8. Stage and commit .gitignore
git add .gitignore
git commit -m "Add .gitignore file"

# 9. View commit history
git log --oneline
```

**Challenge**:
- Modify `app.js` to add more code
- Stage and commit the change
- Use `git diff` to see what changed

**Validation**:
- [ ] All files are committed
- [ ] `.gitignore` exists and is committed
- [ ] `git log` shows 2+ commits

---

### Exercise 2.2: Viewing History 🟢

**Goal**: Learn to navigate Git history

**Tasks**:
```bash
# Starting from previous exercise

# 1. View full log
git log

# 2. View compact log
git log --oneline

# 3. View log with graph
git log --graph --oneline --all

# 4. View last 3 commits
git log -3

# 5. View commits by author
git log --author="Your Name"

# 6. View commits with diffs
git log -p

# 7. View specific file history
git log -- app.js

# 8. Show specific commit
git show HEAD
git show HEAD~1  # Previous commit
git show HEAD~2  # 2 commits ago

# 9. View changes in working directory
git diff

# 10. View staged changes
git diff --staged
```

**Challenge Questions**:
1. What is the hash of your first commit?
2. How many commits have you made?
3. What files were changed in the last commit?

---

### Exercise 2.3: Undoing Changes 🟡

**Goal**: Learn to undo mistakes

**Setup**:
```bash
echo "const x = 1;" >> app.js
git add app.js
git commit -m "Add variable"
```

**Tasks**:

**Scenario 1: Unstage a file**
```bash
echo "const y = 2;" >> app.js
git add app.js
git status  # File is staged

# Unstage the file
git restore --staged app.js
# or: git reset HEAD app.js

git status  # File is now unstaged
```

**Scenario 2: Discard working directory changes**
```bash
echo "const z = 3;" >> app.js
git status  # File is modified

# Discard changes
git restore app.js
# or: git checkout -- app.js

git status  # File is clean
```

**Scenario 3: Undo last commit (keep changes)**
```bash
git log --oneline
git reset --soft HEAD~1
git status  # Changes are staged
```

**Scenario 4: Undo last commit (discard changes)**
```bash
git reset --hard HEAD~1
git status  # Working directory is clean
```

**Scenario 5: Revert a commit (safe way)**
```bash
git revert HEAD
# This creates a new commit that undoes the previous one
```

**Validation**:
- [ ] Can unstage files
- [ ] Can discard working directory changes
- [ ] Understand difference between reset and revert

---

## Branching Exercises

### Exercise 3.1: Create and Switch Branches 🟢

**Goal**: Master branch operations

**Setup**:
```bash
mkdir branching-practice
cd branching-practice
git init
echo "# Main Branch" > README.md
git add README.md
git commit -m "Initial commit"
```

**Tasks**:
```bash
# 1. List branches
git branch

# 2. Create new branch
git branch feature-1

# 3. List branches again (notice * next to current branch)
git branch

# 4. Switch to new branch
git checkout feature-1
# or: git switch feature-1

# 5. Confirm current branch
git branch

# 6. Create and switch in one command
git checkout -b feature-2
# or: git switch -c feature-2

# 7. Create multiple branches
git checkout main
git branch feature-3
git branch bugfix-1
git branch hotfix-1

# 8. List all branches
git branch

# 9. Rename a branch
git branch -m bugfix-1 bugfix/login-error

# 10. Delete a branch
git branch -d feature-3
```

**Validation**:
- [ ] Can create branches
- [ ] Can switch between branches
- [ ] Can rename branches
- [ ] Can delete branches

---

### Exercise 3.2: Working with Branches 🟡

**Goal**: Make changes in different branches

**Tasks**:

**Branch 1: Feature Development**
```bash
# Switch to main
git checkout main

# Create feature branch
git checkout -b feature/add-footer

# Make changes
echo "<footer>Copyright 2025</footer>" > footer.html
git add footer.html
git commit -m "feat: add footer component"

# Make more changes
echo "footer { padding: 20px; }" > footer.css
git add footer.css
git commit -m "style: add footer styles"

# View log
git log --oneline
```

**Branch 2: Bug Fix**
```bash
# Switch to main
git checkout main

# Create bugfix branch
git checkout -b bugfix/header-alignment

# Make changes
echo "header { text-align: center; }" > header-fix.css
git add header-fix.css
git commit -m "fix: center header alignment"

# View log
git log --oneline
```

**Branch 3: Documentation**
```bash
# Switch to main
git checkout main

# Create docs branch
git checkout -b docs/update-readme

# Update README
echo "## Installation" >> README.md
echo "npm install" >> README.md
git add README.md
git commit -m "docs: add installation instructions"
```

**Visualization Exercise**:
```bash
# View all branches with graph
git log --graph --oneline --all

# Compare branches
git diff main feature/add-footer
git diff main bugfix/header-alignment
```

**Validation**:
- [ ] Created 3 different branches
- [ ] Each branch has its own commits
- [ ] Main branch is unchanged
- [ ] Can visualize branch structure

---

### Exercise 3.3: Merging Branches 🟡

**Goal**: Practice different merge strategies

**Setup**:
Use branches from previous exercise

**Task 1: Fast-Forward Merge**
```bash
# Switch to main
git checkout main

# Merge feature branch (fast-forward)
git merge feature/add-footer

# View history
git log --oneline --graph

# Verify files are merged
ls -la
```

**Task 2: Three-Way Merge**
```bash
# Make a commit on main
echo "<!-- Main update -->" >> README.md
git add README.md
git commit -m "Update README on main"

# Now merge bugfix (will create merge commit)
git merge bugfix/header-alignment

# View history
git log --oneline --graph
```

**Task 3: Squash Merge**
```bash
# Squash all commits from docs branch into one
git merge --squash docs/update-readme

# Create the squash commit
git commit -m "docs: merge documentation updates"

# View history
git log --oneline --graph
```

**Validation**:
- [ ] Fast-forward merge completed
- [ ] Three-way merge completed
- [ ] Squash merge completed
- [ ] All changes are in main branch

---

## Merge Conflict Resolution

### Exercise 4.1: Create and Resolve Conflicts 🟡

**Goal**: Learn to handle merge conflicts

**Setup**:
```bash
mkdir conflict-practice
cd conflict-practice
git init

# Create initial file
cat > app.js << 'EOF'
function greet(name) {
    return "Hello";
}

console.log(greet("World"));
EOF

git add app.js
git commit -m "Initial commit"
```

**Creating a Conflict**:
```bash
# Branch 1: Modify greeting
git checkout -b feature/formal-greeting
cat > app.js << 'EOF'
function greet(name) {
    return "Good day, " + name;
}

console.log(greet("World"));
EOF
git add app.js
git commit -m "Use formal greeting"

# Back to main, make different change
git checkout main
cat > app.js << 'EOF'
function greet(name) {
    return "Hey there, " + name + "!";
}

console.log(greet("World"));
EOF
git add app.js
git commit -m "Use casual greeting"

# Try to merge (will conflict!)
git merge feature/formal-greeting
```

**Resolving the Conflict**:
```bash
# 1. Check status
git status

# 2. View conflicted file
cat app.js

# You'll see conflict markers:
# <<<<<<< HEAD
# Your current code
# =======
# Incoming code
# >>>>>>> feature/formal-greeting

# 3. Edit the file to resolve
# Remove markers and choose/combine code
cat > app.js << 'EOF'
function greet(name) {
    return "Hello, " + name + "!";
}

console.log(greet("World"));
EOF

# 4. Stage the resolved file
git add app.js

# 5. Complete the merge
git commit -m "Merge feature/formal-greeting and resolve conflicts"

# 6. View result
git log --oneline --graph
```

**Validation**:
- [ ] Successfully created a conflict
- [ ] Resolved the conflict manually
- [ ] Completed the merge
- [ ] Code works after merge

---

### Exercise 4.2: Multiple File Conflicts 🔴

**Goal**: Handle complex conflict scenarios

**Setup**:
```bash
mkdir complex-conflict
cd complex-conflict
git init

# Create multiple files
echo "const API_URL = 'http://localhost:3000';" > config.js
echo "const VERSION = '1.0.0';" > version.js
echo "# App" > README.md

git add .
git commit -m "Initial setup"
```

**Tasks**:
```bash
# Branch 1: Update config and version
git checkout -b feature/production-ready
echo "const API_URL = 'https://api.production.com';" > config.js
echo "const VERSION = '2.0.0';" > version.js
echo "## Production Release" >> README.md
git add .
git commit -m "Prepare for production"

# Branch 2: Different updates on main
git checkout main
echo "const API_URL = 'https://api.staging.com';" > config.js
echo "const VERSION = '1.5.0';" > version.js
echo "## Features" >> README.md
git add .
git commit -m "Update for staging"

# Merge and resolve conflicts
git merge feature/production-ready

# Status will show multiple conflicted files
git status

# Resolve each file
# config.js - choose production URL
echo "const API_URL = 'https://api.production.com';" > config.js

# version.js - keep higher version
echo "const VERSION = '2.0.0';" > version.js

# README.md - combine both sections
cat > README.md << 'EOF'
# App

## Features

## Production Release
EOF

# Stage all resolved files
git add .

# Complete merge
git commit -m "Merge production-ready and resolve all conflicts"
```

**Validation**:
- [ ] Resolved multiple file conflicts
- [ ] All conflicts addressed
- [ ] Merge completed successfully

---

## Advanced Git

### Exercise 5.1: Interactive Rebase 🔴

**Goal**: Clean up commit history

**Setup**:
```bash
mkdir rebase-practice
cd rebase-practice
git init

# Create several messy commits
echo "line 1" > file.txt
git add file.txt
git commit -m "add file"

echo "line 2" >> file.txt
git add file.txt
git commit -m "fix typo"

echo "line 3" >> file.txt
git add file.txt
git commit -m "wip"

echo "line 4" >> file.txt
git add file.txt
git commit -m "more changes"

echo "line 5" >> file.txt
git add file.txt
git commit -m "final touches"
```

**Tasks**:
```bash
# View current history
git log --oneline

# Start interactive rebase on last 5 commits
git rebase -i HEAD~5

# In the editor, you'll see:
# pick abc1234 add file
# pick def5678 fix typo
# pick ghi9012 wip
# pick jkl3456 more changes
# pick mno7890 final touches

# Change to:
# pick abc1234 add file
# squash def5678 fix typo
# squash ghi9012 wip
# squash jkl3456 more changes
# squash mno7890 final touches

# Save and exit
# Edit the combined commit message

# View cleaned history
git log --oneline
```

**Additional Rebase Tasks**:
```bash
# Reword a commit message
git rebase -i HEAD~3
# Change 'pick' to 'reword' for commits you want to rename

# Drop a commit
git rebase -i HEAD~3
# Change 'pick' to 'drop' for commits to remove

# Reorder commits
git rebase -i HEAD~3
# Just change the order of lines
```

**Validation**:
- [ ] Successfully squashed commits
- [ ] Reworded commit messages
- [ ] Understand interactive rebase options

---

### Exercise 5.2: Stashing Changes 🟡

**Goal**: Save and restore work in progress

**Setup**:
```bash
mkdir stash-practice
cd stash-practice
git init
echo "version 1" > app.js
git add app.js
git commit -m "Initial version"
```

**Tasks**:

**Scenario 1: Basic Stash**
```bash
# Start working on feature
echo "version 2 WIP" > app.js
echo "new feature" > feature.js

# Urgent bug fix needed!
git status  # You have uncommitted changes

# Stash your work
git stash save "WIP: implementing new feature"

# Working directory is now clean
git status

# Fix the bug
echo "bug fixed" > bugfix.js
git add bugfix.js
git commit -m "Fix critical bug"

# Restore your work
git stash pop

# Continue working
git status
```

**Scenario 2: Multiple Stashes**
```bash
# Clean up
git add .
git commit -m "Complete feature"

# Create stash 1
echo "work 1" >> file1.txt
git stash save "Work on file 1"

# Create stash 2
echo "work 2" >> file2.txt
git stash save "Work on file 2"

# Create stash 3
echo "work 3" >> file3.txt
git stash save "Work on file 3"

# List all stashes
git stash list

# Apply specific stash
git stash apply stash@{1}

# View stash contents
git stash show -p stash@{0}

# Delete specific stash
git stash drop stash@{0}

# Clear all stashes
git stash clear
```

**Validation**:
- [ ] Can stash changes
- [ ] Can list stashes
- [ ] Can apply specific stash
- [ ] Can clear stashes

---

### Exercise 5.3: Cherry-Picking 🔴

**Goal**: Apply specific commits from other branches

**Setup**:
```bash
mkdir cherry-pick-practice
cd cherry-pick-practice
git init
echo "main content" > main.txt
git add main.txt
git commit -m "Initial commit"
```

**Tasks**:
```bash
# Create feature branch with multiple commits
git checkout -b feature/multi-changes

echo "change 1" > change1.txt
git add change1.txt
git commit -m "Add change 1"

echo "change 2" > change2.txt
git add change2.txt
git commit -m "Add change 2"

echo "change 3" > change3.txt
git add change3.txt
git commit -m "Add change 3"

# View commits
git log --oneline

# Switch to main
git checkout main

# Cherry-pick only change 2
git cherry-pick <commit-hash-of-change-2>

# Verify
ls -la  # Should have change2.txt but not change1 or change3
git log --oneline

# Cherry-pick multiple commits
git cherry-pick <hash1> <hash2>

# Cherry-pick range
git cherry-pick <start-hash>^..<end-hash>
```

**Validation**:
- [ ] Successfully cherry-picked specific commit
- [ ] Main has only selected changes
- [ ] Feature branch unchanged

---

## Real-World Scenarios

### Exercise 6.1: Team Collaboration Workflow 🟡

**Goal**: Simulate real team collaboration

**Scenario**: You're working on a team project

**Tasks**:
```bash
# Day 1: Start new feature
git checkout main
git pull origin main
git checkout -b feature/user-profile

# Make changes
mkdir user-profile
echo "User profile component" > user-profile/index.js
git add user-profile/
git commit -m "feat: start user profile component"

# Push to remote
git push origin feature/user-profile

# Day 2: Continue work
echo "Add styles" > user-profile/styles.css
git add user-profile/styles.css
git commit -m "style: add profile styles"

# Someone updated main - sync your branch
git checkout main
git pull origin main
git checkout feature/user-profile
git rebase main

# Push updates (force push after rebase)
git push origin feature/user-profile --force-with-lease

# Day 3: Code review feedback - make changes
echo "Update based on review" >> user-profile/index.js
git add user-profile/index.js
git commit -m "refactor: address code review comments"

# Push final changes
git push origin feature/user-profile

# Create Pull Request on GitHub/GitLab

# After PR approved and merged
git checkout main
git pull origin main
git branch -d feature/user-profile
```

**Validation**:
- [ ] Feature branch created from updated main
- [ ] Regular commits with good messages
- [ ] Branch kept in sync with main
- [ ] Proper cleanup after merge

---

### Exercise 6.2: Hotfix Production Bug 🔴

**Goal**: Handle urgent production fix

**Scenario**: Critical bug in production needs immediate fix

**Tasks**:
```bash
# Production is on main branch
git checkout main
git pull origin main

# Check current release tag
git tag

# Create hotfix branch from production
git checkout -b hotfix/security-patch

# Fix the bug
echo "Security fix applied" > security-patch.js
git add security-patch.js
git commit -m "fix: patch critical security vulnerability CVE-2025-001"

# Run tests
# npm test

# Merge to main
git checkout main
git merge hotfix/security-patch

# Tag the release
git tag -a v1.2.1 -m "Hotfix: Security patch"

# Push everything
git push origin main
git push origin v1.2.1

# Also merge to develop branch
git checkout develop
git merge hotfix/security-patch
git push origin develop

# Clean up
git branch -d hotfix/security-patch
git push origin --delete hotfix/security-patch
```

**Validation**:
- [ ] Hotfix branch created correctly
- [ ] Fix merged to main and develop
- [ ] Release tagged properly
- [ ] Branch cleaned up

---

### Exercise 6.3: Salvaging Work from Lost Branch 🔴

**Goal**: Recover "lost" commits

**Scenario**: You accidentally deleted a branch with important work

**Setup**:
```bash
mkdir recovery-practice
cd recovery-practice
git init
echo "main" > main.txt
git add main.txt
git commit -m "Initial"

# Create branch with work
git checkout -b important-feature
echo "important work" > important.txt
git add important.txt
git commit -m "Critical feature"

# Get commit hash
git log --oneline

# Go back to main and delete branch
git checkout main
git branch -D important-feature  # Force delete

# Oh no! Important work is "lost"
```

**Recovery**:
```bash
# Use reflog to find lost commits
git reflog

# Find the commit hash of your important work
# Look for: "commit: Critical feature"

# Recreate branch from that commit
git checkout -b recovered-feature <commit-hash>

# Or cherry-pick the commit
git checkout main
git cherry-pick <commit-hash>

# Verify recovery
ls -la
cat important.txt
```

**Validation**:
- [ ] Successfully used reflog
- [ ] Recovered "lost" commits
- [ ] Work restored to branch

---

## Challenge Projects

### Challenge 1: Personal Portfolio Website 🟢

**Goal**: Build and version control a portfolio site

**Requirements**:
- Initialize Git repository
- Create main branch structure
- Use feature branches for each section
- Proper commit messages
- Create releases with tags

**Tasks**:
```bash
# 1. Setup
mkdir portfolio-website
cd portfolio-website
git init

# 2. Create structure
git checkout -b feature/initial-structure
mkdir css js images
touch index.html css/style.css js/app.js
git add .
git commit -m "feat: create initial project structure"

# 3. Header
git checkout main
git merge feature/initial-structure
git checkout -b feature/header
# ... add header HTML ...
git add index.html
git commit -m "feat: add header with navigation"

# 4. About section
git checkout main
git checkout -b feature/about
# ... add about section ...
git commit -m "feat: add about section"

# 5. Projects section
git checkout main
git checkout -b feature/projects
# ... add projects section ...
git commit -m "feat: add projects gallery"

# 6. Merge everything
git checkout main
git merge feature/header
git merge feature/about
git merge feature/projects

# 7. Tag release
git tag -a v1.0.0 -m "Release: Portfolio v1.0.0"

# 8. Create .gitignore
cat > .gitignore << 'EOF'
.DS_Store
node_modules/
*.log
.env
EOF
git add .gitignore
git commit -m "chore: add .gitignore"
```

**Validation**:
- [ ] Multiple feature branches used
- [ ] Clean commit history
- [ ] Proper tagging
- [ ] All features merged to main

---

### Challenge 2: Open Source Contribution Simulation 🟡

**Goal**: Practice fork, PR workflow

**Tasks**:
```bash
# 1. Clone a repository
git clone https://github.com/someuser/project.git
cd project

# 2. Add upstream remote
git remote add upstream https://github.com/original/project.git

# 3. Create feature branch
git checkout -b fix/documentation-typo

# 4. Make changes
# Fix typos in README.md
git add README.md
git commit -m "docs: fix typos in installation section"

# 5. Keep fork updated
git fetch upstream
git rebase upstream/main

# 6. Push to your fork
git push origin fix/documentation-typo

# 7. Create Pull Request on GitHub

# 8. Address review comments
# Make changes based on feedback
git add .
git commit -m "docs: address review feedback"
git push origin fix/documentation-typo
```

**Validation**:
- [ ] Proper fork workflow
- [ ] Feature branch for changes
- [ ] Good commit messages
- [ ] Ready for PR

---

### Challenge 3: Multi-Developer Simulation 🔴

**Goal**: Simulate team development with conflicts

**Setup**: Create a project with multiple "developers"

**Scenario**: Three developers working on same project

```bash
# Developer 1: Setup project
mkdir team-project
cd team-project
git init
echo "# Team Project" > README.md
git add README.md
git commit -m "Initial commit"

# Developer 2: Add feature
git checkout -b dev2/feature-a
echo "Feature A" > feature-a.txt
git add feature-a.txt
git commit -m "Add feature A"

# Developer 3: Add feature
git checkout main
git checkout -b dev3/feature-b
echo "Feature B" > feature-b.txt
git add feature-b.txt
git commit -m "Add feature B"

# Developer 1: Updates main
git checkout main
echo "Main update" >> README.md
git add README.md
git commit -m "Update README"

# Merge dev2's work
git merge dev2/feature-a

# Try to merge dev3's work (might conflict)
git merge dev3/feature-b

# Developer 1: Resolve any conflicts
# ... resolve ...
git add .
git commit -m "Merge feature B"

# Create release
git tag v1.0.0
```

**Validation**:
- [ ] Multiple branches managed
- [ ] Conflicts resolved properly
- [ ] Clean merge strategy
- [ ] Tagged release

---

## Completion Checklist

### Beginner Level ✅
- [ ] Configured Git properly
- [ ] Created and cloned repositories
- [ ] Made commits with good messages
- [ ] Used basic commands (add, commit, push, pull)
- [ ] Created and switched branches
- [ ] Performed basic merges
- [ ] Used .gitignore

### Intermediate Level ✅
- [ ] Resolved merge conflicts
- [ ] Used git stash effectively
- [ ] Performed rebases
- [ ] Cherry-picked commits
- [ ] Used git log with filters
- [ ] Implemented branching strategies
- [ ] Tagged releases
- [ ] Used git diff effectively

### Advanced Level ✅
- [ ] Interactive rebase mastery
- [ ] Recovered lost commits
- [ ] Complex conflict resolution
- [ ] Git hooks implementation
- [ ] Fork and PR workflow
- [ ] Team collaboration scenarios
- [ ] Production hotfix workflow
- [ ] Git internals understanding

---

## Next Steps

After completing these exercises:
1. ✅ Review solutions in `03_CODE_EXAMPLES.md`
2. ✅ Practice with real projects
3. ✅ Contribute to open source
4. ✅ Learn advanced Git workflows
5. ✅ Master Git hooks and automation

---

## Practice Tips

1. **Daily Practice**: Use Git for every project
2. **Break Things**: Experiment in test repos
3. **Read Logs**: Study other projects' Git history
4. **Contribute**: Make open source contributions
5. **Help Others**: Answer Git questions on forums
6. **Automate**: Create aliases and scripts
7. **Stay Updated**: Follow Git updates and features

---

**Keep Practicing! Mastery comes with repetition!** 🎯

See you in the code examples section!