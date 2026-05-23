# Messages

## Send Text

```yaml
tool: mcp__lark-mcp__im_v1_message_create
params:
  receive_id_type: chat_id
data:
  receive_id: "oc_xxxxx"
  msg_type: "text"
  content: "{\"text\":\"Hello from Codex.\"}"
```

`content` must be a JSON string.

## Read Chat History

```yaml
tool: mcp__lark-mcp__im_v1_message_list
path:
  container_id_type: chat
  container_id: "oc_xxxxx"
params:
  page_size: 20
```

Reading history requires message read permissions and is limited to the app or user authorization scope.

## List Chats

```yaml
tool: mcp__lark-mcp__im_v1_chat_list
params:
  page_size: 50
```

## Get Chat Members

```yaml
tool: mcp__lark-mcp__im_v1_chatMembers_get
path:
  chat_id: "oc_xxxxx"
params:
  member_id_type: open_id
```

## Create Group

The stable local MCP server does not yet provide a dedicated `im_v1_chat_create` wrapper. Use `feishu_openapi_request` if you need this endpoint before a first-class wrapper is added.
