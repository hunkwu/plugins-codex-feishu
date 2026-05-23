# Authentication

## Required Credentials

Use a Feishu or Lark self-built app for the first version.

```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
```

Some Lark MCP installations use Lark-prefixed names:

```bash
export LARK_APP_ID="cli_xxx"
export LARK_APP_SECRET="xxx"
```

## Recommended Auth Path

Prefer manual code exchange over `lark-mcp login` and use the stable local MCP server for production use.

1. Generate or open the Feishu authorization URL in a browser.
2. After Feishu redirects to `http://localhost:3000/callback?...`, copy the `code` query parameter.
3. Exchange that code with `scripts/exchange-feishu-code.sh`.
4. Export the returned `user_access_token` as `FEISHU_USER_ACCESS_TOKEN`.
5. Start Codex with the default `lark-mcp` entry, which uses the local HTTP-backed server and reads `FEISHU_USER_ACCESS_TOKEN`.

The exchange script uses Feishu's current OAuth token endpoint `authen/v2/oauth/token`, not the legacy `authen/v1/access_token`.

## MCP Server

The plugin declares a stable local MCP server and one legacy upstream beta entry.

```bash
command -v python3
command -v npx
```

- `lark-mcp`: stable local server backed by direct Feishu OpenAPI HTTP calls.
- `lark-mcp-official-beta`: upstream beta MCP server kept only for comparison and debugging.

If `python3` is unavailable, install Python 3 first. `npx` is only required for the legacy upstream beta server.

## Manual Code Exchange

Export the app credentials first:

```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
```

Then exchange the callback code:

```bash
scripts/generate-feishu-auth-url.sh
```

Open the printed URL, authorize, then exchange the callback code:

```bash
scripts/exchange-feishu-code.sh --code "<callback_code>"
```

Optional flags:

```bash
scripts/generate-feishu-auth-url.sh \
  --scope "offline_access im:chat im:message"

scripts/exchange-feishu-code.sh \
  --code "<callback_code>" \
  --redirect-uri "http://localhost:3000/callback"
```

The script prints the raw Feishu response. On success, export the token:

```bash
export FEISHU_USER_ACCESS_TOKEN="<returned_user_access_token>"
```

If the response field is `access_token`, treat it as the returned `user_access_token` from Feishu OAuth and export it as `FEISHU_USER_ACCESS_TOKEN`.

The stable local MCP server uses `FEISHU_USER_ACCESS_TOKEN` automatically. If you want to compare with the upstream beta server, you can still run:

```bash
npx -y @larksuiteoapi/lark-mcp mcp \
  -a "$FEISHU_APP_ID" \
  -s "$FEISHU_APP_SECRET" \
  -u "$FEISHU_USER_ACCESS_TOKEN"
```

## Token Mode

- `useUAT: true`: user access token. Use this when resources should be owned by or visible to the current user.
- `useUAT: false`: tenant access token. Use this for app/bot-owned operations.

For created Docs or Bitable resources, default to `useUAT: true` unless the user explicitly wants bot-owned resources.

## Minimum Permissions

Start with narrow permissions and expand by workflow:

- Messages: `im:message:readonly`, `im:message:send_as_bot`
- Groups: `im:chat`, `im:chat.members:read`, optionally `im:chat:create`
- Docs: document read/edit permissions required by `docx` APIs
- Wiki: `wiki:wiki:readonly`, optionally `wiki:wiki`
- Drive permissions: permission member management
- Bitable: `bitable:app`
- For manual user token refresh support, add `offline_access`

Tenant admin approval may be required before production use.

## App Preconditions

Before blaming MCP runtime behavior, verify these Feishu app settings:

- The app is published and the current user can use it
- `http://localhost:3000/callback` is configured as a redirect URI
- If the app page shows a `refresh user_access_token` switch, it is enabled
- Required scopes are approved for the app and, when applicable, for user identity calls
