#!/usr/bin/env bash
set -euo pipefail

redirect_uri="http://localhost:3000/callback"
code=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --code)
      code="${2:-}"
      shift 2
      ;;
    --redirect-uri)
      redirect_uri="${2:-}"
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

if [ -z "${FEISHU_APP_SECRET:-}" ]; then
  echo "missing FEISHU_APP_SECRET" >&2
  exit 2
fi

if [ -z "$code" ]; then
  echo "usage: FEISHU_APP_ID=... FEISHU_APP_SECRET=... $0 --code <callback_code> [--redirect-uri <uri>]" >&2
  exit 2
fi

curl -sS https://open.feishu.cn/open-apis/authen/v2/oauth/token \
  -H 'Content-Type: application/json; charset=utf-8' \
  -d "{
    \"grant_type\": \"authorization_code\",
    \"code\": \"$code\",
    \"client_id\": \"$FEISHU_APP_ID\",
    \"client_secret\": \"$FEISHU_APP_SECRET\",
    \"redirect_uri\": \"$redirect_uri\"
  }"
