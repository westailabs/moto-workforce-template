# Moto Workforce — Windows Setup Guide

> **Who this is for:** You use Windows every day, but you've never touched Linux or Docker. That's totally fine. This guide walks you through everything step by step.
>
> **What you'll get:** Your own AI assistant (powered by OpenClaw) running on your Windows PC, connected to Telegram so you can chat with it from your phone or desktop.
>
> **Time needed:** About 30–45 minutes, plus some waiting for downloads.

---

## What You'll Need

- **Windows 10** (version 2004 or later) or **Windows 11**
- An internet connection
- A credit card for the Anthropic API (roughly **$5–20/month** depending on how much you chat — you set your own limits)
- The **Telegram** app on your phone or computer (free)

---

## Step 1: Enable WSL2 (Windows Subsystem for Linux)

WSL2 lets you run Linux inside Windows — think of it as a little Linux computer living inside your PC. You need this because OpenClaw runs on Linux.

### How to do it:

1. **Open PowerShell as Administrator:**
   - Click the **Start** button (Windows icon, bottom-left)
   - Type **PowerShell**
   - Right-click **Windows PowerShell** and choose **Run as administrator**
   - Click **Yes** when Windows asks for permission

2. **Run this command** (copy and paste the whole line, then press Enter):
   ```
   wsl --install
   ```
   This installs WSL2 and Ubuntu (a popular version of Linux) automatically.

3. **Restart your computer** when it asks you to. This is required — don't skip it.

### After restarting:

4. Windows will automatically open an Ubuntu window. It'll ask you to create a **username** and **password**.
   - Pick something simple you'll remember (e.g., username: `moto`, password: `moto123`)
   - **Important:** When you type your password, nothing will appear on screen — no dots, no stars, nothing. That's normal! Just type it and press Enter.
   - You'll type the password twice to confirm.

5. You should see something like:
   ```
   moto@YOURPC:~$
   ```
   That's your Linux terminal. Congrats — you're running Linux! 🎉

> **💡 Tip:** You can always open Ubuntu again later by searching for "Ubuntu" in the Start menu.

---

## Step 2: Install Docker Desktop

Docker is a tool that runs applications in "containers" — like lightweight virtual machines. OpenClaw runs inside a Docker container.

### How to do it:

1. **Download Docker Desktop for Windows:**
   - Go to: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
   - Click **Download for Windows**

2. **Run the installer:**
   - Double-click the downloaded file
   - Make sure **"Use WSL 2 instead of Hyper-V"** is checked (it should be by default)
   - Click **Ok** and let it install
   - Restart your computer if asked

3. **Start Docker Desktop:**
   - It should start automatically after install
   - Look for the whale icon 🐳 in your system tray (bottom-right of your screen)
   - Wait until it says **"Docker Desktop is running"** — this can take a minute

4. **Verify Docker works in Ubuntu:**
   - Open your Ubuntu terminal (search "Ubuntu" in Start menu)
   - Type:
     ```
     docker --version
     ```
   - You should see something like `Docker version 24.x.x` — you're good!

---

## Step 3: Create a Telegram Bot

Your AI assistant lives in Telegram. You need to create a "bot" — basically a Telegram account for your assistant.

### How to do it:

1. **Open Telegram** (phone or desktop app)

2. **Search for `@BotFather`** — this is Telegram's official bot-making tool. Look for the one with a blue checkmark ✓

3. **Start a chat** with BotFather and send:
   ```
   /newbot
   ```

4. **Choose a display name** — this is what people see. Examples:
   - `My AI Assistant`
   - `Moto`
   - `Work Helper`

5. **Choose a username** — this must end in `bot`. Examples:
   - `my_work_assistant_bot`
   - `moto_helper_bot`
   - It needs to be unique, so you might need to try a few

6. **BotFather will give you a token** — it looks something like:
   ```
   7783219013:AAEhV3jZ7SIPTimGFEl0hM6sTljwiXLNGQ4
   ```
   **Copy this token and save it somewhere safe** (like a note on your phone). You'll need it in Step 5.

> **⚠️ Keep your bot token secret!** Anyone with this token can control your bot. If it leaks, go back to BotFather and use `/revoke` to get a new one.

---

## Step 4: Get an Anthropic API Key

Anthropic makes Claude, the AI that powers your assistant. You need an API key to connect.

### How to do it:

1. **Go to:** [https://console.anthropic.com/](https://console.anthropic.com/)

2. **Create an account** (or sign in if you have one)

3. **Add billing:**
   - Go to **Settings → Billing**
   - Add a credit card
   - **Cost:** Roughly **$5–20/month** depending on usage. Light chatting is closer to $5; heavy daily use might hit $20. You can set spending limits to cap it.

4. **Create an API key:**
   - Go to **Settings → API Keys**
   - Click **Create Key**
   - Give it a name like `moto-assistant`
   - **Copy the key** — it starts with `sk-ant-` and you can only see it once!
   - Save it alongside your Telegram bot token

---

## Step 5: Set Up Your Assistant

Now let's put it all together!

### Open your Ubuntu terminal and run these commands one at a time:

1. **Download the deployment template:**
   ```bash
   cd ~
   git clone https://github.com/westailabs/moto-workforce-template.git moto-assistant
   cd moto-assistant
   ```

2. **Run the setup script:**
   ```bash
   bash setup.sh
   ```
   The script will:
   - Check that Docker is installed
   - Ask you to paste your **Anthropic API key**
   - Ask you to paste your **Telegram bot token**
   - Create your configuration file

3. **Customize your profile:**
   ```bash
   nano workspace/USER.md
   ```
   This opens a simple text editor. Fill in the `[FILL IN]` placeholders with your info — your name, timezone, what you'd like help with, etc.
   - To save: press `Ctrl+O`, then `Enter`
   - To exit: press `Ctrl+X`

---

## Step 6: Start Your Assistant

```bash
docker compose up -d
```

That's it! Your assistant is now running in the background.

### Pair with Telegram:

1. Open Telegram and find your bot (search for the username you created in Step 3)
2. Send it a message — say `hello`
3. The bot should respond! 🎉

### Useful commands:

| What you want to do | Command (run in Ubuntu) |
|---|---|
| Start the assistant | `cd ~/moto-assistant && docker compose up -d` |
| Stop the assistant | `cd ~/moto-assistant && docker compose down` |
| See if it's running | `cd ~/moto-assistant && docker compose ps` |
| View logs (if something's wrong) | `cd ~/moto-assistant && docker compose logs -f` |
| Restart after changes | `cd ~/moto-assistant && docker compose restart` |

> **💡 Tip:** Your assistant keeps running even if you close the Ubuntu window. It stops when you shut down your PC or run `docker compose down`.

---

## Troubleshooting

### "WSL 2 requires an update to its kernel component"
- Download the update from: [https://aka.ms/wsl2kernel](https://aka.ms/wsl2kernel)
- Run the installer, then try `wsl --install` again

### "Please enable the Virtual Machine Platform Windows feature"
Your computer's virtualization might be turned off. You need to enable it in BIOS:
1. Restart your computer
2. During startup, press the BIOS key (usually **F2**, **F10**, **F12**, or **Delete** — it flashes on screen briefly)
3. Find a setting called **Virtualization Technology**, **Intel VT-x**, **AMD-V**, or **SVM Mode**
4. Set it to **Enabled**
5. Save and exit (usually F10)

> This varies by computer manufacturer. If you're stuck, search "[your computer brand] enable virtualization" on YouTube.

### Docker Desktop won't start
- Make sure WSL2 is installed and running: open PowerShell and run `wsl --status`
- Make sure you restarted after installing WSL2
- Try: Settings → General → check **"Use the WSL 2 based engine"**

### Docker commands say "permission denied"
In your Ubuntu terminal, run:
```bash
sudo usermod -aG docker $USER
```
Then **close and reopen** the Ubuntu terminal.

### WSL is using too much memory
Create a file at `C:\Users\YourUsername\.wslconfig` (use Notepad) with:
```
[wsl2]
memory=4GB
```
Then restart WSL: open PowerShell and run `wsl --shutdown`, then reopen Ubuntu.

### Bot doesn't respond in Telegram
- Check the logs: `docker compose logs -f`
- Make sure your bot token is correct in the `.env` file
- Make sure Docker is running (whale icon in system tray)
- Try restarting: `docker compose restart`

### "Cannot connect to the Docker daemon"
Docker Desktop isn't running. Open it from the Start menu and wait for the whale icon to appear.

### Need more help?
- Check the OpenClaw docs: [https://openclaw.com/docs](https://openclaw.com/docs)
- Ask in the community: [https://discord.gg/openclaw](https://discord.gg/openclaw)

---

## What's Next?

Now that your assistant is running:

- **Customize its personality** by editing `workspace/SOUL.md`
- **Give it context about you** by filling in `workspace/USER.md`
- **Set up recurring tasks** in `workspace/HEARTBEAT.md`
- **Teach it your tools** by adding notes to `workspace/TOOLS.md`

The more context you give it, the more useful it becomes. Think of it like onboarding a new employee — the more you tell it about your world, the better it can help.

---

*Built by West AI Labs · Powered by OpenClaw + Claude*
