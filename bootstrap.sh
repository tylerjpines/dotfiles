#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REPO="https://github.com/tylerjpines/dotfiles.git"

echo ""
echo "============================================================"
echo "  Mac Bootstrap — tylerjpines/dotfiles"
echo "============================================================"
echo ""

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "==> Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "    Waiting for Xcode CLT install to complete..."
  until xcode-select -p &>/dev/null; do sleep 5; done
  echo "    Xcode CLT installed."
else
  echo "==> Xcode Command Line Tools already installed."
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "==> Homebrew already installed."
fi

# 3. chezmoi
if ! command -v chezmoi &>/dev/null; then
  echo "==> Installing chezmoi..."
  brew install chezmoi
else
  echo "==> chezmoi already installed."
fi

# 4. mise (needed early for runtime activation)
if ! command -v mise &>/dev/null; then
  echo "==> Installing mise..."
  brew install mise
else
  echo "==> mise already installed."
fi

# 5. Clean up old dotbot symlinks (if any)
echo "==> Checking for old dotbot symlinks..."
DOTFILES_CANDIDATES=(
  "$HOME/.zshrc"
  "$HOME/.bashrc"
  "$HOME/.bash_profile"
  "$HOME/.gitconfig"
  "$HOME/.gitignore_global"
  "$HOME/.p10k.zsh"
  "$HOME/.vimrc"
  "$HOME/.ssh/config"
)
for f in "${DOTFILES_CANDIDATES[@]}"; do
  if [[ -L "$f" ]]; then
    target=$(readlink "$f")
    if [[ "$target" == *dotfiles* || "$target" == *\.dotfiles* ]]; then
      echo "    Removing dotbot symlink: $f -> $target"
      rm "$f"
    fi
  fi
done

# 6. Initialize and apply dotfiles
echo ""
echo "==> Initializing dotfiles from ${DOTFILES_REPO}..."
echo "    You will be prompted for: full name, git email, and profile (work|personal)"
echo ""
chezmoi init --apply "${DOTFILES_REPO}"

# 7. Install mise runtimes
echo ""
echo "==> Installing mise runtimes..."
mise install

echo ""
echo "============================================================"
echo "  Bootstrap complete!"
echo "============================================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: source ~/.zshrc)"
echo "  2. Set machine-local secrets in ~/.zshrc.local (e.g. RC_PRIVATE_KEY)"
echo "  3. Set up 1Password SSH agent (for SSH + git signing):"
echo "     - Open 1Password > Settings > Developer > enable 'Use the SSH Agent'"
echo "     - Import your SSH key: 1Password > + > SSH Key > Import"
echo "     - Optionally delete plaintext key: rm ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub"
echo ""
