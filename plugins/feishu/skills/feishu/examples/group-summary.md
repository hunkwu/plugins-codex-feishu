# Group Message Summary

Use case: summarize the latest messages from a Feishu group for operators, PMs, or founders.

## Suggested flow

1. Call `im_v1_chat_list` to find the target chat.
2. Call `im_v1_message_list` to read the latest messages.
3. Summarize into:
   - decisions
   - action items
   - blockers
   - owners
4. If needed, send the summary back with `im_v1_message_create`.

## Suggested prompt

```text
Summarize the latest messages in this Feishu chat. Group the result into decisions, action items, blockers, and owners. Keep it concise and operator-friendly.
```
