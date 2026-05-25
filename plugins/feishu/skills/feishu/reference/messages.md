# Messages

## Send Text

```yaml
tool: mcp__feishu-mcp__im_v1_message_create
params:
  receive_id_type: chat_id
data:
  receive_id: "oc_xxxxx"
  msg_type: "text"
  content: "{\"text\":\"Hello from Codex.\"}"
```

`content` must be a JSON string.

## Send Private Assistant Message

Use `open_id` for private assistant-style pushes to one user.

```yaml
tool: mcp__feishu-mcp__im_v1_message_create
params:
  receive_id_type: open_id
data:
  receive_id: "ou_xxxxx"
  msg_type: "text"
  content: "{\"text\":\"Codex project digest is ready.\"}"
useUAT: false
```

`open_id` is the recipient user ID. It is different from `FEISHU_APP_ID`, which identifies the sending app.

Ways to get `open_id`:

- Ask the user to send the bot a private message, then read `event.sender.sender_id.open_id` from Feishu event logs.
- Use `contact_v3_user_batchGetId` with email, if the app has `contact:user.id:readonly` and the user is in app visibility scope.

Do not commit real `open_id`, `chat_id`, `App ID`, app secret, or access token values. Use placeholders such as `ou_xxxxx`, `oc_xxxxx`, and `cli_xxx` in docs.

## Project Update Command Path

Recommended local command flow:

```bash
npm run feishu:project-update -- --preview --mode weekly --file ./plugins/feishu/skills/feishu/examples/project-update-template.md
npm run feishu:project-update -- --dry-run-json --mode daily --message "Completed: shipped docs."
npm run feishu:project-update -- --test --send --confirm
npm run feishu:project-update -- --send --confirm --title "Weekly Update" --file ./digest.md
```

Environment defaults:

- `FEISHU_DEFAULT_RECEIVE_ID`
- `FEISHU_DEFAULT_RECEIVE_ID_TYPE`
- `FEISHU_DEFAULT_UPDATE_MODE`

The command renders this standard structure for non-test updates:

- `Completed`
- `In Progress`
- `Risks`
- `Next Steps`

## Troubleshooting

- `Missing FEISHU_APP_ID`: set the sending app ID in `.env` or the shell environment.
- `Missing FEISHU_APP_SECRET`: set the sending app secret in `.env` or the shell environment.
- `Missing FEISHU_DEFAULT_RECEIVE_ID or --receive-id`: configure the recipient user `open_id` or target `chat_id`.
- `Invalid receive_id_type`: only `open_id` and `chat_id` are supported.
- `Real sends require --confirm`: the command stays in preview mode until `--confirm` is provided.
- `Feishu rejected the request due to missing permissions`: check `im:message`, `im:message:send_as_bot`, and tenant approval.
- `The bot may not be published, or the recipient is outside app visibility`: publish the app and verify the target user is within visibility scope.

## Read Chat History

```yaml
tool: mcp__feishu-mcp__im_v1_message_list
path:
  container_id_type: chat
  container_id: "oc_xxxxx"
params:
  page_size: 20
```

Reading history requires message read permissions and is limited to the app or user authorization scope.

## List Chats

```yaml
tool: mcp__feishu-mcp__im_v1_chat_list
params:
  page_size: 50
```

## Get Chat Members

```yaml
tool: mcp__feishu-mcp__im_v1_chatMembers_get
path:
  chat_id: "oc_xxxxx"
params:
  member_id_type: open_id
```

## Create Group

The stable local MCP server does not yet provide a dedicated `im_v1_chat_create` wrapper. Use `feishu_openapi_request` if you need this endpoint before a first-class wrapper is added.
