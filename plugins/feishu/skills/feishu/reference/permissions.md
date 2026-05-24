# Permissions

## Add Document Collaborator

```yaml
tool: mcp__feishu-mcp__drive_v1_permissionMember_create
path:
  token: "doxcnxxxxxx"
  type: "docx"
data:
  member_type: "openid"
  member_id: "ou_xxxxx"
  perm: "view"
params:
  need_notification: true
useUAT: true
```

## Common Resource Types

- `docx`: new Feishu document
- `sheet`: spreadsheet
- `bitable`: Bitable app
- `file`: Drive file
- `wiki`: Wiki node

## Notes

- External email collaborator operations may be blocked by tenant policy.
- Use `openid` for internal users when possible.
- Wiki permissions can differ between a Wiki node and its underlying document.
