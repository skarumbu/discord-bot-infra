# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A TypeScript Discord bot that acts as a transport layer for a private friend-group server. All features are implemented as self-contained plugins — the bot core only handles Discord API communication and routes commands to plugins. Current built-in plugin: `weather`. Next planned: `karma`.

## Commands

```bash
npm run build      # Compile TypeScript → dist/
npm run dev        # Run bot locally (tsx, no compile step)
npm run lint       # Run ESLint
npm run format     # Auto-format with Prettier
npm run test       # Run unit tests (Vitest)
npm run test:watch # Run Vitest in watch mode
```

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

**External (any language):** *(Not yet implemented — HTTP/Subprocess adapters and `src/adapters/` are scaffolded but empty.)* Build the service to accept a `CommandContext` POST and return a `PluginResponse`. Add a `Dockerfile`. Register in `plugins.config.json`:
```json
{ "name": "my-plugin", "adapter": "http", "baseUrl": "http://my-plugin:8080", "commands": ["my-plugin.command"] }
```
Add the service to `docker-compose.yml`.

## Plugin System

Every plugin, regardless of language, conforms to the same transport-agnostic JSON contract:

- **Input (`CommandContext`):** `{ command: string, args: Record<string, string>, context: { guildId, channelId, invokingUserId, invokingUserName } }`
- **Output (`PluginResponse`):** `{ content: string, embeds?: APIEmbed[], ephemeral?: boolean }`
- **Interface (`InProcessAdapter`):** `{ commands: string[], slashCommandDefinitions: RESTPostAPIChatInputApplicationCommandsJSONBody[], execute(ctx): Promise<PluginResponse> }`
- `args` values are always strings (coerced via `String()`); plugins re-parse numeric/boolean values if needed.

Plugins never interact with Discord directly. The three adapter types (InProcess, HTTP, Subprocess) are purely transport — the contract is identical regardless of which is used.

Built-in plugins live in `src/plugins/` and are auto-discovered. External plugins are registered in `plugins.config.json` with their adapter type and connection info.

## Data

Each plugin owns its own persistence. The bot core and built-in plugins will use SQLite via Prisma. There is no shared datastore between plugins.

> **Note:** Prisma is not yet installed or scaffolded. It will be added as a dependency when the `karma` plugin is implemented.

## Documentation Standards

**CHANGELOG.md** — every change goes here before it goes anywhere else. Format: [Keep a Changelog v1.1.0](https://keepachangelog.com/en/1.1.0/). Sections: `Added / Changed / Fixed / Removed / Deprecated / Security`.

**ADRs** — every significant architectural decision gets a record in `docs/decisions/` named `000N-short-title.md` following [MADR](https://github.com/adr/madr) format. The ADR captures *why* a decision was made, not implementation details (those live in code). See existing ADRs for tone and scope. Specs in `docs/superpowers/` are working documents (gitignored); if a spec proposes a significant architectural change, extract the decision into an ADR.

## Stack

- **Runtime:** Node.js + TypeScript
- **Discord library:** discord.js v14
- **Test runner:** Vitest
- **ORM:** Prisma
- **Database:** SQLite (core/built-ins); external plugins choose their own
- **Containers:** Docker + docker-compose

**Environment:** Copy `.env.example` → `.env` and fill in `DISCORD_TOKEN`, `DISCORD_CLIENT_ID`, `DISCORD_GUILD_ID` before running.

**Node version:** Managed via [mise](https://mise.jdx.dev). Run `mise install` once after cloning.

## Gotchas

- **Import extensions:** All relative imports must use `.js` extensions (e.g. `from './router.js'`), even in `.ts` source files. Required by `"module": "Node16"`.
- **Dynamic imports:** Must use `pathToFileURL(path).href` — raw filesystem paths throw in ESM (`"type": "module"`).
- **Ephemeral replies:** Use `flags: MessageFlags.Ephemeral`, not `ephemeral: true` (deprecated in discord.js v14).
- **Tests:** Live in `tests/` (excluded from `tsc`), run by Vitest. Mock `fetch` with `vi.stubGlobal('fetch', ...)`.
