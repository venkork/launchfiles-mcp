#!/usr/bin/env bash
set -euo pipefail

MCP_URL="${LAUNCHFILES_MCP_URL:-https://launchfiles.app/api/mcp}"
TARGET_URL="${1:-https://launchfiles.app}"

echo "Verifying LaunchFiles Remote MCP endpoint: ${MCP_URL}"
echo "Target URL for smoke checks: ${TARGET_URL}"
echo ""

echo "1) JSON-RPC initialize..."
INIT_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-03-26",
      "capabilities": {},
      "clientInfo": { "name": "launchfiles-mcp-verify", "version": "2.1.1" }
    }
  }')"
echo "${INIT_RESP}" | head -c 500
echo ""
echo ""

echo "2) JSON-RPC tools/list..."
TOOLS_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list",
    "params": {}
  }')"

if command -v python3 >/dev/null 2>&1; then
  TOOLS_RESP_JSON="${TOOLS_RESP}" python3 - <<'PY'
import json, os
data = json.loads(os.environ["TOOLS_RESP_JSON"])
tools = data.get("result", {}).get("tools", [])
print(f"Discovered {len(tools)} public tools:")
for t in tools:
    print(f"  - {t.get('name')}")
PY
else
  echo "${TOOLS_RESP}" | head -c 600
fi
echo ""

echo "3) Smoke test: launchfiles_live_drift_check..."
DRIFT_RESP="$(curl -fsS -X POST "${MCP_URL}" \
  -H "Content-Type: application/json" \
  -d "{
    \"jsonrpc\": \"2.0\",
    \"id\": 3,
    \"method\": \"tools/call\",
    \"params\": {
      \"name\": \"launchfiles_live_drift_check\",
      \"arguments\": { \"url\": \"${TARGET_URL}\" }
    }
  }")"

if command -v python3 >/dev/null 2>&1; then
  DRIFT_RESP_JSON="${DRIFT_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["DRIFT_RESP_JSON"])
if "error" in data:
    print("launchfiles_live_drift_check error:", data["error"], file=sys.stderr)
    sys.exit(1)
sc = data.get("result", {}).get("structuredContent", {})
report = sc.get("report", {})
print("  ok:", sc.get("ok"), "| domain:", report.get("normalizedDomain"), "| status:", report.get("overallStatus"), "| trustScore:", report.get("trustScore"))
PY
else
  echo "${DRIFT_RESP}" | head -c 500
fi
echo ""

echo "4) Smoke test: launchfiles_mcp_registry_readiness..."
if echo "${TOOLS_RESP}" | grep -q '"launchfiles_mcp_registry_readiness"'; then
  READINESS_RESP="$(curl -fsS -X POST "${MCP_URL}" \
    -H "Content-Type: application/json" \
    -d "{
      \"jsonrpc\": \"2.0\",
      \"id\": 4,
      \"method\": \"tools/call\",
      \"params\": {
        \"name\": \"launchfiles_mcp_registry_readiness\",
        \"arguments\": { \"url\": \"${TARGET_URL}\" }
      }
    }")"
  if command -v python3 >/dev/null 2>&1; then
    READINESS_RESP_JSON="${READINESS_RESP}" python3 - <<'PY'
import json, os, sys
data = json.loads(os.environ["READINESS_RESP_JSON"])
if "error" in data:
    print("launchfiles_mcp_registry_readiness error:", data["error"], file=sys.stderr)
    sys.exit(1)
sc = data.get("result", {}).get("structuredContent", {})
receipt = sc.get("receipt", sc.get("probe", sc))
print("  ok:", sc.get("ok"), "| domain:", receipt.get("normalizedDomain"), "| readinessScoreOutOf100:", receipt.get("readinessScoreOutOf100"))
PY
  else
    echo "${READINESS_RESP}" | head -c 500
  fi
else
  READINESS_HTTP="$(curl -sS -o /dev/null -w "%{http_code}" -X POST "${MCP_URL}" \
    -H "Content-Type: application/json" \
    -d "{
      \"jsonrpc\": \"2.0\",
      \"id\": 4,
      \"method\": \"tools/call\",
      \"params\": {
        \"name\": \"launchfiles_mcp_registry_readiness\",
        \"arguments\": { \"url\": \"${TARGET_URL}\" }
      }
    }")"
  echo "  Note: launchfiles_mcp_registry_readiness returned HTTP ${READINESS_HTTP} (not yet listed in tools/list on this deployment; expected once v2.1.1 is live)."
fi

echo ""
echo "Verification completed."
