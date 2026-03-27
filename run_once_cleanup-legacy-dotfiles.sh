#!/usr/bin/env bash
# run_once_cleanup-legacy-dotfiles.sh
# Removes legacy dotbot symlinks, old dotfiles dirs, and stale files
# that are superseded by this chezmoi setup.
set -euo pipefail

echo "==> Cleaning up legacy dotfiles..."

# --- Orphaned dotbot symlinks ---
# Only remove if they are symlinks pointing into a dotfiles directory
LEGACY_SYMLINKS=(
  "$HOME/.bashrc"
  "$HOME/.dir_colors"
)
for f in "${LEGACY_SYMLINKS[@]}"; do
  if [[ -L "$f" ]]; then
    target=$(readlink "$f")
    if [[ "$target" == *dotfiles* ]]; then
      echo "    Removing legacy symlink: $f -> $target"
      rm "$f"
    fi
  fi
done

# --- Old dotbot repo ---
if [[ -d "$HOME/.dotfiles" ]]; then
  # Extract RC_PRIVATE_KEY before deleting if not already in .zshrc.local
  if grep -q 'RC_PRIVATE_KEY' "$HOME/.dotfiles/zshrc" 2>/dev/null; then
    if ! grep -q 'RC_PRIVATE_KEY' "$HOME/.zshrc.local" 2>/dev/null; then
      echo "    Migrating RC_PRIVATE_KEY to ~/.zshrc.local..."
      grep 'RC_PRIVATE_KEY' "$HOME/.dotfiles/zshrc" >> "$HOME/.zshrc.local"
    fi
  fi
  echo "    Removing ~/.dotfiles (old dotbot repo)..."
  rm -rf "$HOME/.dotfiles"
fi

# --- Stale files superseded by chezmoi ---
STALE_FILES=(
  "$HOME/.vimrc"       # removed from repo, no longer using vim
  "$HOME/.viminfo"     # vim runtime state
  "$HOME/.zprofile"    # brew shellenv now handled in .zshrc
)
for f in "${STALE_FILES[@]}"; do
  # Only remove real files, not symlinks (those are handled above)
  if [[ -f "$f" && ! -L "$f" ]]; then
    echo "    Removing stale file: $f"
    rm "$f"
  fi
done

# --- Chezmoi artifact from Brewfile move ---
if [[ -d "$HOME/install" && ! "$(ls -A "$HOME/install")" ]]; then
  echo "    Removing empty ~/install directory..."
  rmdir "$HOME/install"
fi

# --- Old iTerm2 plist (superseded by Ghostty) ---
if [[ -f "$HOME/com.googlecode.iterm2.plist" ]]; then
  echo "    Removing old iTerm2 plist..."
  rm "$HOME/com.googlecode.iterm2.plist"
fi

# --- Orphaned .nvm data directory (nvm uninstalled, mise handles Node) ---
if [[ -d "$HOME/.nvm" ]]; then
  echo "    Removing ~/.nvm (orphaned nvm data, mise manages Node now)..."
  rm -rf "$HOME/.nvm"
fi

# --- Orphaned .pyenv data directory (pyenv uninstalled, mise handles Python) ---
if [[ -d "$HOME/.pyenv" ]]; then
  echo "    Removing ~/.pyenv (orphaned pyenv data, mise manages Python now)..."
  rm -rf "$HOME/.pyenv"
fi

# --- .exercism symlink ---
if [[ -L "$HOME/.exercism" ]]; then
  echo "    Removing .exercism symlink..."
  rm "$HOME/.exercism"
fi

echo "==> Legacy cleanup complete."
