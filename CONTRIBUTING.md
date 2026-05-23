# Contributing to Feishu for Codex

Thanks for helping improve Feishu for Codex. This project welcomes practical contributions from people building with Codex, Feishu, MCP, and agent workflows.

[中文说明](#中文说明)

## What To Contribute

High-signal contributions are preferred:

- Feishu workflow improvements: IM, Docs, Wiki, Bitable, Webhook, permissions, or OAuth flows.
- MCP runtime fixes: tool schemas, error handling, token modes, local diagnostics, and smoke tests.
- AI tuning tips: prompts, agent instructions, workflow patterns, or evaluation notes that worked in real projects.
- Troubleshooting notes: install failures, permission gotchas, token issues, Feishu console settings, and recovery steps.
- `AGENTS.md` rules: concise project rules that helped Codex work better in your own repo.
- Case studies: real stories about shipping a project with Codex, including what worked, what failed, and what changed after launch.

Please avoid:

- Secrets, tokens, private chat logs, private documents, or screenshots with sensitive tenant data.
- Broad rewrites without a concrete bug, use case, or maintenance benefit.
- Pure marketing copy that does not help users install, debug, or build.

## Pull Request Process

1. Open an issue first for large changes, new tool families, or behavior changes.
2. Keep PRs focused. A docs fix, a runtime fix, and a case study should usually be separate PRs.
3. Run the smoke test before submitting:

```bash
scripts/smoke-test.sh
```

4. For code changes, include:
   - What changed
   - Why it changed
   - How you verified it
   - Any Feishu permission or tenant requirement
5. For docs changes, make sure links are relative and examples do not expose private IDs.
6. For screenshots, redact tenant names, user names, chat IDs, document titles, and tokens.

## Suggested PR Template

```md
## Summary

- 

## Verification

- [ ] `scripts/smoke-test.sh`
- [ ] Manual Feishu verification, if applicable:

## Notes

- Required permissions:
- Known limitations:
```

## Case Study Submissions

Case studies live in [`case-studies/`](./case-studies/). Use [`case-studies/TEMPLATE.md`](./case-studies/TEMPLATE.md) as the starting point.

Good case studies are specific:

- What did you build?
- Who was it for?
- How did Codex help?
- Which `AGENTS.md` rules mattered?
- What did you ship in the first 24-72 hours?
- Did you get users, revenue, feedback, or another concrete result?
- What would you do differently next time?

It is fine to anonymize revenue, customers, domains, screenshots, or internal details. Keep the learning useful.

---

## 中文说明

# Feishu for Codex 贡献指南

欢迎一起改进 Feishu for Codex。这个项目欢迎来自 Codex、飞书、MCP、智能体 workflow 实战中的具体贡献。

## 可以贡献什么

优先欢迎高信号内容：

- 飞书 workflow 改进：IM、Docs、Wiki、多维表格、Webhook、权限、OAuth 流程。
- MCP 运行时修复：tool schema、错误处理、token mode、本地诊断和 smoke test。
- AI 调优技巧：真实项目里有效的 prompt、agent instructions、workflow 模式或评估方法。
- 踩坑实录：安装失败、权限问题、token 问题、飞书控制台配置、恢复步骤。
- `AGENTS.md` 规则：你自己项目中让 Codex 表现更好的简洁规则。
- 实战案例：用 Codex 推进项目上线的真实故事，包括有效做法、失败点和上线后的变化。

请避免：

- 提交密钥、token、私有聊天记录、私有文档，或包含敏感租户数据的截图。
- 没有明确 bug、场景或维护收益的大范围重构。
- 对用户安装、调试、构建没有帮助的纯营销文案。

## PR 提交流程

1. 大改动、新工具族或行为变更，先开 issue 说明背景。
2. 保持 PR 聚焦。文档修复、运行时修复、案例投稿通常应拆成不同 PR。
3. 提交前运行：

```bash
scripts/smoke-test.sh
```

4. 代码改动请说明：
   - 改了什么
   - 为什么改
   - 如何验证
   - 是否需要额外飞书权限或租户配置
5. 文档改动请确认链接使用相对路径，示例不暴露私有 ID。
6. 截图请打码租户名、用户名、群 ID、文档标题和 token。

## 建议 PR 模板

```md
## Summary

- 

## Verification

- [ ] `scripts/smoke-test.sh`
- [ ] Manual Feishu verification, if applicable:

## Notes

- Required permissions:
- Known limitations:
```

## 实战案例投稿

案例放在 [`case-studies/`](./case-studies/)。请从 [`case-studies/TEMPLATE.md`](./case-studies/TEMPLATE.md) 开始。

好的案例要具体：

- 你做了什么产品？
- 面向谁？
- Codex 如何帮到你？
- 哪些 `AGENTS.md` 规则真正有效？
- 你在最初 24-72 小时内上线了什么？
- 是否获得用户、收入、反馈或其他具体结果？
- 下次会怎么改？

可以匿名化收入、客户、域名、截图或内部细节，但请保留对读者有用的实战经验。
