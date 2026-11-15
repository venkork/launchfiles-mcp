# LaunchFiles Remote MCP Server (`app.launchfiles/launchfiles`)

Hosted **Streamable HTTP** Model Context Protocol (MCP) server for live website checkout drift diagnostics, Chromium UX inspection, Google Search Console SEO opportunity audits, longitudinal domain horizon memory, and verified directory distribution.

- **Remote MCP Endpoint:** `https://launchfiles.app/api/mcp`
- **Transport:** `streamable-http` (JSON-RPC 2.0 over HTTPS — no local Docker, Node, or Python server required)
- **Registry ID:** `app.launchfiles/launchfiles` (`v2.1.1`)
- **Publisher:** LaunchFiles Operations ([support@launchfiles.app](mailto:support@launchfiles.app))
- **Website & Docs:** [https://launchfiles.app/mcp-distribution](https://launchfiles.app/mcp-distribution)

---

## Quickstart: Connect in Your MCP Client

Public diagnostic tools work immediately with **no authentication token**. To unlock workspace, Search Console write/query, truth-sheet extraction, drafting, distribution packing, and social approval tools, include an `Authorization: Bearer <YOUR_TOKEN>` header (see [Authentication](#authentication--approval-safety)).

### 1. Cursor

Copy [`.cursor/mcp.json`](./.cursor/mcp.json) into your project's `.cursor/mcp.json` (or `~/.cursor/mcp.json` globally):

```json
{
  "mcpServers": {
    "launchfiles": {
      "type": "http",
      "url": "https://launchfiles.app/api/mcp"
    }
  }
}
```

With a workspace bearer token:

```json
{
  "mcpServers": {
    "launchfiles": {
      "type": "http",
      "url": "https://launchfiles.app/api/mcp",
      "headers": {
        "Authorization": "Bearer YOUR_LAUNCHFILES_TOKEN"
      }
    }
  }
}
```

### 2. Claude Code

Add the remote Streamable HTTP server directly from your terminal:

```bash
claude mcp add --transport http launchfiles https://launchfiles.app/api/mcp
```

With a workspace bearer token:

```bash
claude mcp add --transport http launchfiles https://launchfiles.app/api/mcp \
  --header "Authorization: Bearer $LAUNCHFILES_TOKEN"
```

### 3. Claude Desktop

- **Option A (Connectors UI):** Open **Settings → Connectors → Add custom connector** and enter `https://launchfiles.app/api/mcp`.
- **Option B (`claude_desktop_config.json`):** See [`claude_desktop_config.json`](./claude_desktop_config.json). Keep **only one** entry matching your Claude Desktop version:
  - Direct HTTP (newer clients): `"type": "http", "url": "https://launchfiles.app/api/mcp"`
  - Local `mcp-remote` stdio bridge (if your client requires a local `command`):

```json
{
  "mcpServers": {
    "launchfiles": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://launchfiles.app/api/mcp"
      ]
    }
  }
}
```

To pass a bearer token through `mcp-remote`, append `"--header"`, `"Authorization: Bearer YOUR_LAUNCHFILES_TOKEN"` to `args`.

### 4. Windsurf

Add LaunchFiles to `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "launchfiles": {
      "serverUrl": "https://launchfiles.app/api/mcp"
    }
  }
}
```

Add `"headers": { "Authorization": "Bearer YOUR_LAUNCHFILES_TOKEN" }` inside `"launchfiles"` when calling authenticated workspace tools.

### 5. Antigravity

In Antigravity's MCP configuration (`mcp_config.json`), register the remote Streamable HTTP endpoint:

```json
{
  "mcpServers": {
    "launchfiles": {
      "serverUrl": "https://launchfiles.app/api/mcp"
    }
  }
}
```

Add `"headers": { "Authorization": "Bearer YOUR_LAUNCHFILES_TOKEN" }` when you want access to workspace-authenticated tools.

---

## Available MCP Tools

### Public Unauthenticated Tools

These read-only diagnostic tools can be called directly at `https://launchfiles.app/api/mcp` without an authorization header.

| Tool | Purpose | Key Inputs |
| :--- | :--- | :--- |
| `launchfiles_live_drift_check` | Run a live HTTP, legal route, sitemap, and Stripe Checkout / seller-brand drift inspection on a public website. | `url` (required), `expectedBrandTokens` (optional string array) |
| `launchfiles_mcp_registry_readiness` | Probe a domain's `/.well-known/mcp.json`, `/.well-known/mcp-registry-auth`, `/.well-known/agent-card.json`, `/llms.txt`, `/api/mcp` tools, Official MCP Registry status, and public companion repo readiness. | `url` (required), `repository_url` (optional) |
| `launchfiles_homepage_roast` | Run a 5-second above-the-fold clarity roast, server HTML check, and checkout drift check on a public homepage. | `url` (required), `include_screenshots` (optional boolean, default `false`) |
| `launchfiles_seo_indexing_status` | Inspect Google Search Console sitemap and indexing status for a verified domain or URL. | `url` (required) |

### Workspace & Founder Bearer-Authenticated Tools

Pass `Authorization: Bearer <token>` (or `x-api-key`) to access full workspace audits, Search Console execution, truth-sheet grounding, distribution bundle generation, and founder-approved social workflows.

| Tool | Purpose | Key Inputs |
| :--- | :--- | :--- |
| `launchfiles_ux_audit` | Run LaunchFiles' live Chromium 12-gate Design & UX Radar across desktop (`1440x900`) and mobile (`390x844`), returning tap-target, landmark, CTA, and hero diagnosis. | `url` (required), `override_archetype_id`, `include_visual_payloads` |
| `launchfiles_seo_audit` | Run or recall Search & SEO Radar: live Search Console CTR-leak prioritization, sitemap crawl on up to 10 routes, SERP landscape, and claim-verified upgrade package. | `url` (required), `mode` (`full_audit` \| `memory_only`) |
| `launchfiles_domain_horizon_memory` | Recall longitudinal multi-run audit memory across Clarity, UX, Search/GSC, Checkout Drift, and Distribution history, surfacing verified shipped-change deltas and the next highest-leverage bet. | `url` (required), `run_fresh_drift_check` (optional boolean) |
| `launchfiles_prepare_distribution_pack` | Probe live MCP/AI discovery, generate grounded `llms.txt` and registry artifacts (`server.json`, `.cursor/mcp.json`, `claude_desktop_config.json`), and stage claim-verified directory drafts (`autoSubmit: false`). | `url` (required), `repository_url`, `include_mcp_lane`, `record_proof` (`{ target_id, proof_url }`), `persist` |
| `launchfiles_seo_submit_sitemap` | Submit a canonical sitemap URL to Google Search Console and optionally send changed URLs to IndexNow. | `url` (required), `sitemapUrl`, `changedUrls`, `triggerIndexNow` |
| `launchfiles_gsc_query_opportunities` | Pull Search Console query-page rows, Page-1 CTR leak rankings, dead URL probes, Google Autocomplete expansions, and optional Keyword Planner search bands. | `url` (required), `includeAutocomplete`, `includeKeywordIdeas`, `seedKeywords`, `geoTargetId` |
| `launchfiles_public_intent_radar` | Discover live buyer-intent threads on Reddit and Hacker News matching target queries. | `queries` (required string array), `subreddits`, `includeHackerNews`, `days` |
| `launchfiles_extract_truth_sheet` | Extract a strictly grounded `ProductTruthSheet` (champion persona, verified capabilities, pricing, proof bounds, forbidden claims) from a live site and optional code excerpts. | `live_url` (required), `repo_files` (optional array) |
| `launchfiles_draft_verified_reply` | Draft a transparent founder reply for a buyer-intent community thread with cross-model claim entailment verification against a `ProductTruthSheet`. Never auto-posts. | `thread` (required), `live_url` or `truth_sheet` |
| `launchfiles_standalone_page_draft_short` | Short writer & 3-cut (`A / B / C`) voice engine with independent cross-model judging. Draft-only; never publishes. | `topic`, `url`, `who`, `proof`, `proof_mode`, `next_step`, `piece_kind`, `length`, `target_query`, `required_facts` |
| `launchfiles_standalone_page_draft_paid` | Grounded long/medium-form page & essay writer with independent cross-model judging. Draft-only; never publishes. | Same schema as `launchfiles_standalone_page_draft_short` |
| `launchfiles_social_connections_status` | Inspect product-scoped social connectors (X, Facebook, Instagram, Substack, LinkedIn, YouTube, Website RSS), capability levels, and pending publish approvals. | `product_slug` (optional) |
| `launchfiles_social_connection_scan` | Run a read-only native reconnaissance check across enabled social and RSS surfaces for a product (zero public side effects). | `product_slug` (required) |
| `launchfiles_social_prepare_approval` | Stage an external social post draft into the founder approval queue with body-hash locking and optional account-identity lock. Never auto-posts to Reddit. | `product_slug`, `surface`, `body` (required), plus optional `title`, `subtitle`, `feed_body`, `followup_reply_cta`, `media_url`, `expected_account_handle` |
| `launchfiles_social_publish_approved` | Execute native direct-API publishing for an explicitly founder-approved `approval_id` with `publish_allowed=true` and live account identity match verification. | `product_slug`, `approval_id`, `publish_allowed` (required), `approve_now`, `expected_body_hash` |

> Note: `launchfiles_ux_audit`, `launchfiles_seo_audit`, and `launchfiles_domain_horizon_memory` also support unauthenticated preview checks during evaluation; pair a workspace bearer token for authenticated workspace operations and persistent cross-tool distribution workflows.

---

## Discovery & Verification Endpoints

| Endpoint | Purpose |
| :--- | :--- |
| `https://launchfiles.app/api/mcp` | Streamable HTTP JSON-RPC 2.0 MCP endpoint (`POST` for `initialize`, `tools/list`, `tools/call`; `GET` returns server summary). |
| `https://launchfiles.app/.well-known/mcp.json` | Machine-readable MCP server discovery card listing `protocolVersion`, public/authenticated tools, and registry ID `app.launchfiles/launchfiles`. |
| `https://launchfiles.app/.well-known/mcp-registry-auth` | Ed25519 cryptographic domain ownership proof (`v=MCPv1; k=ed25519; ...`) used by the Official MCP Registry. |
| `https://launchfiles.app/.well-known/agent-card.json` | A2A Agent Card (`protocolVersion: 0.2.1`) pointing to `https://launchfiles.app/api/a2a`. |
| `https://launchfiles.app/.well-known/oauth-protected-resource` | Protected resource metadata describing supported bearer schemes and token onboarding URL (`https://launchfiles.app/today`). |
| `https://launchfiles.app/llms.txt` | Concise `llms.txt` directory summarizing LaunchFiles capabilities, pricing model, and canonical public routes. |
| `https://launchfiles.app/mcp-distribution` | Web quickstart and verification guide for connecting remote MCP clients. |

---

## Authentication & Approval Safety

- **Public read-only tools** require zero credentials so coding agents and developers can verify the live endpoint before issuing any token.
- **Workspace & Founder tokens** are obtained after workspace onboarding at [https://launchfiles.app/today](https://launchfiles.app/today) and [https://launchfiles.app/pricing](https://launchfiles.app/pricing), and passed via `Authorization: Bearer <token>` or `x-api-key`.
- **Human-in-the-loop by default:** Draft, directory distribution (`autoSubmit: false`), and social staging tools never auto-post or auto-merge changes. Social publishing requires an explicit approval ID, `publish_allowed: true`, body-hash verification, and live account identity match.

---

## Verify Live with `curl`

Run the included smoke-test script (no token required):

```bash
./examples/verify-mcp.sh
```

Or check a specific target URL:

```bash
./examples/verify-mcp.sh https://launchfiles.app
```

Direct `curl` example for `launchfiles_live_drift_check`:

```bash
curl -sS -X POST https://launchfiles.app/api/mcp \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "tools/call",
    "params": {
      "name": "launchfiles_live_drift_check",
      "arguments": { "url": "https://launchfiles.app" }
    }
  }'
```

---

## Repository Contents

- [`server.json`](./server.json) — Official MCP Registry manifest (`2025-12-11` schema, version `2.1.1`)
- [`.cursor/mcp.json`](./.cursor/mcp.json) — Drop-in Cursor Streamable HTTP MCP config
- [`claude_desktop_config.json`](./claude_desktop_config.json) — Claude Desktop remote HTTP & `mcp-remote` example configs
- [`examples/verify-mcp.sh`](./examples/verify-mcp.sh) — Executable `curl` smoke-test script (`initialize`, `tools/list`, public tool calls)
- [`SUBMISSION_RUNBOOK.md`](./SUBMISSION_RUNBOOK.md) — Founder-approved publishing checklist (GitHub repo, Official MCP Registry, Glama connector, and [`punkpeye/awesome-remote-mcp-servers`](https://github.com/punkpeye/awesome-remote-mcp-servers) PR)
- [`LICENSE`](./LICENSE) — MIT License

### Remote Directory Listing (`awesome-remote-mcp-servers`)

Because LaunchFiles is a hosted Streamable HTTP endpoint (not a local stdio package for `awesome-mcp-servers`), remote directory submissions target [`punkpeye/awesome-remote-mcp-servers`](https://github.com/punkpeye/awesome-remote-mcp-servers) using the 3-line Glama connector badge format:

```markdown
- [LaunchFiles](https://launchfiles.app) `https://launchfiles.app/api/mcp`
  [![LaunchFiles MCP connector](https://glama.ai/mcp/connectors/app.launchfiles/launchfiles/badges/score.svg)](https://glama.ai/mcp/connectors/app.launchfiles/launchfiles)
  🔓 - Live checkout drift audits, UX inspection, Search Console SEO, horizon memory, and directory distribution.
```

---

## Publisher, Support & Policies

- **Publisher:** LaunchFiles Operations
- **Support:** [support@launchfiles.app](mailto:support@launchfiles.app) · [https://launchfiles.app/support](https://launchfiles.app/support)
- **Policies:** [Privacy Policy](https://launchfiles.app/privacy) · [Terms of Service](https://launchfiles.app/terms) · [Refund Policy](https://launchfiles.app/refund)
- **License:** [MIT](./LICENSE)
