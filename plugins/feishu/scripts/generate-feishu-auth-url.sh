#!/usr/bin/env bash
set -euo pipefail

redirect_uri="http://localhost:3000/callback"
scope=""
state="codex-feishu-$(date +%s)"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --redirect-uri)
      redirect_uri="${2:-}"
      shift 2
      ;;
    --scope)
      scope="${2:-}"
      shift 2
      ;;
    --state)
      state="${2:-}"
      shift 2
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [ -z "${FEISHU_APP_ID:-}" ]; then
  echo "missing FEISHU_APP_ID" >&2
  exit 2
fi

encoded_redirect_uri="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$redirect_uri")"
encoded_state="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$state")"

url="https://accounts.feishu.cn/open-apis/authen/v1/authorize?client_id=${FEISHU_APP_ID}&response_type=code&redirect_uri=${encoded_redirect_uri}&state=${encoded_state}"

if [ -n "$scope" ]; then
  encoded_scope="$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$scope")"
  url="${url}&scope=${encoded_scope}"
fi

printf '%s\n' "$url"
