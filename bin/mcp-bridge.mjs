#!/usr/bin/env node
import { createInterface } from 'node:readline';
const DEFAULT_ENDPOINT = "https://launchfiles.app/api/mcp";
const SERVER_ID = "app.launchfiles/launchfiles";
const endpoint = (process.env.MCP_ENDPOINT_URL || DEFAULT_ENDPOINT).trim();
const bearer = (process.env.MCP_BEARER_TOKEN || '').trim();
async function forwardRpc(line) {
  const trimmed = line.trim();
  if (!trimmed) return;
  let msg;
  try { msg = JSON.parse(trimmed); } catch { return; }
  const headers = {
    'content-type': 'application/json',
    accept: 'application/json, text/event-stream',
    'user-agent': `${SERVER_ID}-npx-bridge`,
  };
  if (bearer) headers.authorization = `Bearer ${bearer}`;
  const res = await fetch(endpoint, { method: 'POST', headers, body: JSON.stringify(msg) });
  const ct = (res.headers.get('content-type') || '').toLowerCase();
  const raw = await res.text();
  if (res.status === 202 || msg.id === undefined) return;
  const payloads = ct.includes('text/event-stream')
    ? raw.split(/\r?\n/).filter((l) => l.startsWith('data:')).map((l) => l.slice(5).trim()).filter((d) => d && d !== '[DONE]')
    : raw.trim() ? [raw.trim()] : [];
  for (const frame of payloads) process.stdout.write(`${frame}\n`);
}
const rl = createInterface({ input: process.stdin, crlfDelay: Infinity });
let chain = Promise.resolve();
rl.on('line', (line) => {
  chain = chain.then(() => forwardRpc(line)).catch((err) => {
    process.stderr.write(`${SERVER_ID} bridge error: ${err instanceof Error ? err.message : String(err)}\n`);
  });
});
rl.on('close', () => { void chain; });
