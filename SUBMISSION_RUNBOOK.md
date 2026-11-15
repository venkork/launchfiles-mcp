# LaunchFiles MCP Distribution — Founder Submission Runbook

> **Human-approved only:** Do not execute any external repo creation, registry publish, or GitHub PR automatically without explicit founder sign-off.

## Pre-Flight Checks (Before Step 1)

1. Confirm `https://launchfiles.app` is running the `2.1.1` deployment:
   - `https://launchfiles.app/.well-known/mcp.json` returns HTTP 200
   - `https://launchfiles.app/.well-known/mcp-registry-auth` returns HTTP 200 (`v=MCPv1; k=ed25519; ...`)
   - `https://launchfiles.app/.well-known/agent-card.json` returns HTTP 200
   - `https://launchfiles.app/llms.txt` returns HTTP 200 (`text/plain`)
   - `https://launchfiles.app/mcp-distribution` returns HTTP 200
2. Inside this repository root, validate `server.json` and run the live MCP smoke test:
   ```bash
   mcp-publisher validate
   ./examples/verify-mcp.sh https://launchfiles.app
   ```

---

## Step 1 — Create and Push the Public Companion GitHub Repository

Run from the root of this repository (`launchfiles-mcp-public-repo`):

```bash
git add .
git commit -m "LaunchFiles MCP public companion repo and v2.1.1 manifest"
gh repo create venkork/launchfiles-mcp --public --source=. --push
```

Verify the repository is publicly visible (`HTTP 200`) at:
- `https://github.com/venkork/launchfiles-mcp`

*(Wait until `https://github.com/venkork/launchfiles-mcp` is public before running Step 2, because `server.json` references that repository URL.)*

---

## Step 2 — Publish Version `2.1.1` to the Official MCP Registry

Authenticate with HTTP domain verification for `launchfiles.app` (using the local Ed25519 private key corresponding to `https://launchfiles.app/.well-known/mcp-registry-auth` — never commit private keys into this repository), validate `server.json`, and publish:

```bash
mcp-publisher validate
mcp-publisher login http --domain launchfiles.app --private-key "<ED25519_PRIVATE_KEY_HEX>"
mcp-publisher publish
```

Verify the published listing on the Official MCP Registry:

```bash
curl -sS "https://registry.modelcontextprotocol.io/v0/servers?search=launchfiles"
```

Confirm `"name": "app.launchfiles/launchfiles"` and `"version": "2.1.1"` appear in the response.

---

## Step 3 — Submit a Manual Pull Request to `punkpeye/awesome-remote-mcp-servers`

*(Manual PR only — no automated bot submission. LaunchFiles is a hosted Streamable HTTP remote endpoint, so it submits to `punkpeye/awesome-remote-mcp-servers` rather than local stdio `awesome-mcp-servers`.)*

1. Register/verify the remote connector at [https://glama.ai/mcp/connectors](https://glama.ai/mcp/connectors) so `https://glama.ai/mcp/connectors/app.launchfiles/launchfiles/badges/score.svg` resolves.
2. **Star `https://github.com/punkpeye/awesome-remote-mcp-servers`** (mandatory prerequisite — PRs from accounts that have not starred the repository are rejected).
3. Fork `https://github.com/punkpeye/awesome-remote-mcp-servers` and clone your fork locally.
4. Create a feature branch (for example, `git checkout -b add-launchfiles-mcp`).
5. In `README.md`, locate the appropriate alphabetical category (such as **Marketing** or **Developer Tools**) and insert the 3-line Glama connector badge entry (`<= 120` character one-sentence description ending in a period):

```markdown
- [LaunchFiles](https://launchfiles.app) `https://launchfiles.app/api/mcp`
  [![LaunchFiles MCP connector](https://glama.ai/mcp/connectors/app.launchfiles/launchfiles/badges/score.svg)](https://glama.ai/mcp/connectors/app.launchfiles/launchfiles)
  🔓 - Live checkout drift audits, UX inspection, Search Console SEO, horizon memory, and directory distribution.
```

6. Commit, push to your fork, and open the PR against `punkpeye/awesome-remote-mcp-servers` (`main`) referencing `https://launchfiles.app/api/mcp` and `https://registry.modelcontextprotocol.io` verification.
