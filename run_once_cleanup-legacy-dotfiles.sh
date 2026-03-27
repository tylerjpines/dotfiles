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

echo "==> Legacy cleanup complete."
