# Webhook Event Subscription

Use the bundled webhook server when a Feishu app needs to receive passive events, such as bot mentions, group messages visible to the bot, or app callback events.

## What The Server Does

- Receives Feishu event subscription HTTP callbacks.
- Handles `url_verification` by returning the incoming `challenge`.
- Verifies `FEISHU_VERIFICATION_TOKEN` when configured.
- Verifies `X-Lark-Signature` when `FEISHU_ENCRYPT_KEY` is configured.
- Decrypts encrypted event bodies when `FEISHU_ENCRYPT_KEY` is configured.
- Logs normalized events to stdout, or to `FEISHU_WEBHOOK_EVENT_LOG` when set.

The server is intentionally small. It receives and normalizes events, but it does not run a long-lived agent workflow by itself.

## Run Locally

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
export FEISHU_WEBHOOK_PORT="3000"

plugins/feishu/scripts/feishu_webhook_server.py
```

The default callback URL is:

```text
http://127.0.0.1:3000/webhook/feishu
```

For Feishu Open Platform verification, expose it through a stable public URL during development:

```text
https://your-public-domain.example/webhook/feishu
```

## Official Feishu Configuration Checklist

In Feishu Open Platform:

1. Open your self-built app.
2. Go to `Events and Callbacks`.
3. Open `Encryption Strategy` and copy:
   - `Verification Token`
   - `Encrypt Key`
4. Export them as environment variables on the webhook server:

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
```

5. Set subscription mode to send events to a developer server.
6. Fill the request URL:

```text
https://your-public-domain.example/webhook/feishu
```

7. Click verification. The server must return the same `challenge` value within 1 second.
8. Subscribe only to the event types needed by the workflow.
9. Publish the app after the event subscription and permissions are approved.

## End-To-End Verification Checklist

Codex can run the local receiver and inspect logs. You must complete the Feishu Open Platform console steps because they require your tenant session and app admin permissions.

### 1. Start the local receiver

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
export FEISHU_WEBHOOK_EVENT_LOG="/tmp/feishu-webhook-events.jsonl"

plugins/feishu/scripts/feishu_webhook_server.py
```

### 2. Expose it through HTTPS

Use any stable HTTPS tunnel or deploy the same handler to your own server. The public callback URL must end with:

```text
/webhook/feishu
```

Example:

```text
https://your-public-domain.example/webhook/feishu
```

### 3. Verify request URL in Feishu Open Platform

In `Events and Callbacks`, set the request URL to the public HTTPS URL and click verification. Success means the platform received:

```json
{"challenge":"..."}
```

### 4. Subscribe to the first event

Start with:

```text
im.message.receive_v1
```

Then publish the app if Feishu requires publication for the new event subscription.

### 5. Trigger and inspect

Send a message in a chat where the bot is visible. Then inspect:

```bash
tail -f /tmp/feishu-webhook-events.jsonl
```

Expected event type:

```text
im.message.receive_v1
```

## Local Challenge Test

When `Encrypt Key` is not enabled, you can test the request URL manually:

```bash
curl -sS \
  -H 'Content-Type: application/json' \
  -d '{"challenge":"test-code","type":"url_verification","token":"'"$FEISHU_VERIFICATION_TOKEN"'"}' \
  http://127.0.0.1:3000/webhook/feishu
```

Expected response:

```json
{"challenge":"test-code"}
```

If `Encrypt Key` is enabled in Feishu, the platform sends an encrypted body. Keep `FEISHU_ENCRYPT_KEY` configured on the server before clicking verification.

When `FEISHU_ENCRYPT_KEY` is set, the server verifies Feishu's `X-Lark-Signature` by default. For isolated local debugging without Feishu request headers, you can temporarily set:

```bash
export FEISHU_REQUIRE_SIGNATURE="0"
```

Do not disable signature verification in production.

## Automated Local Test

Run the smoke test from the repository root:

```bash
scripts/smoke-test.sh
```

Or run only the webhook fixture test:

```bash
plugins/feishu/scripts/test-feishu-webhook.py
```

The fixture test covers plaintext `url_verification`, `im.message.receive_v1`, signature calculation, and encrypted payload decryption.

## Common Events

Start narrow and add only what the product needs:

- `im.message.receive_v1`: receive user or group messages visible to the bot.
- `im.message.message_read_v1`: message read status, usually optional.
- Docs or Wiki events: only when a workflow needs passive content-change triggers.

## Bot Reply Example

See `examples/webhook-to-reply.md` for the recommended minimal flow:

```text
webhook event -> normalized log -> Codex prompt -> im_v1_message_create
```

## Production Notes

- Use HTTPS and a stable public domain.
- Keep `FEISHU_VERIFICATION_TOKEN` and `FEISHU_ENCRYPT_KEY` outside the repository.
- Avoid logging sensitive message content in production unless retention and access control are clear.
- Return quickly from the webhook handler. Long-running agent work should be queued or delegated.
- Use Feishu event logs in the Open Platform console when delivery fails.

---

## 中文说明

# Webhook 事件订阅

当飞书自建应用需要接收被动事件时，可以使用内置 Webhook 服务，例如机器人被 @、机器人可见的群消息，或应用回调事件。

## 服务能力

- 接收飞书事件订阅 HTTP 回调。
- 处理 `url_verification`，并返回飞书传入的 `challenge`。
- 配置后校验 `FEISHU_VERIFICATION_TOKEN`。
- 配置 `FEISHU_ENCRYPT_KEY` 后校验 `X-Lark-Signature`。
- 配置 `FEISHU_ENCRYPT_KEY` 后解密加密事件体。
- 将标准化事件输出到 stdout，或写入 `FEISHU_WEBHOOK_EVENT_LOG`。

这个服务刻意保持轻量。它只负责接收和标准化事件，不直接运行长期 agent workflow。

## 本地运行

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
export FEISHU_WEBHOOK_PORT="3000"

plugins/feishu/scripts/feishu_webhook_server.py
```

默认回调地址：

```text
http://127.0.0.1:3000/webhook/feishu
```

飞书开放平台校验时，需要在开发阶段通过稳定公网地址暴露该服务：

```text
https://your-public-domain.example/webhook/feishu
```

## 飞书官方配置清单

在飞书开放平台中：

1. 打开你的自建应用。
2. 进入 `事件与回调`。
3. 打开 `加密策略`，复制：
   - `Verification Token`
   - `Encrypt Key`
4. 在 Webhook 服务环境变量中配置：

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
```

5. 将订阅方式设置为发送事件到开发者服务器。
6. 填写请求地址：

```text
https://your-public-domain.example/webhook/feishu
```

7. 点击校验。服务需要在 1 秒内返回相同的 `challenge` 值。
8. 只订阅当前 workflow 真正需要的事件类型。
9. 事件订阅和权限通过审批后，发布应用。

## 端到端验证清单

Codex 可以启动本地接收服务并检查日志。飞书开放平台控制台步骤必须由你操作，因为需要你的租户登录态和应用管理员权限。

### 1. 启动本地接收服务

```bash
export FEISHU_VERIFICATION_TOKEN="xxx"
export FEISHU_ENCRYPT_KEY="xxx"
export FEISHU_WEBHOOK_EVENT_LOG="/tmp/feishu-webhook-events.jsonl"

plugins/feishu/scripts/feishu_webhook_server.py
```

### 2. 暴露 HTTPS 地址

使用稳定 HTTPS tunnel，或把同样的 handler 部署到你自己的服务。公网回调地址必须以：

```text
/webhook/feishu
```

结尾。例如：

```text
https://your-public-domain.example/webhook/feishu
```

### 3. 在飞书开放平台校验请求地址

在 `事件与回调` 中，把请求地址设置为公网 HTTPS 地址，然后点击校验。成功表示飞书收到了服务返回的：

```json
{"challenge":"..."}
```

### 4. 订阅第一个事件

先从这个事件开始：

```text
im.message.receive_v1
```

如果飞书要求发布新版应用，完成事件订阅后发布应用。

### 5. 触发并检查

在机器人可见的群或私聊里发送一条消息，然后查看：

```bash
tail -f /tmp/feishu-webhook-events.jsonl
```

预期事件类型：

```text
im.message.receive_v1
```

## 本地 Challenge 测试

未启用 `Encrypt Key` 时，可以手动测试请求地址：

```bash
curl -sS \
  -H 'Content-Type: application/json' \
  -d '{"challenge":"test-code","type":"url_verification","token":"'"$FEISHU_VERIFICATION_TOKEN"'"}' \
  http://127.0.0.1:3000/webhook/feishu
```

预期响应：

```json
{"challenge":"test-code"}
```

如果飞书已启用 `Encrypt Key`，平台会发送加密请求体。点击校验前，确保服务端已配置 `FEISHU_ENCRYPT_KEY`。

当设置 `FEISHU_ENCRYPT_KEY` 后，服务默认校验飞书的 `X-Lark-Signature`。如果只是本地隔离调试，没有飞书请求头，可以临时设置：

```bash
export FEISHU_REQUIRE_SIGNATURE="0"
```

生产环境不要关闭签名校验。

## 自动化本地测试

在仓库根目录运行：

```bash
scripts/smoke-test.sh
```

也可以只运行 Webhook fixture 测试：

```bash
plugins/feishu/scripts/test-feishu-webhook.py
```

fixture 测试覆盖明文 `url_verification`、`im.message.receive_v1`、签名计算和加密事件解密。

## 常见事件

建议从最小事件集开始，只订阅产品真正需要的事件：

- `im.message.receive_v1`：接收机器人可见的用户消息或群消息。
- `im.message.message_read_v1`：消息已读状态，通常不是必需。
- Docs 或 Wiki 事件：只有需要被动监听内容变化时再开启。

## 机器人回复示例

参考 `examples/webhook-to-reply.md`：

```text
webhook event -> 标准化日志 -> Codex prompt -> im_v1_message_create
```

## 生产注意事项

- 使用 HTTPS 和稳定公网域名。
- 不要把 `FEISHU_VERIFICATION_TOKEN` 和 `FEISHU_ENCRYPT_KEY` 写入仓库。
- 生产环境谨慎记录消息内容，先确认保留周期和访问权限。
- Webhook handler 要快速返回；耗时 agent 工作应进入队列或交给独立服务处理。
- 投递失败时，优先在飞书开放平台控制台查看事件日志。
