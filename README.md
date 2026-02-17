# Moto Workforce — AI Assistant Template

Your own AI assistant, powered by [OpenClaw](https://openclaw.com) and Claude.

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

## Windows Users

See the full step-by-step guide: [Windows Setup Guide](docs/product/moto-workforce-windows-setup.md)

## Files

| File | Purpose |
|---|---|
| `docker-compose.yml` | Container configuration |
| `.env.example` | Template for API keys |
| `setup.sh` | Interactive setup script |
| `workspace/SOUL.md` | Assistant personality |
| `workspace/USER.md` | Your profile (fill this in!) |
| `workspace/AGENTS.md` | Operating instructions |
| `workspace/TOOLS.md` | Tool-specific notes |
| `workspace/HEARTBEAT.md` | Recurring task checklist |
| `workspace/MEMORY.md` | Long-term memory (starts empty) |

## Commands

```bash
docker compose up -d       # Start
docker compose down        # Stop
docker compose logs -f     # View logs
docker compose restart     # Restart
```

---

*Built by West AI Labs*
