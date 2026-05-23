# Bot Conversation Reply

Use case: let Codex answer a Feishu user or group by combining chat context with Docs or Wiki retrieval.

## Suggested flow

1. Read the latest user or group message context.
2. Search `docx_builtin_search` or `wiki_v1_node_search` for supporting material.
3. Draft a concise answer.
4. Push it back with `im_v1_message_create`.

## Suggested prompt

```text
Read the latest question from this Feishu chat, search Feishu Docs and Wiki for supporting information, and draft a concise answer in Chinese.
```
