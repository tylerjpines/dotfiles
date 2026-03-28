# dotfiles

Personal macOS dotfiles managed with [chezmoi](https://chezmoi.io).

## Bootstrap a fresh Mac

```sh
curl -fsSL https://raw.githubusercontent.com/tylerjpines/dotfiles/master/bootstrap.sh -o /tmp/bootstrap.sh && bash /tmp/bootstrap.sh
```

This will:
1. Install Xcode Command Line Tools
2. Install Homebrew
3. Install chezmoi + mise
4. Prompt for your name, email, and profile (`work` or `personal`)
5. Apply all dotfiles and run setup scripts (Brewfile, 1Password CLI)

## Stack

| Tool | Purpose |
|---|---|
| [chezmoi](https://chezmoi.io) | Dotfiles manager |
| [mise](https://mise.jdx.dev) | Runtime version manager (Node, Python, Go) |
| [Homebrew](https://brew.sh) | Package manager |
| [oh-my-zsh](https://ohmyz.sh) | Zsh framework |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | Zsh prompt |
| [1Password SSH Agent](https://developer.1password.com/docs/ssh/) | SSH key management + git signing |
| [delta](https://dandavison.github.io/delta/) | Syntax-highlighted git diffs |
| [eza](https://eza.rocks) | Modern `ls` replacement |

## Post-bootstrap checklist

- [ ] Restart terminal or `source ~/.zshrc`
- [ ] Enable 1Password SSH agent: **1Password > Settings > Developer > Use the SSH Agent**
- [ ] Import `~/.ssh/id_ed25519` into 1Password vault, then delete the plaintext key
- [ ] Add machine-local secrets to `~/.zshrc.local` (e.g. `RC_PRIVATE_KEY`)
- [ ] Run `mise install` to install configured runtimes
- [ ] Verify git signing: `echo "test" | git commit --allow-empty -m "test signing"`
- [ ] *(personal only)* Sign in to Claude desktop app and verify gstack skills load: run `/gstack-help` in a project

## Managing dotfiles day-to-day

```sh
# Edit a dotfile
chezmoi edit ~/.zshrc

# See what would change
chezmoi diff

# Apply changes
chezmoi apply

# Add a new file to chezmoi
chezmoi add ~/.some-new-config

# Update from repo (also refreshes gstack weekly)
chezmoi update
```

## Machine-local config

Create `~/.zshrc.local` for secrets and machine-specific overrides — it's sourced at the end of `.zshrc` and is gitignored:

```sh
# ~/.zshrc.local
export RC_PRIVATE_KEY="..."
export SOME_WORK_TOKEN="..."
```

## Profile-based setup

The bootstrap prompt asks for a profile (`work` or `personal`). This gates certain tools:

| | `work` | `personal` |
|---|---|---|
| Core dotfiles (zsh, git, ssh) | ✅ | ✅ |
| Claude desktop + Claude Code CLI | ✗ | ✅ |
| gstack AI skills | ✗ | ✅ |
| `~/.claude/` managed by chezmoi | ✗ | ✅ |

## Claude Code (personal only)

[Claude Code](https://claude.ai/code) is installed via `Brewfile.personal` and configured through `dot_claude/`.

**What gets set up automatically on `chezmoi apply`:**
- `~/.claude/settings.json` — pre-approved permissions for common CLI tools
- `~/.claude/skills/gstack` — [gstack](https://github.com/garrytan/gstack) AI skill suite (cloned via external, refreshed weekly on `chezmoi update`)

**Keeping gstack current:**
Run `/gstack-upgrade` inside any Claude Code session, or let `chezmoi update` pull the latest weekly.

**Adding project-level Claude config:**
Drop a `.claude/CLAUDE.md` and/or `.claude/skills/` in any repo for project-specific instructions and skills.

## Directory structure

```
dotfiles/
├── .chezmoi.toml.tmpl              # Interactive init (prompts name/email/profile)
├── .chezmoiexternal.toml.tmpl      # oh-my-zsh, p10k, zsh-autosuggestions; gstack (personal)
├── .chezmoiignore                  # Excludes .claude/ on work profile
├── dot_zshrc.tmpl                  # ~/.zshrc
├── dot_gitconfig.tmpl              # ~/.gitconfig
├── dot_gitignore_global            # ~/.gitignore_global
├── dot_p10k.zsh                    # ~/.p10k.zsh
├── dot_claude/
│   └── settings.json               # ~/.claude/settings.json (personal only)
├── dot_ssh/
│   └── config.tmpl                 # ~/.ssh/config (1Password agent, key from signingkey)
├── dot_config/
│   └── mise/
│       └── config.toml             # mise global tool versions
├── install/
│   ├── Brewfile                    # Core Homebrew installs (all profiles)
│   └── Brewfile.personal           # Personal-only: Claude, Claude Code, bun
├── bootstrap.sh                    # Fresh Mac bootstrap script
├── run_onchange_brew-bundle.sh.tmpl # Re-runs brew bundle when Brewfile(s) change
└── run_once_setup-gstack.sh.tmpl   # Runs gstack setup after first clone (personal only)
```
