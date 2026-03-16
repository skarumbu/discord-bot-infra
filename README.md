# DiscordBot

A TypeScript Discord bot built as a plugin routing shell for a private friend-group server. The bot core handles only Discord API communication — all features live in self-contained plugins.

## Architecture

```
Discord interaction
  → CommandRouter (resolves plugin by command name)
    → Adapter (InProcess / HTTP / Subprocess)
      → Plugin
        → PluginResponse
          → Discord reply
```

The bot core never contains business logic. Every feature is a plugin that conforms to a transport-agnostic JSON contract:

- **Input (`CommandContext`):** `{ command, args, context: { guildId, channelId, invokingUserId, invokingUserName } }`
- **Output (`PluginResponse`):** `{ content, embeds?, ephemeral? }`

Plugins never interact with Discord directly. discord.js is used as a thin API client only.

## Plugins

| Plugin | Type | Status |
|--------|------|--------|
| `weather` | Built-in (TypeScript) | Implemented |
| `karma` | Built-in (TypeScript) | Planned |

### `/weather <zipcode>`
Returns current weather conditions for a US zip code via [wttr.in](https://wttr.in).

## Setup

**Prerequisites:** [Node.js](https://nodejs.org) (managed via [mise](https://mise.jdx.dev)), [Docker](https://www.docker.com)

```bash
# Install Node.js version
mise install

# Install dependencies
npm install

# Configure environment
cp .env.dev.example .env.dev    # dev bot
cp .env.prod.example .env.prod  # prod bot
```

Fill in `DISCORD_TOKEN`, `DISCORD_CLIENT_ID`, and `DISCORD_GUILD_ID` in each `.env` file.

## Development

```bash
npm run dev        # Run bot locally (no compile step, uses tsx)
npm run build      # Compile TypeScript → dist/
npm run test       # Run unit tests
npm run test:watch # Run tests in watch mode
npm run lint       # Lint with ESLint
npm run format     # Format with Prettier
```

## Docker

Same image for dev and prod — environment is the only difference:

```bash
docker build -t discordbot:latest .
docker run --env-file .env.dev discordbot:latest   # dev bot
docker run --env-file .env.prod discordbot:latest  # prod bot
```

Or use the npm shortcuts:

```bash
npm run docker:dev
npm run docker:prod
```

## Adding a Plugin

**Built-in (TypeScript):** Create a directory under `src/plugins/` and implement the `InProcessAdapter` interface. The registry auto-discovers it on startup — no registration step needed.

```typescript
import type { InProcessAdapter, CommandContext, PluginResponse } from '../../types/index.js';

const myPlugin: InProcessAdapter = {
  commands: ['my-command'],
  slashCommandDefinitions: [ /* SlashCommandBuilder definitions */ ],
  async execute(ctx: CommandContext): Promise<PluginResponse> {
    return { content: 'Hello!' };
  },
};

export default myPlugin;
```

**External (any language):** *(Not yet implemented.)* Build a service that accepts a `CommandContext` POST and returns a `PluginResponse`. Register it in `plugins.config.json` with its adapter type and connection info.

## Stack

- **Runtime:** Node.js + TypeScript (`"module": "Node16"`)
- **Discord library:** discord.js v14
- **Test runner:** Vitest
- **ORM:** Prisma *(planned — will be added with the `karma` plugin)*
- **Database:** SQLite (core/built-ins)
- **Containers:** Docker

## Decisions

Architectural decisions are recorded as ADRs in [`docs/decisions/`](docs/decisions/). Notable decisions:

- [0001 — Plugin Architecture](docs/decisions/0001-plugin-architecture.md)
- [0003 — TypeScript Core](docs/decisions/0003-typescript-core.md)
- [0004 — SQLite + Prisma](docs/decisions/0004-sqlite-prisma.md)
- [0005 — discord.js](docs/decisions/0005-discordjs.md)
