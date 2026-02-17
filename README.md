# Moto Workforce — AI Assistant Template

Your own AI assistant, powered by [OpenClaw](https://github.com/openclaw/openclaw) and Claude.

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/westailabs/moto-workforce-template.git
cd moto-workforce-template

# 2. Run setup (will ask for your API keys)
bash setup.sh

# 3. Customize your profile
nano workspace/USER.md

# 4. Launch
docker compose up -d
```

Then message your Telegram bot — it's alive! 🏍️

## What You Need

- **Docker** (or Docker Desktop on Windows/Mac)
- **Anthropic API key** — [console.anthropic.com](https://console.anthropic.com) (~$5–20/month)
- **Telegram bot token** — create one via [@BotFather](https://t.me/BotFather)

## Setup Guides

Detailed step-by-step instructions for every platform:

| Platform | Guide | Path |
|---|---|---|
| 🪟 **Windows** | WSL2 + Docker Desktop | [docs/SETUP-WINDOWS.md](docs/SETUP-WINDOWS.md) |
| 🐧 **Ubuntu / Linux** | Bare metal (no Docker) | [docs/SETUP-UBUNTU.md](docs/SETUP-UBUNTU.md) |
| 🍎 **Mac** | Bare metal + Docker options | [docs/SETUP-MAC.md](docs/SETUP-MAC.md) |

> All guides are written for beginners — no Linux experience required.

## Workspace Files

| File | Purpose |
|---|---|
| `workspace/SOUL.md` | Assistant personality — who it is |
| `workspace/USER.md` | Your profile — **fill this in!** |
| `workspace/AGENTS.md` | Operating procedures |
| `workspace/TOOLS.md` | Tool-specific notes (starts empty) |
| `workspace/HEARTBEAT.md` | Background task checklist |
| `workspace/MEMORY.md` | Long-term memory (starts empty) |

## Commands

```bash
docker compose up -d       # Start
docker compose down        # Stop
docker compose logs -f     # View logs
docker compose restart     # Restart
```

## How It Works

This template gives you a personal AI assistant that:

- **Lives on your hardware** — your data never leaves your machine
- **Talks via Telegram** — message it like a friend
- **Remembers you** — builds long-term memory over time
- **Runs autonomously** — checks email, calendar, and more on its own
- **Is fully customizable** — edit the workspace files to make it yours

## License

MIT

---

<sub>Built by [West AI Labs](https://westailabs.com) · AI Infrastructure That Ships</sub>
