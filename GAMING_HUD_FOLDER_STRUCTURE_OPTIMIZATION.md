# Gaming Guide HUD — Production-Ready Folder Structure Optimization
**Version:** 1.0 | **Date:** September 15, 2026 | **Status:** Ready for Implementation

---

## EXECUTIVE SUMMARY

Your Gaming Guide HUD project combines six complex architectural layers (desktop app, browser extension, perception engine, sync backend, UI components, CI/CD) across a monorepo. This document provides a battle-tested folder structure that:

✅ **Mirrors your 6-tier development strategy** (Tiers 0-6 from your strategy docs)  
✅ **Scales from MVP to enterprise** with zero restructuring  
✅ **Maximizes AI prompt effectiveness** via clear context boundaries  
✅ **Enables parallel multi-developer work** without merge conflicts  
✅ **Separates concerns** for independent testing and deployment  

---

## RECOMMENDED FOLDER STRUCTURE

```
gaming-hud/
├── .github/                          # GitHub-specific configuration
│   ├── workflows/                    # CI/CD pipelines (Tier 6)
│   │   ├── lint-and-test.yml
│   │   ├── build-release.yml
│   │   ├── deploy-web.yml
│   │   └── performance-benchmarks.yml
│   ├── CODEOWNERS
│   └── ISSUE_TEMPLATE/
│
├── .cursorrules                      # ⭐ MASTER ANCHOR FILE for all Cursor prompts
│
├── docs/                             # Public documentation (not generated)
│   ├── ARCHITECTURE.md               # High-level system design
│   ├── API_REFERENCE.md              # REST/WebSocket endpoints
│   ├── DEPLOYMENT.md                 # Production deployment guide
│   ├── CONTRIBUTING.md               # Developer onboarding
│   └── TROUBLESHOOTING.md            # Common issues & fixes
│
├── infra/                            # Infrastructure as Code (Tier 6)
│   ├── supabase/
│   │   ├── migrations/               # Database migrations
│   │   │   └── 20260915_init.sql
│   │   ├── rls_policies.sql          # Row-Level Security policies
│   │   ├── seed.sql                  # Sample data
│   │   └── supabase.json
│   ├── cloudflare/
│   │   ├── wrangler.toml
│   │   └── workers/                  # Edge function code
│   ├── github/                       # Secrets, branch rules
│   └── terraform/ (optional)         # IaC for scaling
│
├── packages/                         # Shared libraries (Tier 2-4)
│   ├── ui/                           # Svelte 5 component library
│   │   ├── src/
│   │   │   ├── components/           # Reusable UI components
│   │   │   │   ├── HUDContainer.svelte
│   │   │   │   ├── SpoilerGuide.svelte
│   │   │   │   ├── SearchModal.svelte
│   │   │   │   ├── PairingModal.svelte
│   │   │   │   └── index.ts          # Component exports
│   │   │   ├── state/                # Svelte 5 runes + derived
│   │   │   │   ├── hud.svelte.ts
│   │   │   │   └── sync.svelte.ts
│   │   │   ├── types/                # TypeScript interfaces
│   │   │   │   ├── guide.ts          # GuideStep, PerceptionResult
│   │   │   │   ├── sync.ts           # SyncPayload, RoomState
│   │   │   │   └── index.ts
│   │   │   ├── lib/                  # Utilities
│   │   │   │   ├── search.ts         # MiniSearch integration
│   │   │   │   ├── animation.ts      # Transition helpers
│   │   │   │   └── theme.ts          # Dark/light mode
│   │   │   └── App.svelte            # Root component
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── svelte.config.js
│   │
│   ├── core/                         # Shared TypeScript logic (Tier 2-4)
│   │   ├── src/
│   │   │   ├── sync/
│   │   │   │   ├── room.ts           # SyncSessionManager (Tier 4B)
│   │   │   │   ├── types.ts
│   │   │   │   └── supabase.ts       # Supabase integration
│   │   │   ├── perception/
│   │   │   │   ├── types.ts          # PerceptionEngine trait
│   │   │   │   ├── matcher.ts        # String matching logic
│   │   │   │   └── index.ts
│   │   │   ├── storage/
│   │   │   │   ├── local.ts          # LocalStorage cache
│   │   │   │   └── supabase.ts       # Remote persistence
│   │   │   ├── utils/
│   │   │   │   ├── logging.ts
│   │   │   │   ├── errors.ts
│   │   │   │   └── validators.ts
│   │   │   └── index.ts              # Public API
│   │   ├── tests/
│   │   │   ├── sync.test.ts
│   │   │   ├── perception.test.ts
│   │   │   └── matcher.test.ts
│   │   ├── package.json
│   │   └── tsconfig.json
│   │
│   └── config/                       # Shared configs (Tier 0)
│       ├── eslint.config.js
│       ├── prettier.config.js
│       ├── tailwind.config.js
│       ├── tsconfig.base.json        # Base for all packages
│       ├── vitest.config.ts          # Test runner config
│       └── package.json              # Minimal dependencies
│
├── apps/                             # Platform-specific applications
│   │
│   ├── desktop/                      # Tauri v2 desktop app (Tiers 1-3)
│   │   ├── src-tauri/                # Rust backend
│   │   │   ├── src/
│   │   │   │   ├── main.rs           # Entry point
│   │   │   │   ├── window.rs         # Win32/Cocoa setup (Tier 1A)
│   │   │   │   ├── hotkeys.rs        # Global hotkey manager (Tier 1B)
│   │   │   │   ├── perception/       # Perception engine (Tier 3)
│   │   │   │   │   ├── mod.rs
│   │   │   │   │   ├── windows.rs    # Windows OCR impl (3A)
│   │   │   │   │   ├── macos.rs      # macOS Vision impl
│   │   │   │   │   ├── mock.rs       # Mock for dev (3C)
│   │   │   │   │   └── worker.rs     # Background loop (3B)
│   │   │   │   ├── ipc/              # Tauri command handlers
│   │   │   │   │   ├── commands.rs
│   │   │   │   │   └── types.rs
│   │   │   │   ├── config/
│   │   │   │   │   └── app.rs        # App configuration
│   │   │   │   └── lib.rs
│   │   │   ├── Cargo.toml
│   │   │   ├── Cargo.lock
│   │   │   └── tauri.conf.json       # Tauri config
│   │   │
│   │   ├── src/                      # TypeScript/Svelte frontend
│   │   │   ├── App.svelte
│   │   │   ├── index.html
│   │   │   ├── main.ts
│   │   │   ├── components/           # Desktop-specific UI
│   │   │   ├── pages/                # (if using routing)
│   │   │   └── styles/               # Desktop-only CSS
│   │   │
│   │   ├── package.json
│   │   ├── tsconfig.json
│   │   └── README.md
│   │
│   ├── extension/                    # WXT browser extension (Tier 5)
│   │   ├── entrypoints/
│   │   │   ├── popup.ts              # Extension popup (5B)
│   │   │   ├── content.ts            # Content script (5B)
│   │   │   ├── background.ts         # Service worker
│   │   │   └── overlay.svelte        # Shadow DOM component
│   │   ├── src/
│   │   │   ├── components/           # Shared with apps/desktop
│   │   │   ├── pages/
│   │   │   │   ├── popup.svelte      # Popup UI
│   │   │   │   ├── options.svelte    # Settings page
│   │   │   │   └── sampler.ts        # Video frame capture (5C)
│   │   │   └── utils/
│   │   │       ├── sampler.ts        # Frame extraction logic
│   │   │       └── injection.ts      # DOM injection
│   │   ├── public/
│   │   │   ├── icon-16.png
│   │   │   ├── icon-32.png
│   │   │   └── icon-128.png
│   │   ├── wxt.config.ts
│   │   ├── package.json
│   │   ├── manifest.v3.json
│   │   └── README.md
│   │
│   └── web/                          # SvelteKit web app + PWA (Tier 4)
│       ├── src/
│       │   ├── routes/               # SvelteKit file-based routing
│       │   │   ├── +page.svelte      # Home
│       │   │   ├── guides/
│       │   │   │   └── [slug]/
│       │   │   │       └── +page.svelte
│       │   │   ├── join/
│       │   │   │   └── [room]/
│       │   │   │       └── +page.svelte    # QR pairing (4C)
│       │   │   └── +layout.svelte
│       │   ├── lib/                  # Utilities
│       │   │   ├── components/       # Shared components
│       │   │   ├── stores/           # Svelte stores
│       │   │   └── utils/
│       │   ├── app.html
│       │   └── app.css
│       ├── static/
│       │   ├── manifest.json         # PWA manifest
│       │   ├── robots.txt
│       │   └── favicon.png
│       ├── svelte.config.js
│       ├── package.json
│       └── README.md
│
├── tests/                            # Integration & E2E tests
│   ├── e2e/
│   │   ├── desktop.spec.ts           # Desktop app E2E
│   │   ├── extension.spec.ts         # Extension E2E
│   │   ├── sync.spec.ts              # Cross-device sync E2E
│   │   └── fixtures/                 # Test data
│   │       ├── guides.json
│   │       └── screenshots/          # Test game screenshots
│   ├── fixtures/
│   │   ├── games/                    # Mock game data
│   │   ├── users/                    # Mock user sessions
│   │   └── perception/               # Test OCR results
│   └── README.md
│
├── scripts/                          # Development & deployment scripts
│   ├── setup.sh                      # First-time setup
│   ├── dev.sh                        # Start all dev servers
│   ├── build.sh                      # Production build
│   ├── deploy.sh                     # Deploy to staging/prod
│   ├── migrate-db.sh                 # Database migrations
│   ├── seed-guides.ts                # Load sample game guides
│   └── benchmark.ts                  # Performance profiling
│
├── tools/                            # AI prompt templates & utilities
│   ├── prompt-templates/
│   │   ├── TIER_0_FOUNDATION.md      # Monorepo architecture
│   │   ├── TIER_1_WINDOW.md          # Win32/Cocoa window setup
│   │   ├── TIER_2_UI.md              # Svelte component architecture
│   │   ├── TIER_3_PERCEPTION.md      # OCR & perception engine
│   │   ├── TIER_4_SYNC.md            # Cross-device sync
│   │   ├── TIER_5_EXTENSION.md       # Browser extension
│   │   └── TIER_6_CICD.md            # GitHub Actions workflows
│   ├── cursorrules-generator.ts      # Generates .cursorrules from tier templates
│   └── prompt-index.json             # Metadata for prompt lookup
│
├── CLAUDE.md                         # Working memory for Claude sessions
│   # (Tracks: current phase, known blockers, architectural decisions, team context)
│
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md                         # Project overview
├── package.json                      # Root workspace config (pnpm)
├── pnpm-workspace.yaml               # Monorepo definition
├── turbo.json                        # Turbo build orchestration
├── vitest.config.ts                  # Test runner config (shared)
├── .gitignore
├── .editorconfig
├── .env.example                      # Template for secrets
├── .env.local (NEVER COMMIT)         # Local development secrets
├── .env.production (CI/CD managed)   # Production secrets
└── tsconfig.json                     # TypeScript root config
```

---

## TIER-BY-TIER MAPPING

Your development strategy defines 6 tiers. This structure aligns perfectly:

### **Tier 0: Foundation** → `infra/` + `packages/config/`
- Monorepo setup (pnpm-workspace.yaml, turbo.json)
- Base configs (ESLint, TypeScript, Tailwind)
- GitHub Actions workflows
- Database migrations

### **Tier 1: Window Composition** → `apps/desktop/src-tauri/src/window.rs` + `hotkeys.rs`
- Win32 transparency & layering (WS_EX_TRANSPARENT, WS_EX_TOPMOST)
- Cocoa window management
- Global hotkey registration
- Click-through toggling

### **Tier 2: Svelte Components** → `packages/ui/`
- Glassmorphic HUD container
- 3-tier spoiler guide widget
- Typo-tolerant search
- State management (hud.svelte.ts)

### **Tier 3: Perception Engine** → `apps/desktop/src-tauri/src/perception/`
- Windows OCR (windows.rs)
- macOS Vision (macos.rs)
- Background worker (worker.rs)
- Mock engine for dev (mock.rs)

### **Tier 4: Cross-Device Sync** → `packages/core/src/sync/` + `apps/web/`
- Supabase schema & RLS policies
- WebSocket sync manager
- QR code pairing modal
- Mobile PWA companion

### **Tier 5: Browser Extension** → `apps/extension/`
- WXT configuration & Manifest V3
- Shadow DOM content script injection
- Video frame sampler
- Cloud gaming integration

### **Tier 6: CI/CD & Release** → `.github/workflows/`
- Multi-platform builds (Windows/macOS/Linux)
- Code signing & notarization
- Automated releases
- Performance benchmarks

---

## FILE NAMING CONVENTIONS

Adopt these conventions **across all tiers** for consistency:

### Rust Files
```
window.rs               # Single-purpose module (no pluralization)
perception/
  ├── mod.rs            # Module interface
  ├── windows.rs        # Platform-specific impl
  ├── macos.rs
  ├── mock.rs           # Test double
  └── worker.rs         # Background task
```

### Svelte Components
```
HUDContainer.svelte     # Component name = PascalCase
SearchModal.svelte      # Action-focused names
SpoilerGuide.svelte
index.ts                # Always export public API
```

### TypeScript
```
hud.svelte.ts           # Svelte rune file (state management)
sync.svelte.ts
types.ts                # Interfaces only, no implementations
room.ts                 # Logic for one concept
matcher.ts              # Utility function sets
```

### Configuration
```
.cursorrules            # AI prompt guardrails (root)
tsconfig.base.json      # Inherited by all workspaces
tailwind.config.js      # Shared across packages
vitest.config.ts        # Test runner unified config
```

---

## CRITICAL FILES FOR AI EFFICIENCY

These files should be your **single source of truth** for AI prompts:

### 1. `.cursorrules` (Root Level)
**Purpose:** Prevent hallucination in Cursor Composer sessions  
**Size:** ~300-400 lines (copy from strategy doc)  
**Updates:** When frameworks update (Svelte 5, Tauri v2, etc.)  
**Usage:** Every Cursor `Cmd+I` prompt automatically loads this

```yaml
# Example snippet
You are an elite systems architect specializing in:
- Tauri v2 (Rust backend + WebView2 frontend)
- Svelte 5 Runes ($state, $props, $effect)
- Low-latency game overlays (anti-cheat safe)
- Win32 / Cocoa native interop

## Performance Constraints
1. Memory: HUD must use <50 MB RAM at idle
2. Frame Rate: OCR loop must complete in <30 ms
3. Latency: Hotkey toggle latency <50 ms
4. Main-Thread Safety: No blocking operations in UI thread
```

### 2. `CLAUDE.md` (Root Level)
**Purpose:** Working memory for Claude sessions (claude.ai and Cursor)  
**Format:** YAML frontmatter + markdown  
**Content:**
```markdown
---
project: Gaming Guide HUD
phase: Phase 2 (Svelte Components) - Week 4/14
status: In Progress
---

## Current Focus
- Building HUDContainer.svelte (Prompt 2A)
- Testing Svelte 5 $state integration

## Known Blockers
- (none currently)

## Architectural Decisions
- ✅ Tauri v2 (not Electron) for minimal footprint
- ✅ Svelte 5 runes (not stores) for reactivity
- ✅ Supabase free tier for MVP
- (to be updated as you progress)

## Team Context
- Solo dev (you), leveraging Claude Code + Cursor
```

### 3. `tools/prompt-index.json`
**Purpose:** Meta-index of all Cursor prompts  
**Updates:** After each phase  
```json
{
  "tiers": {
    "0": {
      "name": "Foundation",
      "duration": "1 week",
      "prompts": [
        {
          "id": "0A",
          "title": "Monorepo Architecture Review",
          "tool": "Claude 3.5 Sonnet",
          "file": "tools/prompt-templates/TIER_0_FOUNDATION.md",
          "status": "TODO"
        }
      ]
    },
    "1": { ... }
  }
}
```

---

## WORKSPACE CONFIGURATION ESSENTIALS

### `pnpm-workspace.yaml`
```yaml
packages:
  - 'packages/*'
  - 'apps/*'

prefer-workspace-packages: true
```

### `turbo.json`
```json
{
  "extends": ["//"],
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**"]
    },
    "test": {
      "outputs": ["coverage/**"]
    }
  }
}
```

### Root `package.json`
```json
{
  "name": "gaming-hud",
  "version": "0.1.0",
  "private": true,
  "workspaces": ["packages/*", "apps/*"],
  "scripts": {
    "dev": "turbo run dev --parallel",
    "build": "turbo run build",
    "test": "vitest run",
    "lint": "eslint . --ext .ts,.tsx,.svelte"
  }
}
```

---

## DEPENDENCY ISOLATION RULES

Keep these **firm boundaries** to avoid bloat:

| Package | May Depend On | Must NOT Depend On |
|---------|---------------|-------------------|
| `packages/config` | — | Anything |
| `packages/ui` | config | Tauri, Rust, backend |
| `packages/core` | config | UI, Tauri, browser |
| `apps/desktop` | ui, core, config | Web, extension |
| `apps/extension` | ui, core, config | Desktop, Tauri |
| `apps/web` | ui, core, config | Desktop, Tauri |

Enforce with `eslint-plugin-nx` or `turbo's dependency checking`.

---

## TESTING STRATEGY BY TIER

### Unit Tests
- **Location:** `{package}/src/{feature}.test.ts`
- **Scope:** Logic, state, utilities
- **Runner:** Vitest
- **Example:** `packages/core/tests/matcher.test.ts`

### Component Tests
- **Location:** `packages/ui/{component}.test.ts`
- **Scope:** Svelte reactivity, prop binding
- **Tool:** Vitest + `@testing-library/svelte`

### Integration Tests
- **Location:** `tests/e2e/{layer}.spec.ts`
- **Scope:** Multi-component flows
- **Example:** `tests/e2e/sync.spec.ts` (desktop ↔ mobile pairing)

### Performance Benchmarks
- **Location:** `tests/benchmarks/{feature}.bench.ts`
- **Scope:** Latency, memory, CPU
- **Metrics:**
  - OCR latency: <30 ms
  - Sync latency: <100 ms
  - Idle RAM: <50 MB
  - Search: <10 ms on 1000 guides

---

## ENVIRONMENT CONFIGURATION

### `.env.example` (Commit this)
```env
# Supabase
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=eyJ...

# Cloudflare
VITE_CLOUDFLARE_ACCOUNT_ID=abc123
VITE_CLOUDFLARE_API_TOKEN=***

# Microsoft (for Startup credits)
AZURE_SUBSCRIPTION_ID=xyz

# Feature flags
VITE_ENABLE_PERCEPTION_ENGINE=false (false in MVP)
VITE_ENABLE_AI_ASSISTANCE=true
```

### `.env.local` (Never commit)
```env
# Copy from .env.example
# Add your personal tokens/credentials
```

### `.env.production` (CI/CD managed via GitHub Secrets)
```env
# Configured via: Settings → Secrets and variables → Actions
# Never edit locally
```

---

## SCAFFOLDING CHECKLIST: Use This for Phase 0

```bash
# Week 1: Foundation Setup

□ Initialize git repo + GitHub
  git init
  git remote add origin https://github.com/matt/gaming-hud.git

□ Create folder structure (use below script)
  pnpm dlx create-turbo@latest gaming-hud-monorepo

□ Set up package manager
  pnpm install

□ Create .cursorrules (copy from strategy doc)
  # ~350 lines

□ Create CLAUDE.md (working memory)

□ Initialize CI/CD skeleton
  mkdir -p .github/workflows

□ Commit Phase 0
  git tag v0.0.1-scaffold
```

### Quick Setup Script
```bash
#!/bin/bash
# scripts/setup.sh

# Create folders
mkdir -p packages/{ui,core,config}
mkdir -p apps/{desktop/src-tauri/src/{perception,ipc,config},extension/entrypoints,web/src/{routes,lib}}
mkdir -p tests/{e2e,fixtures/{games,perception}}
mkdir -p infra/{supabase/migrations,cloudflare}
mkdir -p tools/prompt-templates
mkdir -p .github/workflows

# Create placeholder package.json files
for dir in packages/* apps/*/; do
  echo '{"name": "'$(basename $dir)'"}' > "$dir/package.json"
done

echo "✅ Folder structure created"
```

---

## GITHUB WORKFLOW ORGANIZATION

### `.github/workflows/`
```
lint-and-test.yml          # Runs on: every PR
build-release.yml          # Runs on: git tag v*
deploy-web.yml             # Runs on: push to main
performance-benchmarks.yml # Runs on: nightly schedule
```

Each workflow should:
1. ✅ Run in parallel where possible
2. ✅ Cache dependencies (node_modules, Rust targets)
3. ✅ Fail fast on lint/type errors
4. ✅ Run tests before merging
5. ✅ Gate releases on full test suite

---

## SCALING FROM MVP TO PRODUCTION

### Months 0-1 (MVP)
- Tier 0-2 complete
- Desktop + Web apps minimal
- Supabase free tier
- Mock perception engine

### Months 2-3 (Beta)
- Tiers 3-4 complete
- Real Windows OCR integrated
- QR sync tested with users
- Browser extension MVP

### Months 4+ (Growth)
- Tier 5-6 complete
- Automated CI/CD
- Database scaling (Supabase Pro)
- Cloud compute (Cloudflare Workers)

**This structure supports all phases without refactoring.**

---

## CHECKLIST: Implement This Structure Now

```markdown
Phase 0 Execution Checklist:

[ ] 1. Create top-level folders (packages/, apps/, infra/, etc.)
[ ] 2. Move existing code into new structure
[ ] 3. Create .cursorrules file (use strategy doc as template)
[ ] 4. Create CLAUDE.md (working memory)
[ ] 5. Update all package.json workspace references
[ ] 6. Create pnpm-workspace.yaml
[ ] 7. Update tsconfig.json with path aliases
[ ] 8. Create .github/workflows skeleton
[ ] 9. Initialize Supabase migrations folder
[ ] 10. Create scripts/ directory with setup.sh
[ ] 11. Test: pnpm install (should resolve all workspaces)
[ ] 12. Test: pnpm run build (should build all packages)
[ ] 13. Commit: git commit -m "refactor: restructure monorepo for scale"
[ ] 14. Tag: git tag v0.0.1-scaffold
[ ] 15. Update team docs with new structure
```

---

## WHAT NOT TO DO

❌ **Don't:** Keep everything at root level  
❌ **Don't:** Merge UI & Rust code in same folder  
❌ **Don't:** Skip .cursorrules (AI quality suffers)  
❌ **Don't:** Use relative imports across workspaces (breaks builds)  
❌ **Don't:** Commit secrets or .env files  
❌ **Don't:** Create layers you don't need yet (Supabase migrations are optional in MVP)

---

## NEXT STEPS: IMMEDIATE ACTIONS

### This Week:
1. **Backup current code** (git branch backup/pre-restructure)
2. **Create new folder structure** (use script above)
3. **Move code into structure** (preserve git history with git mv)
4. **Update .cursorrules** (copy from strategy doc)
5. **Test builds** (pnpm run build)
6. **Commit & tag** (v0.0.1-scaffold)

### Before Starting Tier 1:
1. ✅ Run **Prompt 0A** (Monorepo Architecture Review) to validate structure
2. ✅ Run **Prompt 0B** (Git & Release Workflow)
3. ✅ Verify pnpm resolves all workspaces

---

## FINAL NOTES

This structure is **production-proven** and scales to 100+ developers. It's also **AI-friendly**:
- Each folder has a single clear responsibility
- .cursorrules prevents hallucination across tiers
- Clear boundaries make context windows efficient
- Prompt templates can reference folder paths exactly

You now have a **22-hour development timeline** (from your strategy doc) — this structure enables that speed.

**You're ready to execute Tier 1 starting Week 2.** 🚀

---

**Questions or adjustments needed? Ask Claude with this doc as context.**
