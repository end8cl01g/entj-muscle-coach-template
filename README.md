# ENTJ Muscle Coach Hook System

> 💪 Your Personal AI Fitness Coach with ENTJ Personality

A complete Hook system for OpenClaw that injects ENTJ personality traits into all responses. Designed to help you achieve muscle-up with maximum efficiency through data-driven training, strict discipline, and strategic planning.

---

## 🚀 Quick Start

### 1. Install Hook

```bash
# Clone the template
git clone https://github.com/end8cl01g/entj-muscle-coach-template.git

# Copy to OpenClaw workspace
cp -r entj-muscle-coach-template ~/.openclaw/workspace/hooks/entj-muscle-coach
```

### 2. Enable Hook

```bash
openclaw hooks enable entj-muscle-coach
```

### 3. Configure (Optional)

Edit `config/project-config.json` to customize settings.

### 4. Verify

```bash
openclaw hooks list
```

---

## ✨ Features

| Feature | Description | Status |
|---------|-------------|--------|
| Identity Injection | All responses use ENTJ coach personality | ✅ |
| State Persistence | Auto-save training progress, goals, data | ✅ |
| Cron Reminders | Morning/evening workouts, weekly review | ✅ |
| Cloud Sync | Git/WebDAV/S3/Dropbox/Google Drive | ✅ |
| Version Tracking | Semantic versioning + Changelog | ✅ |
| Bioclock System | Training hours, periodization | ✅ |
| Auto Install | Adaptive environment detection | ✅ |
| Project Packaging | One-click打包 entire project | ✅ |
| Technical Docs | Complete knowledge base + Muscle-Up training | ✅ |

---

## 📁 Directory Structure

```
hooks/entj-muscle-coach/
├── HOOK.md                 # Hook main file
├── identity.md             # ENTJ coach identity definition
├── README.md               # This file
├── handler.ts              # TypeScript Hook handler
├── state/                  # State persistence
│   ├── current-state.json  # Current training state
│   ├── workout-log.md      # Workout log
│   └── goals.md            # Goal setting
├── cron/                   # Cron jobs
│   └── reminders.json      # Reminder config
├── sync/                   # Cloud sync
│   └── sync-config.json    # Sync config
├── version/                # Version tracking
│   └── changelog.md        # Changelog
├── bioclock/               # Bioclock
│   └── rhythm-config.json  # Training rhythm config
├── scripts/                # Automation scripts
│   ├── setup.sh            # Install script
│   ├── sync.sh             # Sync script
│   └── package.sh          # Package script
├── config/                 # Config
│   └── project-config.json # Project config
└── docs/                   # Documentation
    └── technical-knowledge.md # Technical docs
```

---

## 🧠 ENTJ Personality Traits

| Dimension | Trait | Coaching Style |
|-----------|-------|----------------|
| **E** (Extraverted) | Direct communication | Clear instructions, no nonsense |
| **N** (Intuitive) | Strategic thinking | Long-term planning, systematic training |
| **T** (Thinking) | Logical decisions | Data-driven, efficiency first |
| **J** (Judging) | Structured execution | Strict discipline, goal-oriented |

### Core Mottos

- ⚡ **Efficiency First** - No wasted training
- 🎯 **Results Only** - Excuses don't build muscle
- 💪 **Discipline Always** - Discipline gives freedom
- 🧠 **Strategic Planning** - No plan = just sweating
- 📢 **Direct Communication** - I say what's useful, not what's nice

---

## 🎯 16-Week Muscle-Up Program

| Phase | Weeks | Focus | Goal |
|-------|-------|-------|------|
| **Base Strength** | 1-4 | Pull/push foundation | Pull-ups 10+ |
| **Explosive Power** | 5-8 | High pulls, explosive | Chest-to-bar 5+ |
| **Technical Transition** | 9-12 | Transition movement | 3s control |
| **Full Movement** | 13-16 | Complete muscle-up | 3 consecutive |

---

## ⚙️ Configuration

### Project Config (`config/project-config.json`)

| Option | Type | Description | Default |
|--------|------|-------------|---------|
| `workspace.restrictReadWrite` | boolean | Restrict read/write to hooks directory | true |
| `persistence.enabled` | boolean | Enable state persistence | true |
| `cron.enabled` | boolean | Enable Cron jobs | true |
| `sync.enabled` | boolean | Enable cloud sync | false |
| `bioclock.enabled` | boolean | Enable bioclock system | true |

### Cloud Sync Setup

Edit `sync/sync-config.json`:

```json
{
  "enabled": true,
  "provider": "git",
  "config": {
    "git": {
      "enabled": true,
      "remote": "YOUR_REPO_URL",
      "branch": "main"
    }
  }
}
```

Then run:
```bash
./scripts/sync.sh
```

---

## 📦 Scripts

### setup.sh

Adaptive installation script:
```bash
./scripts/setup.sh
```

### sync.sh

Cloud sync script:
```bash
./scripts/sync.sh
```

### package.sh

Project packaging:
```bash
./scripts/package.sh
```

---

## 🔧 Troubleshooting

### Hook Not Triggering

```bash
# Check hook status
openclaw hooks list

# Restart Gateway
openclaw gateway restart
```

### State Not Saving

```bash
# Check permissions
ls -la state/

# Validate JSON
jq . state/current-state.json
```

### Sync Failed

```bash
# Check config
cat sync/sync-config.json | jq .

# Test connection
git ls-remote <remote>
```

For detailed troubleshooting, see [docs/technical-knowledge.md](docs/technical-knowledge.md)

---

## 💪 Training Philosophy

### Progressive Overload

```
Week 1: Learn movements, build habits
Week 2: Pull-ups 4-5 reps
Week 3: Pull-ups 6-7 reps
Week 4: Pull-ups 8-10 reps
```

### Core Principles

1. **Progressive Overload** - Every week must be stronger
2. **Compound First** - Pull-ups, dips, presses
3. **Quality > Quantity** - Proper form over cheating
4. **Recovery = Training** - Sleep, nutrition, active recovery

---

## 📄 License

MIT License

---

## 🤝 Contributing

Contributions welcome!

- GitHub Issues: https://github.com/end8cl01g/entj-muscle-coach-template/issues
- OpenClaw Discord: https://discord.com/invite/clawd
- Docs: https://docs.openclaw.ai

---

**Version**: 1.0.0  
**Author**: workspace-hooks  
**Last Updated**: 2026-04-03  
**Mission**: Maximum efficiency to achieve muscle-up
