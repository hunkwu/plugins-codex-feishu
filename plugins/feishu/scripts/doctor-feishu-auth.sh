#!/usr/bin/env bash
set -euo pipefail

missing=0

if command -v npx >/dev/null 2>&1; then
  echo "ok: npx found at $(command -v npx)"
else
  echo "missing: npx command is not on PATH"
  echo "info: npx is optional when using the stable local HTTP-backed MCP server"
fi

if command -v python3 >/dev/null 2>&1; then
  echo "ok: python3 found at $(command -v python3)"
else
  echo "missing: python3 command is not on PATH"
  missing=1
fi

if [ -n "${FEISHU_APP_ID:-}" ]; then
  echo "ok: app id environment variable is set"
else
  echo "missing: set FEISHU_APP_ID"
  missing=1
fi

if [ -n "${FEISHU_APP_SECRET:-}" ]; then
  echo "ok: app secret environment variable is set"
else
  echo "missing: set FEISHU_APP_SECRET"
  missing=1
fi

if [ -n "${FEISHU_USER_ACCESS_TOKEN:-}" ]; then
  echo "ok: FEISHU_USER_ACCESS_TOKEN is set; user token mode can be used directly"
else
  echo "info: FEISHU_USER_ACCESS_TOKEN is not set; run scripts/exchange-feishu-code.sh after browser authorization before using stable MCP tools"
fi

if [ "$missing" -eq 0 ]; then
  echo "Feishu plugin prerequisites look ready."
else
  echo "Feishu plugin prerequisites are incomplete."
fi

exit "$missing"
