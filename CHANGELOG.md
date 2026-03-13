# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Initial project design document
- Architecture Decision Records for plugin architecture, Docker, TypeScript core, SQLite + Prisma, and discord.js
- TypeScript project scaffold with discord.js v14, dotenv, ESLint, and Prettier
- `src/` directory structure: `core/`, `plugins/`, `adapters/`, `types/`
- npm scripts: `build`, `dev`, `lint`, `format`
- `.env.example` with `DISCORD_TOKEN`, `DISCORD_CLIENT_ID`, `DISCORD_GUILD_ID` placeholders
- `src/types/index.ts`: `CommandContext`, `PluginResponse`, `InProcessAdapter` contracts
- `src/core/router.ts`: `CommandRouter` — registers plugins, dispatches interactions by command name
- `src/core/registry.ts`: auto-discovery registry — scans `src/plugins/`, validates shape, registers plugins
- `src/core/index.ts`: bot entry point — boots discord.js, registers slash commands, routes interactions
- `src/plugins/weather/index.ts`: `/weather <zipcode>` slash command via wttr.in (ephemeral, no API key)
- Vitest test suite with unit tests for router, registry, and weather plugin
