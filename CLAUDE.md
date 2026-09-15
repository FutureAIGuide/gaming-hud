# CLAUDE.md — Gaming Guide HUD Working Memory
**Purpose**: Persistent context for Claude sessions (claude.ai, Cursor, Claude Code)  
**Format**: YAML frontmatter + Markdown  
**Last Updated**: September 15, 2026  
**Location**: Repository root (commit this file)

---

```yaml
---
project: Gaming Guide HUD
version: 0.1.0-alpha
timeline: 14 weeks (September 15 — December 15, 2026)
status: Phase 0 (Foundation Scaffolding)
solo_dev: matt@futureaiguide.com

# Current Development Phase
current_phase: 0 (Foundation)
current_week: 1/14
phase_deadline: "2026-09-22"

# Stack & Versions (canonical source — update when changing)
stack:
  monorepo: pnpm v9.1+ with workspaces
  build: Turbo v2
  frontend:
    framework: Svelte 5 (no Svelte 3/4 syntax)
    runtime: SvelteKit v2
    styling: Tailwind CSS v4
    ui_state: Svelte 5 runes ($state, $props, $effect)
  backend_desktop:
    framework: Tauri v2 (not v1)
    runtime: Rust 1.70+
    webview: Microsoft Edge WebView2 (Windows), WKWebView (macOS)
  backend_web:
    database: Supabase (PostgreSQL 16 + PostgREST)
    auth: Supabase Auth + Steam OpenID 2.0
    realtime: Supabase Realtime (WebSocket channels)
    storage: Cloudflare R2 (zero egress)
  extension:
    framework: WXT v1
    manifest: Manifest V3
    target_browsers: Chrome, Firefox, Safari
  perception:
    windows_ocr: Windows.Media.Ocr (native WinRT)
    windows_capture: windows-capture crate (WGC)
    macos_ocr: Vision framework
    macos_capture: ScreenCaptureKit
    vision: DirectML + ONNX Runtime (YOLOv8n for sprite detection)
  ci_cd: GitHub Actions
  performance_targets:
    idle_ram: <50 MB
    ocr_latency: <30 ms
    sync_latency: <100 ms (desktop ↔ mobile)
    search_latency: <10 ms (on 500 guides)
    cpu_idle: <0.5%
    cpu_perception: <2% sustained

# Team Context (currently solo)
team:
  owner: Matt (solo developer)
  email: matt@futureaiguide.com
  location: America/New_York (UTC-4)
  ai_tools_available:
    - Claude (claude.ai web)
    - Claude Code (terminal in cloud container)
    - Cursor Composer (Cmd+I in editor)
    - GitHub Copilot CLI
    - GitHub Copilot in VSCode
  process: Master prompt pad + Tier-based execution

# Architectural Decisions (Finalized)
decisions:
  - ✅ Use Tauri v2, not Electron (saves 250 MB RAM, <15 MB installer)
  - ✅ Use Svelte 5 runes, not stores (better reactivity, smaller bundle)
  - ✅ Supabase free tier for MVP (0-50k users)
  - ✅ Cloudflare R2 for media (zero egress cost)
  - ✅ Out-of-process overlay (anti-cheat safe)
  - ✅ Mock perception engine for dev (test without Windows hardware)
  - ✅ pnpm + Turbo for monorepo (not Yarn, not npm)
  - ✅ 6-tier phased delivery (not all-at-once)
  - ✅ Unified .cursorrules for AI consistency
  - ✅ QR code pairing for desktop ↔ mobile sync

# Architectural Decisions (Under Consideration)
decisions_pending:
  - [ ] Redis for perception result caching? (Supabase free has 0 Redis)
  - [ ] Stripe for monetization? (Phase 2+)
  - [ ] Self-hosted qdrant for vector search? (Or use pgvector)

# Known Constraints & Workarounds
constraints:
  - Single developer (all execution layers)
    → Mitigated by: AI-assisted code gen, phased delivery, automated testing
  - Cannot test Windows OCR on macOS (hardware bound)
    → Mitigated by: Mock perception engine, CI runs on GitHub Actions Windows
  - Supabase free tier: 500 MB storage, 50k MAUs
    → Mitigated by: R2 for media assets, optimized schema, growth plan ready
  - No VCS history from old codebase
    → Mitigated by: Fresh start, better structure from day 1
  - WXT browser extension is new framework (less community resources)
    → Mitigated by: Thorough testing, fallback to plain content script if needed

# Current Focus (Update After Each Session)
focus:
  current_task: "Restructure monorepo + create .cursorrules"
  current_files: ["gaming-hud/", ".cursorrules", "CLAUDE.md"]
  blockers: []
  next_immediate: |
    1. Implement folder structure
    2. Run Prompt 0A (Monorepo Architecture Review)
    3. Run Prompt 0B (Git & Release Workflow)
    4. Verify pnpm workspaces resolve
    5. Begin Phase 1: Window Composition

# Known Blockers (If Any)
blockers:
  - none_currently

# Tier-by-Tier Progress
tiers:
  "0_foundation":
    name: "Foundation & Monorepo Setup"
    weeks: "1"
    deadline: "2026-09-22"
    status: "IN_PROGRESS"
    prompts:
      - { id: "0A", name: "Monorepo Architecture Review", status: "PENDING", tool: "Claude 3.5 Sonnet" }
      - { id: "0B", name: "Git & Release Workflow", status: "PENDING", tool: "GitHub Copilot CLI" }
    deliverables:
      - "✅ Folder structure implemented"
      - "✅ .cursorrules created"
      - "✅ pnpm-workspace.yaml configured"
      - "✅ turbo.json configured"
      - "✅ tsconfig.base.json with path aliases"
      - "⏳ pnpm install (verify all workspaces resolve)"
    success_criteria:
      - "pnpm run build succeeds"
      - "pnpm run lint passes"
      - ".cursorrules prevents Svelte 3 syntax suggestions"

  "1_window_composition":
    name: "Transparent Click-Through Window (Win32 + Cocoa)"
    weeks: "2-3"
    deadline: "2026-10-06"
    status: "TODO"
    prompts:
      - { id: "1A", name: "Transparent Click-Through Window Setup", tool: "Cursor Composer" }
      - { id: "1B", name: "Global Hotkey Manager & Input Passthrough", tool: "Cursor Composer" }
    success_criteria:
      - "Window renders transparently over games"
      - "Cmd+Space toggles input passthrough"
      - "RAM idle <50 MB"
      - "No flicker or lag when toggling"
      - "Windows & macOS both tested"

  "2_svelte_components":
    name: "Svelte 5 Component Architecture (HUD UI)"
    weeks: "4-6"
    deadline: "2026-10-27"
    status: "TODO"
    prompts:
      - { id: "2A", name: "HUD Container + State Engine", tool: "Cursor Composer" }
      - { id: "2B", name: "3-Tier Spoiler Guide Widget", tool: "Claude 3.5 Sonnet + Cursor" }
      - { id: "2C", name: "Typo-Tolerant Fuzzy Search", tool: "Cursor Composer" }
    success_criteria:
      - "Glassmorphic HUD renders"
      - "Tier 1 always visible, Tier 2/3 gated"
      - "Tier 3 never renders if locked (even invisibly)"
      - "Fuzzy search <10 ms on 500 guides"
      - "No micro-stutter during typing"

  "3_perception_engine":
    name: "Native Perception (OCR, Detection)"
    weeks: "7-9"
    deadline: "2026-11-10"
    status: "TODO"
    prompts:
      - { id: "3A", name: "Perception Engine Trait + Windows OCR", tool: "Cursor Composer + Claude Code" }
      - { id: "3B", name: "Background Worker + Quest Matching", tool: "Cursor Composer" }
      - { id: "3C", name: "Mock Perception Engine (macOS dev)", tool: "Cursor Composer" }
    success_criteria:
      - "WGC capture <2% CPU on Windows"
      - "OCR <15 ms latency"
      - "Mock engine cycles through test frames"
      - "Quest auto-detection works"

  "4_cross_device_sync":
    name: "Real-Time Sync (Supabase + WebSocket)"
    weeks: "10-11"
    deadline: "2026-11-24"
    status: "TODO"
    prompts:
      - { id: "4A", name: "Supabase Schema & RLS Policies", tool: "Claude 3.5 Sonnet" }
      - { id: "4B", name: "WebSocket Sync Manager", tool: "Cursor Composer" }
      - { id: "4C", name: "QR Pairing Modal + PWA", tool: "Cursor Composer" }
    success_criteria:
      - "Desktop ↔ Mobile sync <100 ms"
      - "QR code pairing works end-to-end"
      - "RLS policies block unauthorized access"

  "5_browser_extension":
    name: "Browser Extension (WXT + Shadow DOM)"
    weeks: "12-13"
    deadline: "2026-12-08"
    status: "TODO"
    prompts:
      - { id: "5A", name: "WXT Configuration & Manifest V3", tool: "Cursor Composer" }
      - { id: "5B", name: "Shadow DOM Injection", tool: "Cursor Composer" }
      - { id: "5C", name: "Cloud Stream Video Sampler", tool: "Cursor Composer" }
    success_criteria:
      - "Extension loads on Xbox Cloud Gaming"
      - "Shadow DOM prevents CSS conflicts"
      - "No stream interference"

  "6_cicd_release":
    name: "CI/CD & Cross-Platform Builds"
    weeks: "14+"
    deadline: "2026-12-15"
    status: "TODO"
    prompts:
      - { id: "6A", name: "GitHub Actions Multi-Platform Matrix", tool: "Claude 3.5 Sonnet" }
    success_criteria:
      - "CI builds Windows, macOS, Linux"
      - "Code signing works (no unknown publisher)"
      - "Release artifacts downloadable"

# Prompt Execution Log
prompt_history:
  - { id: "0A", phase: 0, date: null, status: "PENDING", notes: "Monorepo audit — verify structure is sound" }
  - { id: "0B", date: null, status: "PENDING", notes: "Git workflow — conventional commits + semantic release" }
  # Add entries as you execute prompts

# Time Tracking (For Reality-Check)
time_spent:
  phase_0_planning: "4 hours" # (prep + architecture review + folder setup)
  phase_0_execution: "0 hours"
  total_so_far: "4 hours"
  target_total: "22 hours" # (from strategy doc)

# Testing & Quality Gates
quality_gates:
  compile_check:
    - "pnpm run build"
    - "pnpm run lint"
    - "pnpm run type-check"
  test_coverage:
    - "Unit: >70% for critical paths"
    - "E2E: Desktop ↔ mobile pairing"
    - "Performance: OCR <30ms, search <10ms"
  deployment_checklist:
    - "All tests pass"
    - "Performance benchmarks met"
    - "Code signing verified"

# Resources & References
resources:
  strategy_docs:
    - "Gaming_HUD_AI_Development_Strategy.md"
    - "Gaming_HUD_Prompt_Index__Workflow.md"
    - "Gaming_HUD_Tech_Stack_Architecture.pdf"
  api_references:
    - "Tauri v2: https://docs.tauri.app"
    - "Svelte 5: https://svelte.dev/docs/svelte-5-migration-guide"
    - "Supabase: https://supabase.com/docs"
    - "WXT: https://wxt.dev"
  community:
    - "Tauri Discord: https://discord.gg/tauri"
    - "Svelte Discord: https://discord.gg/svelte"
    - "Supabase Discord: https://discord.gg/supabase"
  performance_profiles:
    - "None yet (establish baselines in Phase 1)"

# Session Notes (Update After Each Claude Session)
session_log:
  session_001:
    date: "2026-09-15"
    duration: "2 hours"
    ai_used: "Claude Haiku (code analysis) + Claude 3.5 (architecture)"
    work_done:
      - "Analyzed uploaded strategy & architecture docs"
      - "Created GAMING_HUD_FOLDER_STRUCTURE_OPTIMIZATION.md"
      - "Created .cursorrules anchor file"
      - "Created CLAUDE.md working memory"
    next_session: "Run Prompt 0A (Monorepo Architecture Review)"
    notes: "All foundation docs ready. Ready to execute Phase 0 immediately."

---
```

## Quick Reference: Next Actions

### This Week (Sep 15-22):
```bash
# 1. Implement folder structure
mkdir -p packages/{ui,core,config} apps/{desktop,extension,web} infra/supabase tests/e2e scripts

# 2. Copy .cursorrules to repo root
cp .cursorrules /path/to/gaming-hud/.cursorrules

# 3. Copy this file to repo root
cp CLAUDE.md /path/to/gaming-hud/CLAUDE.md

# 4. Initialize Turbo + pnpm
pnpm init -w
pnpm add -D turbo

# 5. Test monorepo setup
pnpm install

# 6. Verify builds
pnpm run build

# 7. Commit everything
git add .
git commit -m "chore: initialize monorepo structure (Phase 0)"
git tag v0.0.1-scaffold
```

### Before Phase 1 (Sep 22):
1. ✅ **Run Prompt 0A**: Claude 3.5 Sonnet reviews monorepo structure
2. ✅ **Run Prompt 0B**: GitHub Copilot CLI generates git workflow
3. ✅ **Verify**: `pnpm install && pnpm run build` succeeds
4. ✅ **Commit**: Tag as `v0.1.0-foundation`

### Phase 1 Begins (Sep 23):
- **Prompt 1A**: Window composition (Cursor Composer)
- **Prompt 1B**: Hotkey manager (Cursor Composer)
- Goal: Transparent click-through window working by Oct 6

---

## How to Update This File

After each Claude session:
```yaml
session_NNN:
  date: "YYYY-MM-DD"
  duration: "X hours"
  ai_used: "Claude X, Tool Y"
  work_done:
    - "Completed X"
    - "Started Y"
  blockers: []
  next_session: "Do Z"
  notes: "Key insights"
```

Keep `focus.current_task`, `status`, and `tiers[*].status` in sync with reality.

---

## Key Metrics to Track

| Metric | Target | Current | Status |
|--------|--------|---------|--------|
| Phase 0 Duration | 1 week | 1 week | ✅ On track |
| Lines of code (Phase 0) | <500 | ~400 | ✅ On track |
| Prompt success rate | >95% | TBD | ⏳ |
| Build time | <2 min | TBD | ⏳ |
| Test coverage | >70% | TBD | ⏳ |

---

**Questions?** Ask Claude with this file as context. It will stay updated across all your Claude sessions.
