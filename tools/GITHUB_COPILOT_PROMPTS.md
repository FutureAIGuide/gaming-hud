# Gaming Guide HUD — GitHub Copilot Productivity Prompts
**For**: GitHub Copilot CLI, VSCode Copilot, Copilot Chat  
**Updated**: September 15, 2026  
**Purpose**: Quick, actionable prompts to automate Phase 0 setup + Phase 1 scaffolding

---

## 🎯 QUICK START: Copy-Paste Ready Prompts

### PROMPT 0A: Monorepo Architecture Validation (GitHub Copilot CLI)
```bash
copilot_cli prompt \
  --context ".cursorrules CLAUDE.md GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md" \
  --query "
  [PHASE 0 - ARCHITECTURE REVIEW]
  
  Context Files Loaded:
  - .cursorrules (AI development rules)
  - CLAUDE.md (project status, 14-week timeline)
  - GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md (folder structure spec)
  
  Task: Perform a 360° audit of our monorepo structure.
  
  Verify:
  1. Workspace dependencies form a valid DAG (no circular imports)
  2. Each package has correct tsconfig.json inheritance
  3. Path aliases in tsconfig.base.json match package exports
  4. pnpm-workspace.yaml and package.json are in sync
  5. All Tauri Cargo.toml dependencies use v2 APIs (not v1)
  
  Provide:
  - Checklist: Pass/Fail for each item
  - Risk assessment: Any architectural mismatches
  - Quick wins: Immediate fixes (3 lines max each)
  - Next step: Exact commands to validate locally
  
  Format: Structured checklist, no fluff.
  "
```

**Expected Output**: ✅ Validation report + actionable fixes

---

### PROMPT 0B: Git Workflow Setup (GitHub Copilot CLI)
```bash
copilot_cli prompt \
  --context "package.json CONTRIBUTING.md" \
  --query "
  [PHASE 0 - GIT & RELEASE WORKFLOW]
  
  Task: Generate a production-ready git workflow for 14-week solo dev project.
  
  Requirements:
  - Conventional Commits (feat:, fix:, chore:, docs:)
  - Semantic versioning (SemVer)
  - Automated release notes on git tag
  - Squash commits on merge (keep history clean)
  - Branch protection: require tests before merge to main
  
  Deliverables (generate 3 files):
  1. .github/COMMIT_CONVENTION.md — Conventional Commits guide
  2. scripts/commitlint.config.js — ESLint-style commit validation
  3. .github/workflows/release-notes.yml — Auto-generate release notes on tag
  
  Include:
  - Exact CLI commands for developers
  - Example git flow: feature branch → PR → merge → tag → release
  - Commands to test locally before pushing
  
  Target: Solo dev should never break workflow with a bad commit.
  "
```

**Expected Output**: 3 ready-to-use files + git workflow guide

---

### PROMPT 1A: Transparent Window Setup (GitHub Copilot in VSCode)
**Trigger**: `Cmd+Shift+I` in `apps/desktop/src-tauri/src/window.rs`

```
[TIER 1A - TRANSPARENT WINDOW COMPOSITION]

Context: 
- Tauri v2 (not v1)
- Windows target: WS_EX_TRANSPARENT, WS_EX_LAYERED, WS_EX_TOPMOST
- macOS target: NSWindowStyleMaskTitledAndClosable + setIgnoresMouseEvents
- Requirement: <50ms click-through toggle, zero flicker

Generate:
1. window.rs: Platform-specific overlay setup
   - Windows: Win32 FFI setup
   - macOS: Cocoa setup
   - BOTH use Result<T, String> (Tauri IPC safe)

2. Quick test: Click-through toggle should work in 2 seconds

Use .cursorrules as context for Tauri v2 + Windows-rs patterns.
Include TODO comments for Phase 1B (hotkey manager).
```

---

### PROMPT 2A: HUD Container Component (GitHub Copilot in VSCode)
**Trigger**: `Cmd+Shift+I` in `packages/ui/src/components/HUDContainer.svelte`

```
[TIER 2A - HUD CONTAINER + STATE ENGINE]

Requirements:
- Glassmorphic design (backdrop-filter: blur(10px))
- Responsive grid layout (4 columns on desktop, 2 on tablet)
- Global z-index manager (never conflicts with game UI)
- Accessible (ARIA labels for screen readers)
- <30 FPS overhead (use will-change: transform sparingly)

Generate:
1. HUDContainer.svelte
   - $props({ games, activeGuide, onSelectGuide })
   - $state for visibility toggle
   - $derived for computed layout
   - CSS Grid layout with Tailwind v4

2. hud.svelte.ts (state file)
   - $state.snapshot() for sync across devices
   - hudState.setActiveGame(gameId)
   - hudState.toggleOverlay()

3. Test: Import in App.svelte, render with mock data

Use Svelte 5 ONLY ($state, $props, $effect).
Never use stores or reactive statements ($:).
```

---

### PROMPT 3A: Windows OCR Perception Engine (GitHub Copilot CLI)
**Trigger**: `copilot_cli prompt`

```bash
copilot_cli prompt \
  --language rust \
  --context ".cursorrules apps/desktop/src-tauri/src/perception/mod.rs" \
  --query "
  [TIER 3A - WINDOWS OCR IMPLEMENTATION]
  
  Target: Windows 10+ with WGC (Windows Graphics Capture) + OCR WinRT API
  
  Implement:
  1. windows.rs: struct WindowsPerceptionEngine
     - WGC capture loop (1 FPS throttle for CPU <2%)
     - Windows.Media.Ocr integration
     - Return: Vec<PerceptionResult> with timestamp, confidence, bounding box
  
  2. Trait compliance: Implement PerceptionEngine trait from mod.rs
     - async fn start_capture(rois: Vec<RoiRegion>)
     - async fn stop_capture()
     - fn get_result_receiver() -> tokio::sync::broadcast::Receiver
  
  3. Error handling: No .unwrap() in event loops
     - Use Result<T, Box<dyn Error>>
     - Log errors but continue capture
  
  4. Unit test: Mock D3D11 texture, verify OCR output parse
  
  Include: MSRV check (Rust 1.70+), link against WinRT libraries
  "
```

---

### PROMPT 4A: Supabase Schema & RLS (GitHub Copilot in VSCode)
**Trigger**: `Cmd+I` in `infra/supabase/migrations/20260915_init.sql`

```
[TIER 4A - SUPABASE SCHEMA + RLS POLICIES]

Design PostgreSQL 16 schema for:
- games: Game titles, cover art URLs
- guide_steps: 3-tier content (always_visible, spoiler_tier2, spoiler_tier3)
- sync_sessions: Room codes (TTL 24h), active pairing sessions
- perception_matches: Detected quest context with confidence scores

Generate:
1. Migration SQL: Create tables with proper indices
   - Use UUID primary keys
   - Add created_at, updated_at timestamps
   - Index on (game_id, step_order) for fast queries

2. RLS Policies (CRITICAL):
   - guides: Public read (SELECT)
   - guide_steps: Public read (SELECT)
   - sync_sessions: No auth needed, read/write if room_code matches
   - perception_matches: Insert-only (logged-in users)

3. Include seed data: 3 sample games, 10 sample guides

Requirement: Supabase free tier compatible (500 MB storage, 50k MAUs)
```

---

### PROMPT 5A: WXT Browser Extension (GitHub Copilot CLI)
**Trigger**: `copilot_cli prompt`

```bash
copilot_cli prompt \
  --language typescript \
  --context ".cursorrules apps/extension/wxt.config.ts" \
  --query "
  [TIER 5A - WXT CONFIG + MANIFEST V3]
  
  Generate:
  1. wxt.config.ts
     - manifest V3 (V2 deprecated)
     - Target browsers: Chrome, Edge, Firefox, Safari
     - Host permissions: *://xbox.com/*, *://*.geforcenow.com/*, *://play.google.com/*
     - Background service worker (not event page)
  
  2. entrypoints/content.ts
     - Inject shadow root (closed mode, no leakage)
     - Load Tailwind CSS into shadow DOM
     - Mount Svelte overlay component
  
  3. manifest.json snippet
     - Icons at 16px, 32px, 128px
     - Action popup
     - Content script configuration
  
  4. tsconfig.json (workspace-aware)
     - Import @gaming-hud/ui, @gaming-hud/core via aliases
     - Browser API types (webextension-polyfill)
  
  Ensure: No dependency on Tauri (works in browser only)
  "
```

---

### PROMPT 6A: GitHub Actions Multi-Platform Build (GitHub Copilot CLI)
**Trigger**: `copilot_cli prompt`

```bash
copilot_cli prompt \
  --language yaml \
  --context ".github/workflows/build-release.yml" \
  --query "
  [TIER 6A - GITHUB ACTIONS MULTI-PLATFORM MATRIX]
  
  Trigger: git tag v* (e.g., v1.0.0)
  
  Build Matrix:
  - ubuntu-22.04 → Linux .AppImage (via cargo-appimage)
  - macos-latest → .dmg (universal binary: x86_64 + arm64)
  - windows-latest → .msi (via WiX Toolset)
  
  For each platform:
  1. Checkout code
  2. Install Rust toolchain (1.70+)
  3. Cache Cargo dependencies
  4. Run: cargo build --release
  5. Sign artifacts:
     - macOS: codesign + notarize (Apple Developer cert)
     - Windows: (optional) Authenticode signing
  6. Package installers (cargo-deb, dmg, msi)
  7. Upload to GitHub Release draft
  
  Add: Performance benchmarks step (run scripts/benchmark.ts)
  
  Caching: Use actions/cache@v4 for:
  - ~/.cargo/registry/
  - ~/.cargo/git/
  - target/
  
  Fail fast: Lint + type-check first (fail before builds)
  "
```

---

## 🚀 RAPID EXECUTION TEMPLATE

### For GitHub Copilot CLI:
```bash
#!/bin/bash
# scripts/copilot-phase-0.sh

# Phase 0: Foundation setup
copilot_cli prompt --context ".cursorrules CLAUDE.md" --query "$(cat tools/PROMPTS/PHASE_0A.md)"
copilot_cli prompt --context "package.json" --query "$(cat tools/PROMPTS/PHASE_0B.md)"

# Test the setup
pnpm install
pnpm run lint
pnpm run type-check

# Commit on success
git add . && git commit -m "chore(phase-0): automated setup via Copilot"
git tag v0.0.1-scaffold
```

### For Cursor Composer (`Cmd+I`):
1. Open file in Cursor editor
2. Press `Cmd+I`
3. Paste prompt from section above
4. Hit Enter
5. Cursor auto-loads `.cursorrules` + generates code
6. Review + refactor
7. Commit

### For GitHub Copilot Chat (VSCode):
1. Open Chat panel (`Cmd+Shift+I`)
2. Select file context (`@filename`)
3. Paste prompt
4. Review suggestions
5. Apply changes

---

## 📋 WEEKLY EXECUTION SCHEDULE

### Week 1 (Sep 15-22): Phase 0
```bash
Mon: copilot_cli prompt 0A (architecture review)
Tue: copilot_cli prompt 0B (git workflow)
Wed: Manual: pnpm install, verify builds
Thu: Create .cursorrules + CLAUDE.md
Fri: Commit v0.0.1-scaffold, tag + push
```

### Week 2-3 (Sep 23 - Oct 6): Phase 1
```bash
Mon: Cursor Cmd+I → PROMPT 1A (window setup)
Wed: Cursor Cmd+I → PROMPT 1B (hotkey manager)
Fri: Manual: Test on Windows + macOS, commit v0.1.0-window
```

### Week 4-6 (Oct 7-27): Phase 2
```bash
Mon: Cursor Cmd+I → PROMPT 2A (HUD Container)
Wed: Cursor Cmd+I → PROMPT 2B (SpoilerGuide component)
Fri: Cursor Cmd+I → PROMPT 2C (Fuzzy search)
Sprint end: Commit v0.2.0-ui, verify <10ms search latency
```

### Week 7-9 (Oct 28 - Nov 10): Phase 3
```bash
Mon: copilot_cli prompt 3A (Windows OCR)
Wed: Cursor Cmd+I → PROMPT 3B (background worker)
Thu: Cursor Cmd+I → PROMPT 3C (mock engine for macOS)
Fri: Performance benchmark + commit v0.3.0-perception
```

### Week 10-11 (Nov 11-24): Phase 4
```bash
Mon: Cursor Cmd+I → PROMPT 4A (Supabase schema)
Wed: Cursor Cmd+I → PROMPT 4B (WebSocket sync)
Fri: Cursor Cmd+I → PROMPT 4C (QR pairing modal)
Sprint end: E2E test sync <100ms, commit v0.4.0-sync
```

### Week 12-13 (Nov 25 - Dec 8): Phase 5
```bash
Mon: copilot_cli prompt 5A (WXT config)
Wed: Cursor Cmd+I → PROMPT 5B (Shadow DOM injection)
Fri: Cursor Cmd+I → PROMPT 5C (video frame sampler)
Sprint end: Test on Xbox Cloud Gaming, commit v0.5.0-extension
```

### Week 14+ (Dec 9-15): Phase 6
```bash
Mon: copilot_cli prompt 6A (GitHub Actions)
Wed: Manual: Test multi-platform builds
Fri: Code signing + release to GitHub, v1.0.0-release
```

---

## 🎯 HIGH-IMPACT QUICK WINS

### Use these for "blocked on nothing" efficiency:

1. **Auto-format code**
   ```bash
   copilot_cli prompt \
     --context "package.json" \
     --query "Generate scripts/format.sh to lint + prettier --write all files"
   ```

2. **Generate test fixtures**
   ```bash
   copilot_cli prompt \
     --query "Generate 5 mock game guide datasets for tests/fixtures/guides.json (Elden Ring, Baldur's Gate 3, Starfield, etc.)"
   ```

3. **Performance baseline script**
   ```bash
   copilot_cli prompt \
     --language typescript \
     --query "Generate scripts/benchmark.ts to measure: OCR latency, sync latency, search speed, idle RAM"
   ```

4. **Documentation scaffolding**
   ```bash
   copilot_cli prompt \
     --query "Generate API reference docs for apps/desktop/src-tauri Tauri IPC commands"
   ```

---

## ⚠️ CRITICAL GUARDRAILS

**DO NOT** ask Copilot to:
- ❌ Choose between Tauri v1 vs v2 (use v2 only)
- ❌ Suggest Svelte 3/4 syntax (use Svelte 5 runes ONLY)
- ❌ Generate monorepo structure (it's in GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md)
- ❌ Write without error handling (no .unwrap() in Rust runtime code)
- ❌ Skip type signatures (all functions must be fully typed)

**ALWAYS** include in your prompt:
- ✅ Reference `.cursorrules` for consistency
- ✅ Mention the Tier number (e.g., "[TIER 3A]")
- ✅ Specify framework versions (Tauri v2, Svelte 5, etc.)
- ✅ Include performance constraints (latency, memory, CPU)
- ✅ Request error handling + logging

---

## 📞 PROMPT TROUBLESHOOTING

### Copilot generates Svelte 3/4 syntax (stores, reactive statements)
**Fix**: Prepend to your prompt:
```
CRITICAL: This is a Svelte 5 project using only runes ($state, $props, $effect, $derived).
Never use stores (writable, readable) or reactive statements ($:).
Use .cursorrules as strict guardrails.
```

### Windows OCR latency exceeds 30ms target
**Fix**: Ask Copilot:
```
[TIER 3A - LATENCY OPTIMIZATION]
Windows OCR currently measures 45ms per frame.
Target: <30ms latency.

Provide:
1. Profiling script to measure capture → OCR → result delivery
2. Optimization checklist (D3D11 threading, WGC batching, etc.)
3. Alternative: Run on background thread with max 1 FPS throttle
```

### Circular import in monorepo packages
**Fix**: Ask Copilot:
```
[ARCHITECTURE]
Dependency audit failed: apps/desktop imports @gaming-hud/core, 
which imports apps/desktop (circular).

Provide:
1. Dependency graph analysis
2. Refactor plan to break cycle
3. Updated tsconfig.base.json paths
```

---

## 🎓 NEXT STEPS

1. **Copy this file** to your repo: `tools/GITHUB_COPILOT_PROMPTS.md`
2. **Create subdir** `tools/PROMPTS/` with one `.md` file per phase
3. **Link from README**: "See [Copilot Prompts](./tools/GITHUB_COPILOT_PROMPTS.md) for automation"
4. **Update CLAUDE.md** after each successful phase with "Copilot ran Prompt XY"
5. **Share with team** (or your future self) on returning to the project

---

**Questions?** Refer to `.cursorrules` or ask Claude Code with this file as context.

**Ready?** Start with Phase 0A → Phase 0B → commit v0.0.1-scaffold. 🚀
