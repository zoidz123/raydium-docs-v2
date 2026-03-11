#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${GITBOOK_TOKEN:-}" || -z "${GITBOOK_ORG_ID:-}" ]]; then
  echo "Set GITBOOK_TOKEN and GITBOOK_ORG_ID before running this script." >&2
  exit 1
fi

REPO_RAW_BASE="${REPO_RAW_BASE:-https://raw.githubusercontent.com/zoidz123/raydium-docs-v2/main}"
API_BASE="https://api.gitbook.com/v1/orgs/${GITBOOK_ORG_ID}/openapi"

upsert_spec() {
  local slug="$1"
  local url="$2"

  curl -fsS -X PUT "${API_BASE}/${slug}" \
    -H "Authorization: Bearer ${GITBOOK_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"source\":{\"url\":\"${url}\"}}"
}

upsert_spec "raydium-trade-api" "${REPO_RAW_BASE}/api-reference/specs/trade-api-openapi.json"
upsert_spec "raydium-api-v3" "${REPO_RAW_BASE}/api-reference/specs/openapi.json"

echo "Published OpenAPI specs to GitBook organization ${GITBOOK_ORG_ID}."
