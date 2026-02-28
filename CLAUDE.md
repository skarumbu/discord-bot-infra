# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A TypeScript Discord bot that acts as a transport layer for a private friend-group server. All features are implemented as self-contained plugins — the bot core only handles Discord API communication and routes commands to plugins. The first built-in plugin is `karma`.

## Commands

> To be added once project is scaffolded. At minimum, document: build, dev (run bot locally), and how to run a single test. All commands should be copy-paste ready.

## Architecture

The bot is a routing shell. It never contains business logic directly.

**Request flow:**
```
Discord interaction
  → CommandRouter (resolves plugin by command name)
    → Adapter (InProcess / HTTP / Subprocess)
      → Plugin
        → PluginResponse
          → Discord reply
```

**Key distinction:** discord.js is used as a thin Discord API client only. Its opinionated command handler conventions are not used — the bot has its own plugin registry and router.

## Adding a Plugin

**Built-in (TypeScript, in-process):** Create a directory under `src/plugins/`. The registry auto-discovers it on startup. Implement the `InProcessAdapter` interface.

**External (any language):** Build the service to accept a `CommandContext` POST and return a `PluginResponse`. Add a `Dockerfile`. Register in `plugins.config.json`:
```json
{ "name": "my-plugin", "adapter": "http", "baseUrl": "http://my-plugin:8080", "commands": ["my-plugin.command"] }
```
Add the service to `docker-compose.yml`.

## Plugin System

Every plugin, regardless of language, conforms to the same transport-agnostic JSON contract:

- **Input (`CommandContext`):** `{ command, args, context: { guildId, channelId, invokingUserId, invokingUserName } }`
- **Output (`PluginResponse`):** `{ content, embeds?, ephemeral? }`

Plugins never interact with Discord directly. The three adapter types (InProcess, HTTP, Subprocess) are purely transport — the contract is identical regardless of which is used.

Built-in plugins live in `src/plugins/` and are auto-discovered. External plugins are registered in `plugins.config.json` with their adapter type and connection info.

## Data

Each plugin owns its own persistence. The bot core and built-in plugins use SQLite via Prisma (`src/core/prisma/schema.prisma`). There is no shared datastore between plugins.

## Documentation Standards

**CHANGELOG.md** — every change goes here before it goes anywhere else. Format: [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/). Sections: `Added / Changed / Fixed / Removed / Deprecated / Security`.

**ADRs** — every significant architectural decision gets a record in `docs/decisions/` named `000N-short-title.md` following [MADR](https://github.com/adr/madr) format. The ADR captures *why* a decision was made, not implementation details (those live in code). See existing ADRs for tone and scope.

## Stack

- **Runtime:** Node.js + TypeScript
- **Discord library:** discord.js v14
- **ORM:** Prisma
- **Database:** SQLite (core/built-ins); external plugins choose their own
- **Containers:** Docker + docker-compose
