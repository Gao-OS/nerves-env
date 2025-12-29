# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **devenv-based development environment** for GaoOS Nerves (embedded Elixir) projects. It provides a reproducible dev shell with pinned tool versions - not application source code.

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

## Tool Versions (via asdf)

Managed in `.tool-versions`:
- Elixir 1.18.3-otp-27
- Erlang 27.3.3
- Bun 1.2.10

## Architecture

- `devenv.nix` - Main configuration defining the dev shell, packages, and environment variables
- `devenv.yaml` - devenv inputs configuration (nixpkgs version, custom caches)
- `.tool-versions` - asdf version pinning for Elixir/Erlang/Bun
- `.envrc` - direnv integration to auto-load devenv

## Custom Registry Configuration

Uses internal Nexus registry (nexus.gsmlg.net) for:
- Nix cache (`extra-substituters` in devenv.yaml)
- npm packages (`NPM_CONFIG_REGISTRY`)
- Hex packages (`HEX_MIRROR`, `HEX_CDN`)

## Key Environment Variables Set by Shell

- `MIX_HOME` → `$HOME/.local/share/mix_nerves`
- `ASDF_DATA_DIR` → `$HOME/.asdf`
- Custom PATH includes asdf shims and galaxy-pub-cache

## Making Changes

To update tool versions: edit `.tool-versions` (for asdf-managed tools).

To add build dependencies: add packages to the `packages` list in `devenv.nix`.

To update nixpkgs version: edit `devenv.yaml` inputs section.
