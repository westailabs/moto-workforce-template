# Moto Workforce — Bare Metal Setup Guide (Ubuntu / WSL2)

> **Who this is for:** You want to run your AI assistant directly on Ubuntu — no Docker needed. This works on a native Ubuntu install OR inside WSL2 on Windows.
>
> **Why bare metal?** Simpler, lighter, faster. No Docker overhead. Easier to debug. Great for a dedicated machine or a WSL2 setup where you don't want Docker Desktop eating your RAM.
>
> **Time needed:** About 30–45 minutes.

---

## What You'll Need

- **Ubuntu 22.04 or 24.04** (either native or via WSL2 on Windows)
- An internet connection
- A credit card for the Anthropic API (roughly **$5–20/month** depending on usage)
- The **Telegram** app (free)

> **Windows users:** If you don't have WSL2 yet, follow Steps 1–4 of the [Windows Docker Setup Guide](moto-workforce-windows-setup.md) to get Ubuntu running, then come back here and skip Docker entirely.

---

## Step 1: Install Node.js via nvm

OpenClaw runs on Node.js. We'll use **nvm** (Node Version Manager) to install it — this keeps things clean and easy to update.

### Open your Ubuntu terminal and run:

1. **Install nvm:**
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
   ```

2. **Reload your terminal** (so nvm becomes available):
   ```bash
   source ~/.bashrc
   ```

3. **Install Node.js 24** (the version OpenClaw uses):
   ```bash
   nvm install 24
   ```

4. **Verify it works:**
   ```bash
   node --version
   ```
   You should see something like `v24.12.0`. 

> **What just happened?** You installed a JavaScript runtime (Node.js) that OpenClaw needs to run. nvm lets you manage multiple versions easily.

---

## Step 2: Install Git and Clone OpenClaw

1. **Install git** (if not already installed):
   ```bash
   sudo apt update && sudo apt install -y git
   ```

2. **Clone the OpenClaw repository:**
   ```bash
   git clone https://github.com/openclaw/openclaw.git ~/openclaw
   ```

3. **Enter the directory and check it's ready:**
   ```bash
   cd ~/openclaw
   ls dist/index.js
   ```
   If you see `dist/index.js` listed, OpenClaw is ready to run. If not, you may need to build it:
   ```bash
   npm install
   npm run build
   ```

> **What is OpenClaw?** It's the engine that powers your AI assistant — it handles conversations, memory, tools, and connections to services like Telegram.

---

## Step 3: Create a Telegram Bot

Your assistant lives in Telegram. You need to create a "bot" account for it.

1. **Open Telegram** and search for **@BotFather** (blue checkmark ✓)

2. **Send** `/newbot`

3. **Pick a display name** — e.g., "My Assistant" or "Moto"

4. **Pick a username** ending in `bot` — e.g., `my_helper_bot`

5. **Copy the token** BotFather gives you (looks like `1234567890:ABCdefGHIjklMNOpqr`). Save it somewhere safe.

> **⚠️ Keep your bot token secret!** If it leaks, use `/revoke` in BotFather to get a new one.

---

## Step 4: Get an Anthropic API Key

1. Go to [console.anthropic.com](https://console.anthropic.com/)
2. Create an account, add billing (**Settings → Billing**)
3. Create an API key (**Settings → API Keys** → **Create Key**)
4. Copy the key (starts with `sk-ant-`) — you only see it once!

> **Cost:** ~$5–20/month depending on usage. You can set spending limits in the console.

---

## Step 5: Set Up the Workspace

1. **Download the Moto Workforce template:**
   ```bash
   git clone https://github.com/westailabs/moto-workforce-template.git ~/moto-workspace-template
   ```

2. **Create the OpenClaw config directory and workspace:**
   ```bash
   mkdir -p ~/.openclaw/workspace
   ```

3. **Copy the template workspace files:**
   ```bash
   cp ~/moto-workspace-template/workspace/* ~/.openclaw/workspace/
   ```

4. **Edit your profile** — tell the assistant who you are:
   ```bash
   nano ~/.openclaw/workspace/USER.md
   ```
   Fill in the `[FILL IN]` placeholders with your name, timezone, preferences, etc.
   - Save: `Ctrl+O` then `Enter`
   - Exit: `Ctrl+X`

---

## Step 6: Configure OpenClaw

1. **Create the environment file:**
   ```bash
   cat > ~/.openclaw/openclaw.env << 'EOF'
   # OpenClaw Environment Configuration

   # Anthropic API Key (starts with sk-ant-)
   ANTHROPIC_API_KEY=PASTE_YOUR_KEY_HERE

   # Config and workspace directories
   OPENCLAW_CONFIG_DIR=/home/$USER/.openclaw
   OPENCLAW_WORKSPACE_DIR=/home/$USER/.openclaw/workspace
   HOME=/home/$USER
   EOF
   ```

   Now edit it to paste your actual API key:
   ```bash
   nano ~/.openclaw/openclaw.env
   ```
   Replace `PASTE_YOUR_KEY_HERE` with your real key.

2. **Run the OpenClaw onboarding wizard:**
   ```bash
   cd ~/openclaw
   node dist/index.js onboard
   ```
   This will walk you through initial setup — connecting Telegram, setting your assistant's name, etc. When it asks for your Telegram bot token, paste the one from Step 3.

> **What's the wizard do?** It creates `~/.openclaw/openclaw.json` with your full configuration — channels, plugins, auth settings, etc. It's easier than editing JSON by hand.

---

## Step 7: Test It

Start OpenClaw manually first to make sure everything works:

```bash
cd ~/openclaw
node dist/index.js gateway --bind localhost --port 18789
```

You should see log output showing the gateway starting up. Open Telegram and message your bot — it should respond!

Press `Ctrl+C` to stop it once you've confirmed it works.

---

## Step 8: Run as a Systemd Service (Recommended)

Running OpenClaw as a **systemd service** means it starts automatically when your computer boots and restarts if it crashes. This is how you make it "always on."

1. **Create the service file:**
   ```bash
   sudo tee /etc/systemd/system/openclaw.service > /dev/null << EOF
   [Unit]
   Description=OpenClaw Gateway (Moto)
   After=network-online.target
   Wants=network-online.target

   [Service]
   Type=simple
   User=$USER
   Group=$USER
   WorkingDirectory=$HOME/openclaw
   EnvironmentFile=$HOME/.openclaw/openclaw.env
   ExecStart=$(which node) dist/index.js gateway --bind localhost --port 18789
   Restart=always
   RestartSec=5

   [Install]
   WantedBy=multi-user.target
   EOF
   ```

2. **Enable and start the service:**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable openclaw
   sudo systemctl start openclaw
   ```

3. **Check that it's running:**
   ```bash
   sudo systemctl status openclaw
   ```
   You should see `Active: active (running)` in green. 🎉

### Useful service commands:

| What you want to do | Command |
|---|---|
| Check status | `sudo systemctl status openclaw` |
| Stop the assistant | `sudo systemctl stop openclaw` |
| Restart | `sudo systemctl restart openclaw` |
| View logs | `journalctl -u openclaw -f` |
| Disable auto-start | `sudo systemctl disable openclaw` |

> **⚠️ WSL2 note:** Systemd works in WSL2 on Windows 11 (and recent Windows 10 builds). If `systemctl` gives an error, you may need to enable systemd in WSL. Create or edit `/etc/wsl.conf`:
> ```
> [boot]
> systemd=true
> ```
> Then restart WSL: open PowerShell and run `wsl --shutdown`, then reopen Ubuntu.

---

## Troubleshooting

### "nvm: command not found"
Close and reopen your terminal, or run:
```bash
source ~/.bashrc
```

### "node: command not found" after installing via nvm
Make sure nvm loaded the right version:
```bash
nvm use 24
```

### OpenClaw won't start — "Cannot find module"
You may need to build from source:
```bash
cd ~/openclaw
npm install
npm run build
```

### Bot doesn't respond in Telegram
- Check logs: `journalctl -u openclaw -f` (or look at terminal output if running manually)
- Verify your bot token is correct in `~/.openclaw/openclaw.json`
- Make sure only one instance of OpenClaw is running

### systemctl says "System has not been booted with systemd"
You're on WSL2 without systemd enabled. See the WSL2 note in Step 8 above.
As a workaround, you can run OpenClaw manually in a `tmux` or `screen` session:
```bash
sudo apt install -y tmux
tmux new -s openclaw
cd ~/openclaw && node dist/index.js gateway --bind localhost --port 18789
# Press Ctrl+B then D to detach (it keeps running)
# Use "tmux attach -t openclaw" to reconnect
```

### WSL2 is using too much memory
Create `C:\Users\YourUsername\.wslconfig` with Notepad:
```
[wsl2]
memory=4GB
```
Then restart WSL from PowerShell: `wsl --shutdown`

### Need more help?
- OpenClaw docs: [https://openclaw.com/docs](https://openclaw.com/docs)
- Community: [https://discord.gg/openclaw](https://discord.gg/openclaw)

---

## What's Next?

- **Customize the personality** — edit `~/.openclaw/workspace/SOUL.md`
- **Set up recurring tasks** — edit `~/.openclaw/workspace/HEARTBEAT.md`
- **Add tool notes** — edit `~/.openclaw/workspace/TOOLS.md`
- **Give it more context about you** — flesh out `~/.openclaw/workspace/USER.md`

The more you tell it about your world, the better it can help.

---

*Built by West AI Labs · Powered by OpenClaw + Claude*
