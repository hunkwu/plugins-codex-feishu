# Bitable Project Templates

Use case: sync Codex project status, tasks, risks, release records, or case study intake into Feishu Base/Bitable.

## Template 1: Project Status

Minimum required fields:

- `Project`
- `Status`
- `Owner`

Fields:

- `Project`: text
- `Status`: single select, values `Todo`, `In Progress`, `Blocked`, `Done`
- `Owner`: text
- `Next Step`: text
- `Updated At`: date

Example record:

```yaml
Project: "Feishu for Codex"
Status: "In Progress"
Owner: "Hunk Wu"
Next Step: "Ship weekly private assistant update flow"
Updated At: "2026-05-25"
```

## Template 2: Release Records

Minimum required fields:

- `Version`
- `Date`
- `Summary`

Fields:

- `Version`: text
- `Date`: date
- `Summary`: text
- `Verification`: text
- `Git Commit`: text
- `Release Note URL`: url

Example record:

```yaml
Version: "v0.2-alpha"
Date: "2026-05-25"
Summary: "Stabilized private assistant push workflow."
Verification: "scripts/smoke-test.sh"
Git Commit: "abc1234"
Release Note URL: "https://example.com/release-notes/v0-2-alpha"
```

## Template 3: Risk Tracker

Minimum required fields:

- `Risk`
- `Severity`
- `Status`

Fields:

- `Risk`: text
- `Severity`: single select, values `Low`, `Medium`, `High`
- `Mitigation`: text
- `Owner`: text
- `Status`: single select, values `Open`, `Watching`, `Resolved`

Example record:

```yaml
Risk: "Tenant permissions may block document import."
Severity: "High"
Mitigation: "Add a permission checklist to setup docs."
Owner: "Hunk Wu"
Status: "Open"
```

## Template 4: Case Study Intake

Minimum required fields:

- `Submitter`
- `Project`
- `Workflow`
- `Permission To Publish`

Fields:

- `Submitter`: text
- `Project`: text
- `Workflow`: text
- `Result`: text
- `Permission To Publish`: checkbox
- `Notes`: text

Example record:

```yaml
Submitter: "Anonymous Builder"
Project: "Internal AI delivery bot"
Workflow: "Private assistant weekly updates"
Result: "Reduced manual reporting work"
Permission To Publish: true
Notes: "Needs customer details redacted before publication."
```

## Create Base

```yaml
tool: mcp__feishu-mcp__bitable_v1_app_create
data:
  name: "Codex Project Operations"
  time_zone: "Asia/Shanghai"
useUAT: true
```

## Create Record

```yaml
tool: mcp__feishu-mcp__bitable_v1_appTableRecord_create
path:
  app_token: "bascnxxxxxx"
  table_id: "tblxxxxxx"
data:
  fields:
    Project: "Feishu for Codex"
    Status: "In Progress"
    Owner: "Hunk Wu"
    Next Step: "Ship private assistant push workflow"
```

## Minimum Permissions

- Bitable read/write workflows require Bitable permissions approved for the target tenant.
- Use `useUAT: true` when the current user should own or directly open the Base.
- Use placeholders in docs and examples. Do not commit real `app_token`, `table_id`, record IDs, user IDs, or tenant data.

Current boundary:

- This stage delivers project operation templates and integration patterns.
- It does not promise a full Base ORM, sync engine, or generic multi-table framework.
