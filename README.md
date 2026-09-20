# My dotfiles

<!-- TODO: Add Image of my Terminal -->

Personal dotfiles for macOS and Linux, managed by [Dotbot](https://github.com/anishathalye/dotbot). Every linked file lives under `config/<tool>/`; `install.conf.yaml` declares where each one gets symlinked.

## Installation

On a new machine (macOS or Linux), clone the repo and run the bootstrap script:

```
git clone https://github.com/thijskok/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
bin/first-setup
```

## Scripts

All operational scripts live under `bin/`.

### `bin/first-setup`

Bootstraps a fresh machine end-to-end:

1. Installs packages: Homebrew + everything in `config/homebrew/Brewfile` on macOS, `apt` + everything in `config/apt/packages.txt` on Linux.
2. Installs oh-my-zsh if it isn't already present.
3. Sets zsh as the default login shell.
4. Runs `bin/install` to symlink everything in this repo.
5. Applies macOS system defaults via `bin/macos-defaults` (macOS only).

### `bin/install`

Runs Dotbot against `install.conf.yaml` — initializes the `dotbot/` submodule first, then symlinks every entry under `link:` into the right destination. Idempotent; safe to re-run after editing any config or adding a new `link:` entry.

### `bin/update`

Brings everything on the machine up to date:

1. `git pull` the dotfiles repo.
2. Re-run `bin/install` to pick up any newly-added `link:` entries.
3. macOS: `brew update`, `brew upgrade`, re-apply the Brewfile, `brew cleanup`, then run `bin/brewfile-sync`. Linux: `apt-get update && upgrade`, reinstall from `config/apt/packages.txt`.
4. `npm update -g` and `composer global update` (skipped if either isn't installed).

### `bin/brewfile-sync`

macOS only. Keeps `config/homebrew/Brewfile` in sync with whatever is actually installed locally. Compares `brew leaves` (top-level formulae), `brew list --cask`, and `mas list` (Mac App Store apps) against the Brewfile and appends any missing entries as a dated block:

```
# Added by brewfile-sync on 2026-06-28
brew "pnpm"
cask "orbstack"
mas "Things", id: 904280696
```

Idempotent — running twice in a row adds nothing the second time. The script tolerates tap-prefixed entries (e.g. `jordond/tap/jolt`) and resolves renamed/aliased formulae and casks to their current name first, so neither shows up as a spurious duplicate. Grouping (Dev / Apps / Fonts) is left to manual re-sorting when convenient. Called automatically by `bin/update`.

### `bin/macos-defaults`

Applies a curated set of macOS system defaults: faster key-repeat, Finder tweaks, save/print panel expansion, Dock and Mission Control timings, automatic software-update checks, etc. Some changes only take effect after logout/restart.

## Architecture

**Adding or changing a config:**

1. Place the file under `config/<tool>/` (the directory layout mirrors the tool name, not the destination path).
2. Add a `link:` entry to `install.conf.yaml` mapping the destination (e.g. `~/.config/foo/bar`) to the repo-relative source.
3. Run `bin/install`. There's no `force`/`relink` default set, so it'll refuse to overwrite a destination that already exists as a real file rather than a symlink — reconcile the content first, then remove the real file so it can link.