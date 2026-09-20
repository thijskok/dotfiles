## What this repo is

Personal dotfiles for macOS and Linux, managed by [Dotbot](https://github.com/anishathalye/dotbot). `install.conf.yaml` is the source of truth — it declares which files in `config/` are symlinked to which locations in `$HOME`.

## Commands

- `bin/install` — Run Dotbot against `install.conf.yaml`. Idempotent; safe to re-run after editing configs or the manifest. Initializes submodules first.
- `bin/first-setup` — Bootstrap a fresh machine: install packages (Homebrew on macOS, apt on Linux), install oh-my-zsh and zsh-autosuggestions, set zsh as the default shell, run `bin/install`, apply macOS defaults (macOS only).
- `bin/update` — Pull the dotfiles repo, re-run `bin/install`, update packages (Homebrew or apt), run `bin/brewfile-sync` (macOS only), `npm update -g`, `composer global update`.
- `bin/brewfile-sync` — Diff `brew leaves`, `brew list --cask`, and `mas list` against `config/homebrew/Brewfile` and append any missing entries as a dated block. Idempotent; resolves renamed/aliased formulae and casks to their current name first so renames don't show up as duplicates.
- `bin/macos-defaults` — Apply macOS system defaults.

## Architecture

**Adding/changing a config:**

1. Place the file under `config/<tool>/` (the directory layout mirrors the tool name, not the destination path).
2. Add a `link:` entry to `install.conf.yaml` mapping the destination (e.g. `~/.config/foo/bar`) to the repo-relative source.
3. Run `bin/install`. There's no `force`/`relink` default set, so Dotbot will refuse to overwrite a destination that already exists as a real file — resolve those conflicts (usually by reconciling content, then removing the real file) before it'll link.

**Source-of-truth pattern:** Every linked file lives in `config/<tool>/`. The home-directory copies are symlinks — never edit `~/.zshrc`, `~/.gitconfig`, etc. directly; edit the file under `config/` and the symlink picks it up.

**Shell config:** `config/zsh/zshrc` is the single entry point (linked to `~/.zshrc`), no further splitting. It's an oh-my-zsh config using the `mnml` theme (`config/oh-my-zsh/themes/`) and the `zsh-autosuggestions` plugin (installed by `bin/first-setup` via git clone, not a package manager, since oh-my-zsh's plugin loader expects a specific custom-plugin layout that neither brew nor apt produce).

**Submodules:** `dotbot/` is vendored. `bin/install` runs `git submodule update --init --recursive` first; if Dotbot looks broken, check the submodule.

**Homebrew:** `config/homebrew/Brewfile` is canonical on macOS. `bin/update` re-applies it on every run, so adding a brew/cask/mas line there and running `bin/update` is the install path. `config/apt/packages.txt` is the Linux equivalent, kept intentionally minimal (no automated sync script for it).