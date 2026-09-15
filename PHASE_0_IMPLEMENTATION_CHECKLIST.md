# Phase 0: Foundation Scaffolding — Step-by-Step Checklist
**Timeline**: September 15-22, 2026 (This Week!)  
**Effort**: ~8 hours total  
**Outcome**: Production-ready monorepo structure + AI anchor files  

---

## PRE-IMPLEMENTATION (30 minutes)

### Step 1: Backup & Branch
```bash
cd ~/gaming-hud

# Create safety branch
git checkout -b backup/pre-restructure
git push origin backup/pre-restructure

# Return to main
git checkout main

# Verify clean state
git status  # Should show no uncommitted changes
```
**Status**: ☐ Complete

### Step 2: Review Documentation
- [ ] Read `GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md` (10 min)
- [ ] Skim `.cursorrules` (5 min)
- [ ] Review `CLAUDE.md` structure (5 min)

**Status**: ☐ Complete

---

## CORE IMPLEMENTATION (5 hours)

### Step 3: Create Folder Structure
Copy this script and save as `scripts/setup-phase-0.sh`:

```bash
#!/bin/bash
set -e  # Exit on error

echo "🚀 Gaming HUD Phase 0: Foundation Setup"
echo "========================================"

# Create top-level directories
echo "Creating directory structure..."
mkdir -p packages/{ui/src/{components,state,types,lib},core/src/{sync,perception,storage,utils},config}
mkdir -p apps/desktop/{src-tauri/src/{perception,ipc,config},src}
mkdir -p apps/extension/{entrypoints,src/{components,pages,utils},public}
mkdir -p apps/web/{src/{routes,lib},static}
mkdir -p tests/{e2e,fixtures/{games,perception,screenshots}}
mkdir -p infra/{supabase/migrations,cloudflare/workers}
mkdir -p tools/{prompt-templates}
mkdir -p .github/workflows
mkdir -p scripts docs

echo "✅ Directories created"

# Create placeholder .gitkeep files to preserve empty dirs
echo "Adding .gitkeep files..."
find . -type d -empty -not -path './.git/*' -exec touch {}/.gitkeep \;

echo "✅ .gitkeep files added"

# Create core configuration files
echo "Creating configuration files..."

# TypeScript base config (all workspaces inherit from this)
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "strict": true,
    "noImplicitAny": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": ".",
    "paths": {
      "@gaming-hud/ui": ["packages/ui/src/index.ts"],
      "@gaming-hud/core": ["packages/core/src/index.ts"],
      "@gaming-hud/config": ["packages/config/index.ts"]
    }
  },
  "include": [],
  "references": [
    { "path": "./packages/config" },
    { "path": "./packages/ui" },
    { "path": "./packages/core" },
    { "path": "./apps/desktop" },
    { "path": "./apps/extension" },
    { "path": "./apps/web" }
  ]
}
EOF

# pnpm workspace config
cat > pnpm-workspace.yaml << 'EOF'
packages:
  - 'packages/*'
  - 'apps/*'

prefer-workspace-packages: true
EOF

# Turbo config
cat > turbo.json << 'EOF'
{
  "extends": ["//"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"],
      "hashAlgorithm": "md5"
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "outputs": ["dist/**"]
    },
    "type-check": {
      "outputs": [".tsc-out/**"]
    },
    "test": {
      "outputs": ["coverage/**"]
    }
  },
  "globalEnv": ["NODE_ENV"],
  "globalPassThroughEnv": ["GITHUB_*"]
}
EOF

# Root package.json
cat > package.json << 'EOF'
{
  "name": "gaming-hud",
  "version": "0.1.0-alpha",
  "type": "module",
  "description": "Gaming Guide HUD - AI-assisted overlay for gaming guides",
  "author": "Matt <matt@futureaiguide.com>",
  "license": "MIT",
  "private": true,
  "workspaces": ["packages/*", "apps/*"],
  "scripts": {
    "dev": "turbo run dev --parallel",
    "build": "turbo run build",
    "build:desktop": "turbo run build --filter desktop",
    "build:extension": "turbo run build --filter extension",
    "build:web": "turbo run build --filter web",
    "lint": "turbo run lint",
    "type-check": "turbo run type-check",
    "test": "vitest run",
    "test:watch": "vitest",
    "format": "prettier --write .",
    "clean": "turbo run clean && rm -rf node_modules pnpm-lock.yaml"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "eslint": "^9.0.0",
    "prettier": "^3.3.0",
    "turbo": "^2.0.0",
    "typescript": "^5.3.0",
    "vitest": "^1.6.0"
  },
  "engines": {
    "node": ">=20.0.0",
    "pnpm": ">=9.0.0"
  }
}
EOF

echo "✅ Configuration files created"

# Create minimal package.json for each workspace
echo "Creating workspace package.json files..."

for dir in packages/ui packages/core packages/config apps/desktop apps/extension apps/web; do
  cat > "$dir/package.json" << 'WORKSPACE'
{
  "name": "@gaming-hud/$(basename $dir)",
  "version": "0.1.0-alpha",
  "type": "module",
  "private": true,
  "devDependencies": {
    "typescript": "*"
  }
}
WORKSPACE
done

echo "✅ Workspace package.json files created"

echo ""
echo "🎉 Phase 0 Foundation Setup Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "1. pnpm install"
echo "2. Copy .cursorrules to root"
echo "3. Copy CLAUDE.md to root"
echo "4. Run: pnpm run type-check"
echo "5. Commit: git add . && git commit -m 'chore: init monorepo structure'"
```

Run the script:
```bash
chmod +x scripts/setup-phase-0.sh
./scripts/setup-phase-0.sh
```

**Status**: ☐ Complete

### Step 4: Copy AI Anchor Files
```bash
# These should already be in ~/gaming-hud from earlier
# If not, copy them from the uploaded files

cp /path/to/.cursorrules ./.cursorrules
cp /path/to/CLAUDE.md ./CLAUDE.md

# Verify they're in root
ls -la .cursorrules CLAUDE.md
```

**Status**: ☐ Complete

### Step 5: Initialize Node + Dependencies
```bash
# Install pnpm if needed
npm install -g pnpm@latest

# Install dependencies
pnpm install

# Verify workspace linking
pnpm ls --depth 0

# Should show:
# gaming-hud
# ├── packages/ui
# ├── packages/core
# ├── packages/config
# ├── apps/desktop
# ├── apps/extension
# └── apps/web
```

**Expected Output**:
```
✓ pnpm resolves all 6 workspaces
✓ No unresolved dependencies
```

**Status**: ☐ Complete

### Step 6: Create Core Config Files

#### `packages/config/package.json`
```json
{
  "name": "@gaming-hud/config",
  "version": "0.1.0-alpha",
  "type": "module",
  "private": true,
  "exports": {
    "./eslint": "./eslint.config.js",
    "./prettier": "./prettier.config.js",
    "./tailwind": "./tailwind.config.js",
    "./typescript": "./tsconfig.base.json"
  }
}
```

#### `packages/config/tsconfig.base.json`
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,
    "strict": true,
    "noImplicitAny": true,
    "esModuleInterop": true,
    "resolveJsonModule": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "baseUrl": ".",
    "rootDir": ".",
    "paths": {
      "@gaming-hud/ui": ["../../packages/ui/src/index.ts"],
      "@gaming-hud/core": ["../../packages/core/src/index.ts"],
      "@gaming-hud/config": ["../../packages/config/index.ts"]
    }
  }
}
```

#### `packages/config/eslint.config.js`
```js
export default [
  {
    ignores: ['dist/**', 'node_modules/**', '.next/**']
  },
  {
    files: ['**/*.ts', '**/*.tsx', '**/*.svelte'],
    languageOptions: {
      parser: '@typescript-eslint/parser',
      parserOptions: {
        sourceType: 'module',
        ecmaVersion: 2020
      }
    },
    plugins: {
      '@typescript-eslint': require('@typescript-eslint/eslint-plugin')
    },
    rules: {
      'no-implicit-coercion': 'error',
      'prefer-const': 'error',
      '@typescript-eslint/no-explicit-any': 'error'
    }
  }
];
```

**Status**: ☐ Complete

### Step 7: Verify Build System
```bash
# Type check
pnpm run type-check

# Should pass (or show that workspaces are empty)
echo "✅ Type checking passes"

# Build
pnpm run build

# Should complete (output may be minimal since packages are empty)
echo "✅ Build system works"
```

**Expected Output**:
```
✓ No TypeScript errors
✓ Build completes without errors
✓ Turbo cache initialized
```

**Status**: ☐ Complete

---

## GIT SETUP (30 minutes)

### Step 8: Create GitHub Action Workflows (Skeleton)

#### `.github/workflows/lint-and-test.yml`
```yaml
name: Lint & Test

on:
  pull_request:
  push:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run lint
      - run: pnpm run type-check

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm run test
```

#### `.github/workflows/build-release.yml`
```yaml
name: Build Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - run: echo "Release build for ${{ matrix.os }}"
      # Full implementation comes in Phase 6
```

**Status**: ☐ Complete

### Step 9: Commit Phase 0
```bash
# Stage all changes
git add .

# Commit with descriptive message
git commit -m "chore(phase-0): initialize monorepo structure

- Create folders: packages/, apps/, infra/, tests/, tools/
- Add .cursorrules anchor file for AI consistency
- Add CLAUDE.md working memory for all Claude sessions
- Configure pnpm workspaces + Turbo build orchestration
- Setup TypeScript base config with path aliases
- Add GitHub Actions workflow skeletons

Co-Authored-By: Claude Haiku 4.5 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01WkP7kfQmBYwKT3osurRdq1"

# Create tag
git tag v0.0.1-scaffold

# Push to remote
git push origin main
git push origin v0.0.1-scaffold
```

**Status**: ☐ Complete

---

## VALIDATION (1 hour)

### Step 10: Run Full Test Suite
```bash
# Type check all packages
echo "Running type checks..."
pnpm run type-check
# Expected: ✅ PASS (or empty workspaces warning)

# Run linter
echo "Running linter..."
pnpm run lint
# Expected: ✅ PASS

# Build all
echo "Building all packages..."
pnpm run build
# Expected: ✅ PASS (turbo caches)

# Verify workspace resolution
echo "Verifying workspace resolution..."
pnpm ls --depth 0 --json | jq '.dependencies | keys'
# Expected: ["@gaming-hud/config", "@gaming-hud/core", "@gaming-hud/ui", "packages/desktop", ...]

echo "✅ ALL VALIDATIONS PASSED"
```

**Status**: ☐ Complete

### Step 11: Document Current State
Update `CLAUDE.md`:
```yaml
focus:
  current_task: "Phase 0 complete — ready for Prompt 0A"
  status: "READY_FOR_PHASE_1"
  
session_log:
  session_001:
    work_done:
      - "✅ Phase 0 foundation scaffolding complete"
      - "✅ Monorepo structure verified"
      - "✅ .cursorrules deployed"
      - "✅ All tests passing"
    
    next_session: "Run Prompt 0A (Monorepo Architecture Review)"
```

**Status**: ☐ Complete

---

## BEFORE-PHASE-1 CHECKLIST (Sep 22)

### Prompt Execution (3 hours)
```markdown
☐ Run Prompt 0A: Monorepo Architecture Review
  - Tool: Claude 3.5 Sonnet
  - Context: Attach .cursorrules + strategy docs
  - Verify: Structure matches plan, no circular dependencies
  
☐ Run Prompt 0B: Git & Release Workflow
  - Tool: GitHub Copilot CLI
  - Output: conventional-commits config, semantic-release setup
  - Verify: Commits follow pattern, releases auto-tagged
```

### Final Verification (30 min)
```bash
# 1. Verify pnpm workspaces
pnpm install --frozen-lockfile

# 2. Type check
pnpm run type-check

# 3. Build
pnpm run build

# 4. Create tag
git tag v0.1.0-foundation

# 5. Document in CLAUDE.md
# (mark Phase 0 COMPLETE)
```

**Status**: ☐ Complete

---

## TROUBLESHOOTING

### Issue: `pnpm install` fails
**Solution**:
```bash
# Clear cache
pnpm store prune

# Reinstall
rm -rf node_modules pnpm-lock.yaml
pnpm install
```

### Issue: Turbo build fails with "no tasks found"
**Solution**: Workspaces are empty — this is expected. Add actual code to fix.

### Issue: TypeScript path aliases not resolving
**Solution**:
1. Verify `tsconfig.json` has correct paths
2. Check each workspace has `tsconfig.json` extending base
3. Verify `package.json` exports match paths

### Issue: Git tag already exists
**Solution**:
```bash
git tag -d v0.0.1-scaffold
git push origin --delete v0.0.1-scaffold
git tag v0.0.1-scaffold
git push origin v0.0.1-scaffold
```

---

## SUCCESS CRITERIA

By end of Phase 0:
- [ ] Git repo has clean history with v0.0.1-scaffold tag
- [ ] All 6 workspaces resolve with `pnpm ls`
- [ ] `pnpm run build` completes in <30 seconds
- [ ] `pnpm run type-check` passes
- [ ] `.cursorrules` in root (verified with `cat .cursorrules | head`)
- [ ] `CLAUDE.md` in root with Phase 0 logged
- [ ] `.github/workflows/` has 2+ skeleton workflows
- [ ] AI anchor files ready for Phase 1 prompts

---

## ESTIMATED TIME BREAKDOWN

| Task | Duration | Status |
|------|----------|--------|
| Backup & review | 30 min | ☐ |
| Folder structure + configs | 2 hours | ☐ |
| Copy AI files | 15 min | ☐ |
| pnpm setup + install | 30 min | ☐ |
| Config files | 45 min | ☐ |
| GitHub Actions skeleton | 30 min | ☐ |
| Git + tag + push | 30 min | ☐ |
| Validation + docs | 1 hour | ☐ |
| **TOTAL** | **~8 hours** | ☐ |

---

## NEXT MILESTONE: Phase 1 (Sep 23 - Oct 6)

Once Phase 0 is complete:

1. **Prompt 1A**: Transparent click-through window (Win32 + Cocoa)
   - Generate `apps/desktop/src-tauri/src/window.rs`
   - Test on both platforms

2. **Prompt 1B**: Global hotkey manager
   - Generate `apps/desktop/src-tauri/src/hotkeys.rs`
   - Wire into Tauri setup

3. **Success**: Window renders, hotkey toggles, <50 MB RAM

---

**Questions?** Refer to `GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md` or ask Claude with `.cursorrules` context.

**Ready to begin? Start with Step 1 (Backup & Branch) now!** 🚀
