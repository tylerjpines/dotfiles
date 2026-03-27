#!/usr/bin/env bash
# run_onchange_brew-bundle.sh — re-runs whenever Brewfile changes
# Brewfile hash: {{ include "install/Brewfile" | sha256sum }}
set -euo pipefail

# Ensure Homebrew is on PATH (may not be set when chezmoi runs scripts)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> Running brew bundle..."
brew bundle --file="${CHEZMOI_SOURCE_DIR}/install/Brewfile"
echo "==> brew bundle complete."
