# Discord Bot Design

**Date:** 2026-02-28
**Status:** Approved

## Overview

A TypeScript Discord bot serving as a platform for a private friend-group server. The bot is a transport layer — it handles Discord API communication and routes commands to self-contained plugins. Features are built as plugins; the first is a karma counter.

## Repository Structure

```
DiscordBot/
  docs/
    decisions/          # Architecture Decision Records (MADR format)
    plans/              # Design documents
  src/
    core/               # Discord bot entry point, command router, plugin registry
    plugins/            # Built-in plugins (karma, etc.)
    adapters/           # InProcess, HTTP, Subprocess adapter implementations
    types/              # Shared TypeScript types (CommandContext, PluginResponse, Plugin)
  docker/               # Dockerfiles for external plugins
  docker-compose.yml
  CHANGELOG.md
  package.json
  tsconfig.json
```

## Plugin System

The bot is a routing shell. All business logic lives in plugins. Plugins are self-contained — they own their own data, logic, and persistence. The bot only provides the transport.

### Plugin Manifest

Each plugin registers itself with a manifest:

```json
{
  "name": "beer-tracker",
  "adapter": "http",
  "baseUrl": "http://beer-tracker:8080",
  "commands": ["beer.analyze", "beer.leaderboard"]
}
```

Built-in plugins (like karma) are auto-discovered from `src/plugins/`. External plugins are registered in `plugins.config.json`.

### Plugin Contract

The contract is transport-agnostic. The bot sends a `CommandContext` and receives a `PluginResponse`. The plugin never interacts with Discord directly.

**CommandContext (bot → plugin):**
```json
{
  "command": "karma.get",
  "args": {
    "targetUser": "123456789"
  },
  "context": {
    "guildId": "987654321",
    "channelId": "111222333",
    "invokingUserId": "444555666",
    "invokingUserName": "nishyfish"
  }
}
```

**PluginResponse (plugin → bot):**
```json
{
  "content": "nishyfish has 42 karma",
  "embeds": [],
  "ephemeral": false
}
```

### Adapters

| Adapter | Transport | Use case |
|---|---|---|
| `InProcess` | Direct function call | Built-in TypeScript plugins |
| `HTTP` | POST to URL | External services (docker-compose microservices) |
| `Subprocess` | stdin/stdout JSON | Scripts, one-off tools in any language |

## Discord Bot Core

discord.js v14 is used as a thin Discord API client only. Its opinionated command handler conventions are not adopted.

**Startup sequence:**
1. Load plugin manifests
2. Register all plugin commands as Discord slash commands via `SlashCommandBuilder`
3. Connect to Discord gateway
4. Listen for `interactionCreate` events

**Request flow:**
```
Discord interaction
  → CommandRouter (resolves plugin by command name)
    → Adapter
      → Plugin
        → PluginResponse
          → Discord reply
```

## Data Layer

Each plugin owns its own persistence. The bot core and built-in plugins use **SQLite via Prisma**. No shared datastore between plugins — external plugins manage their own persistence and expose data via their adapter interface.

## Karma Plugin (first built-in)

An in-process plugin demonstrating the plugin system. Self-documents its own rules in code.

**Commands:**

| Command | Action |
|---|---|
| `/karma @user` | View a user's karma |
| `/karma top` | Leaderboard (top 10) |
| `/karma give @user` | Increment karma |
| `/karma take @user` | Decrement karma |

Base rules (self-documented in plugin code): no self-karma, optional rate limiting.

## Infrastructure

Docker + docker-compose. The bot and PostgreSQL each run as containers. External plugins are added as services in docker-compose. Developers contribute plugins as a `Dockerfile` + implementation — no environment setup required.

## Documentation Standards

- **CHANGELOG.md** — follows [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/), reverse-chronological, grouped by `Added / Changed / Fixed / Removed / Deprecated / Security`
- **ADRs** — stored in `docs/decisions/`, named `0001-*.md`, follow [MADR](https://github.com/adr/madr) format
