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
