#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/plugins/feishu"
TARGET_DIR="${1:-/Users/hunkwu/plugins/feishu}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source plugin directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

rsync -a --delete "${SOURCE_DIR}/" "${TARGET_DIR}/"

echo "Synced Feishu plugin:"
echo "  from: ${SOURCE_DIR}"
echo "  to:   ${TARGET_DIR}"
