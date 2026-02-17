# Moto Workforce — Mac Setup Guide

> Deploy your own AI assistant on macOS. Works on any Mac — Intel or Apple Silicon.
> Covers both Docker and bare metal (native) installation.

---

## What You'll Need

- **macOS 13 (Ventura) or later** (older versions may work but aren't tested)
- **4GB+ free RAM** (8GB recommended)
- **Anthropic API key** (~$5-20/month depending on usage)
- **Telegram account** (for chatting with your assistant)
- **~20 minutes** of setup time

---

## Choose Your Path

| | Docker | Bare Metal |
|---|---|---|
| **Easiest for** | People who want one-click start/stop | People comfortable with Terminal |
| **Requires** | Docker Desktop (~2GB disk) | Homebrew + Node.js |
| **Runs as** | Container (isolated) | Native process |
| **Memory use** | ~500MB overhead | Minimal |

**Not sure?** Go with **Bare Metal** on Mac — it's lighter and macOS already has a great Terminal.

---

# Option A: Bare Metal (Recommended for Mac)

## Step 1: Open Terminal

- Press **Cmd + Space**, type **Terminal**, press Enter
- A window with a command prompt appears — this is where you'll type everything

## Step 2: Install Homebrew

Homebrew is the Mac package manager — it installs developer tools easily.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the prompts. It may ask for your Mac password (the one you log in with). When it finishes, it'll tell you to run a couple of commands to add Homebrew to your path — **do what it says**.

Verify it worked:
```bash
brew --version
```

## Step 3: Install Node.js and Git

```bash
brew install node git
```

Verify:
```bash
node --version   # Should show v22.x.x or higher
npm --version    # Should show 10.x.x or higher
git --version
```

## Step 4: Clone and Build OpenClaw

```bash
# Create a projects directory
mkdir -p ~/projects && cd ~/projects

# Clone OpenClaw
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# Install dependencies and build
npm install
npm run build
```

This takes a few minutes. Coffee break. ☕

## Step 5: Create Your Telegram Bot

1. Open **Telegram** on your phone or Mac
2. Search for **@BotFather** and start a chat
3. Send: `/newbot`
4. BotFather asks for a **display name** — type something like: `My AI Assistant`
5. BotFather asks for a **username** — must end in `bot`, like: `my_ai_assistant_bot`
6. BotFather gives you a **token** — looks like: `7123456789:AAHxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
7. **Copy that token** — you'll need it next

> ⚠️ Keep this token private! Anyone with it can control your bot.

## Step 6: Get an Anthropic API Key

1. Go to [console.anthropic.com](https://console.anthropic.com/)
2. Create an account (or sign in)
3. Click **API Keys** in the sidebar
4. Click **Create Key**
5. Copy the key — starts with `sk-ant-...`
6. Add billing info — typically $5-20/month for personal use

## Step 7: Configure OpenClaw

```bash
# Create config directory
mkdir -p ~/.openclaw/workspace

# Create environment file
cat > ~/.openclaw/openclaw.env << 'EOF'
# Your API keys — fill these in
ANTHROPIC_API_KEY=your-anthropic-key-here
TELEGRAM_BOT_TOKEN=your-telegram-bot-token-here

# Config directory
OPENCLAW_CONFIG_DIR=$HOME/.openclaw
OPENCLAW_WORKSPACE_DIR=$HOME/.openclaw/workspace
EOF
```

Now edit the file and paste your real keys:
```bash
nano ~/.openclaw/openclaw.env
```

Replace the placeholder values with your actual keys. Save with **Ctrl+O, Enter, Ctrl+X**.

> **Prefer TextEdit?** You can also open it with:
> ```bash
> open -a TextEdit ~/.openclaw/openclaw.env
> ```

## Step 8: Set Up Your Workspace

Copy the workspace template files into `~/.openclaw/workspace/`:

- **SOUL.md** — Your assistant's personality
- **USER.md** — Information about you (**edit this!**)
- **AGENTS.md** — Operating procedures
- **TOOLS.md** — Tool notes (starts empty)
- **MEMORY.md** — Long-term memory (starts empty)
- **HEARTBEAT.md** — Background tasks

**Important:** Open `USER.md` and fill in your details:
```bash
nano ~/.openclaw/workspace/USER.md
```

## Step 9: First Run

```bash
cd ~/projects/openclaw

# Load environment
source ~/.openclaw/openclaw.env

# Start OpenClaw
node dist/index.js gateway --port 18789
```

You should see the gateway starting and connecting to Telegram.

### Pair with Telegram

1. Open Telegram and find your bot
2. Send `/start`
3. Follow the pairing instructions shown in Terminal

## Step 10: Run on Startup (Optional but Recommended)

### Using a Launch Daemon (runs even when not logged in)

```bash
cat > ~/Library/LaunchAgents/com.westailabs.openclaw.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.westailabs.openclaw</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.nvm/versions/node/v24.12.0/bin/node</string>
        <string>$HOME/projects/openclaw/dist/index.js</string>
        <string>gateway</string>
        <string>--port</string>
        <string>18789</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$HOME/projects/openclaw</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>HOME</key>
        <string>$HOME</string>
    </dict>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.openclaw/logs/openclaw.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.openclaw/logs/openclaw-error.log</string>
</dict>
</plist>
EOF

# Create log directory
mkdir -p ~/.openclaw/logs

# Find your actual node path and update the plist
NODE_PATH=$(which node)
sed -i '' "s|\\$HOME/.nvm/versions/node/v24.12.0/bin/node|$NODE_PATH|g" ~/Library/LaunchAgents/com.westailabs.openclaw.plist

# Expand $HOME in the plist
sed -i '' "s|\$HOME|$HOME|g" ~/Library/LaunchAgents/com.westailabs.openclaw.plist

# Load it
launchctl load ~/Library/LaunchAgents/com.westailabs.openclaw.plist
```

> **Note:** The plist needs your actual API keys. You can either add them to the `EnvironmentVariables` dict in the plist, or source them from the env file in a wrapper script.

### Check it's running:
```bash
launchctl list | grep openclaw
```

### Stop it:
```bash
launchctl unload ~/Library/LaunchAgents/com.westailabs.openclaw.plist
```

### View logs:
```bash
tail -f ~/.openclaw/logs/openclaw.log
```

---

# Option B: Docker

## Step 1: Install Docker Desktop

1. Go to [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
2. Download **Docker Desktop for Mac** (it auto-detects Intel vs Apple Silicon)
3. Open the `.dmg`, drag Docker to Applications
4. Launch **Docker Desktop** from Applications
5. Follow the setup wizard — accept the terms, skip the survey
6. Wait until the Docker icon in your menu bar shows a **green dot** (running)

## Step 2: Get Your Keys

Follow **Steps 5 and 6** from the Bare Metal section above to get:
- Telegram bot token from BotFather
- Anthropic API key from console.anthropic.com

## Step 3: Clone the Template

```bash
# Open Terminal (Cmd+Space, type Terminal)
mkdir -p ~/projects && cd ~/projects

# Clone the deployment template
git clone https://github.com/westailabs/moto-workforce-template.git
cd moto-workforce-template
```

## Step 4: Configure

```bash
# Copy the example env file
cp .env.example .env

# Edit with your keys
nano .env
```

Fill in your `ANTHROPIC_API_KEY` and `TELEGRAM_BOT_TOKEN`. Save with **Ctrl+O, Enter, Ctrl+X**.

## Step 5: Edit Your Profile

```bash
nano workspace/USER.md
```

Fill in the `[FILL IN]` sections with your name, timezone, preferences, etc.

## Step 6: Launch

```bash
docker compose up -d
```

That's it. Your assistant is running.

### Check it's working:
```bash
docker compose logs -f
```

### Stop it:
```bash
docker compose down
```

### Restart it:
```bash
docker compose restart
```

---

## Updating

### Bare Metal:
```bash
cd ~/projects/openclaw
git pull
npm install
npm run build
# Restart via launchctl or manually
```

### Docker:
```bash
cd ~/projects/moto-workforce-template
docker compose pull
docker compose up -d
```

---

## Troubleshooting

### "command not found: brew"
Close Terminal and reopen it. Or run the command Homebrew told you to run after installation (usually something like `eval "$(/opt/homebrew/bin/brew shellenv)"`).

### "command not found: node"
Close Terminal and reopen it. If you installed via Homebrew: `brew install node`.

### Docker Desktop won't start
- Make sure you have macOS 13+ 
- Check System Settings → Privacy & Security for any blocked installs
- Try: `killall Docker && open -a Docker`

### Bot not responding
- Check your token is correct in `.env` or `openclaw.env`
- Bare metal: check the Terminal output for errors
- Docker: run `docker compose logs -f`

### "Port already in use"
Something else is using port 18789. Either stop that process or change the port:
- Bare metal: `node dist/index.js gateway --port 18790`
- Docker: edit `docker-compose.yml` and change the port mapping

### Mac goes to sleep and bot stops responding
- System Settings → Energy → Prevent automatic sleeping when the display is off ✅
- Or: keep Docker Desktop running (it prevents sleep while containers are active)

---

## What's Next?

- **Customize your assistant** — Edit `SOUL.md` for personality, `USER.md` for your context
- **Add skills** — Drop skill folders into the workspace
- **Connect more channels** — Discord, Signal, WhatsApp, and more

---

<sub>Built by West AI Labs · westailabs.com</sub>
