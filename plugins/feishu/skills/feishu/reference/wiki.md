# Wiki

## Search Wiki Nodes

```yaml
tool: mcp__feishu-mcp__wiki_v1_node_search
data:
  query: "客户交付流程"
  page_size: 10
useUAT: true
```

## Get Wiki Node

```yaml
tool: mcp__feishu-mcp__wiki_v2_space_getNode
path:
  token: "wikicnxxxxxx"
params:
  obj_type: wiki
useUAT: true
```

## Reading Content

Wiki node metadata may return an object token that needs a Docs API call for actual text content. When a Wiki node maps to a Docx object, call `docx_v1_document_rawContent` with the resolved document ID.

## Permission Notes

- `wiki:wiki:readonly` is enough for search/read workflows.
- Write or copy operations need broader Wiki permissions.
- Wiki space member operations may require tenant-level approval.
