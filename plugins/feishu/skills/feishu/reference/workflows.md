# Workflows

## Summarize Recent Group Messages

1. Use `im_v1_chat_list` to find the target chat.
2. Use `im_v1_message_list` to fetch recent messages.
3. Summarize decisions, blockers, owners, and next actions.
4. Optionally send the summary back through `im_v1_message_create`.

## Bot-Style Feishu Reply

1. Use `wiki_v1_node_search` with the user's topic.
2. Resolve promising nodes with `wiki_v2_space_getNode`.
3. Read Docx content when the node points to a document.
4. Draft a concise answer for the user or group.
5. Send the reply with `im_v1_message_create`.

## Codex Project Digest Push

1. Collect the relevant Codex project progress inputs.
2. Structure the content into `Completed`, `In Progress`, `Risks`, and `Next Steps`.
3. Preview the rendered message locally before sending.
4. Send a short test message to the configured `open_id` or `chat_id`.
5. Send the digest to the target chat with `im_v1_message_create`.

Local command path:

```bash
npm run feishu:project-update -- --preview --mode weekly --file ./plugins/feishu/skills/feishu/examples/project-update-template.md
npm run feishu:project-update -- --dry-run-json --mode daily --message "Completed: shipped docs."
npm run feishu:project-update -- --test --send --confirm
npm run feishu:project-update -- --send --confirm --title "Weekly Update" --file ./digest.md
```

If the command reports missing configuration, guide the user through `FEISHU_APP_ID`, `FEISHU_APP_SECRET`, `FEISHU_DEFAULT_RECEIVE_ID`, `FEISHU_DEFAULT_RECEIVE_ID_TYPE`, and optionally `FEISHU_DEFAULT_UPDATE_MODE` before sending.

## Docs/Wiki Retrieval To Doc Write-Back

Recommended path:

1. Search Feishu Docs by keyword.
2. If no good result appears, search Wiki with the same keyword.
3. Resolve the final document token and read the selected Docx content.
4. Summarize into `Background`, `Key Points`, `Risks`, and `Suggested Next Actions`.
5. Import the final Markdown into Feishu Docs with `useUAT: true` if the current user should open it directly.
6. Send the created document reference back to the target chat.

Failure path guidance:

- No document found: refine the search key or switch from Docs to Wiki.
- Wiki result does not resolve to Docx: inspect the node object type first.
- Read works but import fails: check `docs:document:import`.
- Import succeeds but the user cannot open the doc: verify user visibility and Drive permissions.

See `examples/docs-wiki-to-doc.md`.

## Write Automation Result to Bitable

1. Locate `app_token` and `table_id`.
2. Use `feishu_openapi_request` to query or update the relevant Bitable endpoint.
3. Create or update the record.
4. Push a concise completion message to Feishu IM.

Recommended initial tables:

- Project status
- Release records
- Risk tracker
- Case study intake

See `examples/bitable-project-templates.md`.

## Event Subscription Extension

For bot mentions or passive message intake, use the bundled webhook receiver or deploy the same flow to your own service:

```text
Feishu event callback
  -> verify challenge
  -> verify token
  -> decrypt event when Encrypt Key is enabled
  -> normalize event
  -> call agent workflow
  -> send result with im_v1_message_create
```

Local receiver:

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"

scripts/feishu_webhook_server.py
```

Cloudflare Workers, Vercel Functions, or an existing OpenClaw/Hermes service are suitable production hosts.

See `reference/webhook.md` for the Feishu Open Platform configuration checklist.
