# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **devenv-based development environment** for GaoOS Nerves (embedded Elixir) projects. It provides a reproducible dev shell with pinned tool versions — not application source code.

## Development Environment

Enter the dev shell:
```bash
direnv allow        # Auto-activate via direnv (recommended)
devenv shell        # Manual entry
```

Format Nix files:
```bash
alejandra devenv.nix
```

## Architecture

- `devenv.nix` — Main configuration: dev shell packages, language settings, and environment variables
- `devenv.yaml` — devenv inputs (pins two nixpkgs channels: rolling and stable release-25.11)
- `.envrc` — direnv integration with `DIRENV_WARN_TIMEOUT=20s`

### Nixpkgs Pin Strategy

`devenv.yaml` pins two channels: `nixpkgs` (rolling, used by devenv internals) and `nixpkgs-stable` (release-25.11, used for all packages in `devenv.nix`).

## Key Environment Variables Set by Shell

- `MIX_HOME` → `$DEVENV_ROOT/.mix` (project-local)
- `HEX_HOME` → `$DEVENV_ROOT/.hex` (project-local)
- `NERVES_DL_DIR` → `$DEVENV_ROOT/.nerves/dl`
- `NERVES_ARTIFACTS_DIR` → `$DEVENV_ROOT/.nerves/artifacts`
- `ERL_AFLAGS` → `-kernel shell_history enabled`

## Custom Registry Configuration

Uses internal Nexus registry (nexus.gsmlg.net) for:
- npm packages (`NPM_CONFIG_REGISTRY`)
- Hex packages (`HEX_MIRROR`, `HEX_CDN`)

## Making Changes

- **Add build dependencies**: add packages to the `packages` list in `devenv.nix` (uses `pkgs-stable`)
- **Update nixpkgs version**: edit `devenv.yaml` inputs section
- **Update language versions**: modify `languages.erlang.package` / `languages.elixir.package` in `devenv.nix`
