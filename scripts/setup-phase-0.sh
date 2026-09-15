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
  mkdir -p "$dir"
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
echo "2. Verify workspace linking"
echo "3. Run: pnpm run type-check"
echo "4. Commit: git add . && git commit -m 'chore: init monorepo structure'"
