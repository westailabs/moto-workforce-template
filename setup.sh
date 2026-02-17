#!/usr/bin/env bash
set -e

echo "============================================"
echo "  Moto Workforce — Setup"
echo "  Your AI assistant, ready in minutes."
echo "============================================"
echo ""

# --- Check prerequisites ---

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    echo "   Install Docker Desktop: https://www.docker.com/products/docker-desktop/"
    echo "   Then re-run this script."
    exit 1
fi

if ! docker info &> /dev/null 2>&1; then
    echo "❌ Docker is installed but not running."
    echo "   Start Docker Desktop and wait for it to be ready, then re-run this script."
    exit 1
fi

echo "✅ Docker is installed and running."
echo ""

# --- Collect API keys ---

ENV_FILE=".env"

if [ -f "$ENV_FILE" ]; then
    echo "Found existing .env file."
    read -rp "Overwrite it? (y/N): " overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo "Keeping existing .env. Skipping key setup."
        echo ""
    else
        rm "$ENV_FILE"
    fi
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "Let's set up your API keys."
    echo ""

    # Anthropic
    echo "1) Anthropic API Key"
    echo "   Get one at: https://console.anthropic.com/"
    echo "   It starts with: sk-ant-"
    echo ""
    read -rp "   Paste your Anthropic API key: " anthropic_key

    if [ -z "$anthropic_key" ]; then
        echo "❌ API key cannot be empty. Re-run setup when you have it."
        exit 1
    fi

    echo ""

    # Telegram
    echo "2) Telegram Bot Token"
    echo "   Create a bot: open Telegram, search @BotFather, send /newbot"
    echo "   It looks like: 1234567890:ABCdefGHIjklMNOpqrSTUvwxYZ"
    echo ""
    read -rp "   Paste your Telegram bot token: " telegram_token

    if [ -z "$telegram_token" ]; then
        echo "❌ Bot token cannot be empty. Re-run setup when you have it."
        exit 1
    fi

    # Write .env
    cat > "$ENV_FILE" <<EOF
ANTHROPIC_API_KEY=${anthropic_key}
TELEGRAM_BOT_TOKEN=${telegram_token}
EOF

    echo ""
    echo "✅ API keys saved to .env"
fi

# --- Create config directory ---

mkdir -p config

echo ""
echo "============================================"
echo "  ✅ Setup complete!"
echo ""
echo "  Next steps:"
echo "    1. Edit workspace/USER.md with your info"
echo "    2. Run: docker compose up -d"
echo "    3. Message your bot on Telegram!"
echo "============================================"
