# Codex Project Digest Push

Use case: send daily or weekly Codex project updates to a Feishu group.

## Suggested flow

1. Summarize project progress from the relevant Codex workspace inputs.
2. Compress the update into:
   - completed
   - in progress
   - risks
   - next steps
3. Post the digest to the target Feishu chat with `im_v1_message_create`.

## Suggested prompt

```text
Summarize this Codex project's recent progress into completed work, in-progress items, risks, and next steps, then prepare a Feishu-friendly update message.
```
