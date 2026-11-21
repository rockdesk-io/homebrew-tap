# RockDesk Homebrew Tap

Official Homebrew Cask for **[RockDesk](https://rockdesk.io)** (`rockd.app` + `rds` CLI).

One 9-digit P2P ID for every machine you own: remote desktop, persistent terminal, 1-RTT FUSE directory mount, port/serial/USB forwarding, VPN, and a built-in MCP server for Claude Code, Codex, and Cursor.

## Install

```bash
brew tap rockdesk-io/tap
brew install --cask rockdesk
```

Or in a single command:

```bash
brew install --cask rockdesk-io/tap/rockdesk
```

This installs `/Applications/rockd.app` and automatically links `rds` onto your `PATH`.

## Connect to Claude Code / AI Agents

```bash
# Register RockDesk's built-in MCP server
claude mcp add rockd -- rds mcp
```

## Upgrade

```bash
brew upgrade --cask rockdesk
```

## Maintainer: Bump to Latest Release

```bash
./scripts/update_cask.sh
git commit -am "Update rockdesk to latest release"
git push
```

