# Codex Project Digest Push

Use case: send daily or weekly Codex project updates to a Feishu private assistant chat or target Feishu chat.

Default plugin prompt:

```text
Draft a Codex project update and send it to Feishu.
```

## Suggested flow

1. Summarize project progress from the relevant Codex workspace inputs.
2. Compress the update into:
   - completed
   - in progress
   - risks
   - next steps
3. Post the digest to the target Feishu chat with `im_v1_message_create`.

Before sending, check whether private push is configured:

- `FEISHU_APP_ID`
- `FEISHU_APP_SECRET`
- recipient `open_id` or target `chat_id`

If any value is missing, guide the user to finish authentication and recipient setup first. Do not invent identifiers or commit real credentials.

## Suggested prompt

```text
Draft a Codex project update and send it to Feishu. If Feishu private push is not configured yet, guide me through app credentials, recipient open_id setup, and a short test message first.
```
