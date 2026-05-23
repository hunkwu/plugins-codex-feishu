# Feishu for Codex

Open-source Feishu plugin for Codex, designed for high-frequency team collaboration workflows.

[中文说明](./README.zh-CN.md)

## Maintainer

- Personal site: [pmer.cn](https://pmer.cn)
- X: [@ai_pmer](https://x.com/ai_pmer)
- Related open-source project: [Codex Blue Book](https://github.com/hunkwu/book)

## Preview

![Feishu plugin marketplace entry](./plugins/feishu/assets/screenshots/plugin-marketplace-real.png)

![Feishu plugin detail page](./plugins/feishu/assets/screenshots/plugin-detail-real.png)

![Install Feishu plugin in Codex](./plugins/feishu/assets/screenshots/plugin-install-real.png)

## What it solves

- Summarize recent messages from Feishu group chats
- Search Feishu Docs and Wiki from Codex
- Draft bot-style answers and send them back to Feishu
- Push recurring Codex project digests into Feishu chats
- Receive Feishu event subscription webhooks for passive bot triggers and message intake
- Avoid unstable upstream beta token flows by using a local stable HTTP-backed MCP implementation

## Core scenarios

### 1. Group message summary

Turn recent chat history into:

- decisions
- action items
- blockers
- owners

### 2. Bot conversation reply

Use Feishu chat context plus Docs or Wiki retrieval to produce concise answers for a target chat.

### 3. Codex project digest push

Generate daily or weekly project summaries from Codex and push them into Feishu chats.

### 4. Webhook event subscription

Receive Feishu Open Platform event callbacks with support for:

- `url_verification` challenge handling
- `Verification Token` source checks
- `X-Lark-Signature` checks
- `Encrypt Key` encrypted payload decryption
- stdout or local file event logs for follow-up agent workflow integration

## Repository layout

```text
.agents/plugins/marketplace.json
plugins/feishu/
```

Use `plugins/feishu` as the sparse path when importing from Git.

## Install in Codex

In `Add Plugin Marketplace`:

- Source: `https://github.com/hunkwu/plugins-codex-feishu.git`
- Git reference: `main`
- Sparse path: `plugins/feishu`

If your Codex build expects a repo-local marketplace file, use:

- Marketplace path: `.agents/plugins/marketplace.json`

## Setup

1. Create a Feishu self-built app.
2. Add this redirect URI:

```text
http://localhost:3000/callback
```

3. Grant the scopes required by the open-source workflow:

- `im:chat`
- `im:message`
- `docx:document`
- `wiki:wiki`
- `wiki:wiki:readonly`
- `docs:document:import`
- `drive:drive`
- `contact:user.id:readonly`
- `auth:user.id:read`
- `offline_access`

4. Export credentials:

```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
```

5. Generate an authorization URL:

```bash
plugins/feishu/scripts/generate-feishu-auth-url.sh
```

6. After browser authorization, exchange the callback code:

```bash
plugins/feishu/scripts/exchange-feishu-code.sh --code "<callback_code>"
```

7. Export the returned token:

```bash
export FEISHU_USER_ACCESS_TOKEN="<oauth_access_token>"
```

8. Run a quick environment check:

```bash
plugins/feishu/scripts/doctor-feishu-auth.sh
```

## Webhook Server

The repository includes a minimal webhook receiver:

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"

plugins/feishu/scripts/feishu_webhook_server.py
```

Default local URL:

```text
http://127.0.0.1:3000/webhook/feishu
```

Feishu Open Platform requires a public HTTPS callback URL, for example:

```text
https://your-public-domain.example/webhook/feishu
```

Configure it in your self-built app under `Events and Callbacks`, including `Encryption Strategy` and event subscriptions.

More details:

- [Webhook event subscription](./plugins/feishu/skills/feishu/reference/webhook.md)
- [Webhook to bot reply example](./plugins/feishu/skills/feishu/examples/webhook-to-reply.md)

## Local Verification

After changing the plugin, run:

```bash
scripts/smoke-test.sh
```

## Community

Contributions and real-world notes are welcome:

- [Contributing guide](./CONTRIBUTING.md)
- [Case studies](./case-studies/)
- [Case study template](./case-studies/TEMPLATE.md)

Especially useful contributions include:

- Real Feishu + Codex workflow troubleshooting notes
- `AGENTS.md` rules that worked in your own project
- AI tuning tips, prompts, and verification methods
- Stories about using Codex to ship a product, get users, or earn first revenue

## Stable runtime

The default `lark-mcp` entry in `.mcp.json` uses the local HTTP-backed implementation in:

- `plugins/feishu/scripts/feishu_http_mcp.py`

The upstream beta server is preserved as `lark-mcp-official-beta` for comparison and debugging, but it is not the recommended production path.

## Official workflow examples

- [Group message summary](./plugins/feishu/skills/feishu/examples/group-summary.md)
- [Bot conversation reply](./plugins/feishu/skills/feishu/examples/bot-reply.md)
- [Codex project digest push](./plugins/feishu/skills/feishu/examples/project-digest-push.md)

## Notes

- Tokens are expected to stay in environment variables by default and are not written into repo files.
- The stable local MCP directly wraps the high-frequency IM, Docs, Wiki, and Contacts flows.
- Less common endpoints can still be reached through `feishu_openapi_request`.
- The repository is intended to be importable directly from GitHub as a Codex plugin marketplace source.

## Related Project

- [hunkwu/book](https://github.com/hunkwu/book) - Codex Blue Book, focused on Codex workflows, multi-surface orchestration, and AI-native product delivery.
