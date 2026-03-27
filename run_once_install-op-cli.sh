#!/usr/bin/env bash
set -euo pipefail

# Install 1Password CLI if not present
if ! command -v op &>/dev/null; then
  echo "==> Installing 1Password CLI..."
  brew install 1password-cli
fi

echo ""
echo "============================================================"
echo "  1Password SSH Agent Setup"
echo "============================================================"
echo ""
echo "To use 1Password as your SSH agent:"
echo ""
echo "  1. Open 1Password"
echo "  2. Go to Settings > Developer"
echo "  3. Enable 'Use the SSH Agent'"
echo "  4. Import your SSH key:"
echo "     - In 1Password, click '+' > SSH Key"
echo "     - Import from: ~/.ssh/id_ed25519"
echo "  5. After importing, you can delete the plaintext key:"
echo "     rm ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub"
echo ""
echo "  Your SSH config already points to the 1Password agent socket."
echo ""
