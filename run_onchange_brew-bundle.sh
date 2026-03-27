#!/usr/bin/env bash
# run_onchange_brew-bundle.sh — re-runs whenever Brewfile changes
# Brewfile hash: {{ include "install/Brewfile" | sha256sum }}
set -euo pipefail

echo "==> Running brew bundle..."
brew bundle --file="${CHEZMOI_SOURCE_DIR}/install/Brewfile"
echo "==> brew bundle complete."
