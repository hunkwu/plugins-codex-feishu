# Webhook To Bot Reply

Use case: receive a Feishu group message through event subscription, let Codex draft a reply, and send the reply back to the same chat.

## Suggested flow

1. Run the webhook receiver and expose it through a public HTTPS URL.
2. Subscribe to `im.message.receive_v1` in Feishu Open Platform.
3. When an event arrives, inspect the normalized payload from stdout or `FEISHU_WEBHOOK_EVENT_LOG`.
4. Extract:
   - `event.message.chat_id`
   - `event.message.content`
   - `event.sender.sender_id.open_id`
5. Ask Codex to search Docs or Wiki for supporting context.
6. Send the final answer with `im_v1_message_create`.

## Suggested prompt

```text
Read the latest Feishu webhook event from FEISHU_WEBHOOK_EVENT_LOG, identify the chat_id and user question, search Feishu Docs and Wiki for supporting context, draft a concise Chinese reply, and send it back to the same Feishu chat.
```

## Minimal reply tool call

```yaml
tool: mcp__feishu-mcp__im_v1_message_create
params:
  receive_id_type: chat_id
data:
  receive_id: "oc_xxxxx"
  msg_type: "text"
  content: "{\"text\":\"已收到，我会根据相关文档整理回复。\"}"
useUAT: false
```

## Notes

- Keep the webhook handler fast. Do not run long LLM or retrieval work before returning `{"ok":true}` to Feishu.
- In production, route events to a queue or agent runner after logging or normalizing them.
- Avoid echoing sensitive user content in logs unless retention and access control are clear.
