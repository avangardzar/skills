---
name: threat-modeling
description: Threat-model a change with the attacker's question list. Use when planning, implementing, or reviewing work that touches an entry point, a permission, a secret, an external call, or a dependency, or when the user raises security or threats.
---

# Threat Modeling

Model the attacker this list is written against: they have read all of the code, run automated tools (including LLMs tuned to find holes) without fatigue, and chain small weaknesses into one breach. Protection comes only from secrets and checks the code enforces.

## Process

1. **Map the attack surface.** List every **entry point** the work adds or touches where data or authority crosses a trust boundary:
   - an inbound request: HTTP route, webhook, platform event, mini-app or admin-panel call;
   - stored data that is later rendered, executed, or used in a query;
   - a permission or role granted to a process, database role, or bot;
   - a secret or personal data;
   - an outbound call to another system;
   - a new dependency or container image.

   An empty list is a claim too: state why the work crosses no boundary.
2. **Run every question on every entry point.** Each answer cites its evidence: `file:line` in the code, or the spec or ticket item that will build it. "Not applicable" carries its reason.
3. **Chain the answers.** Look for two weak answers that combine into one breach: a leaked identifier plus a missing object check is access to someone else's record; no rate limit plus a shared queue is a delay for every user.
4. **Record the result** as a table: entry point → threat → defense → failure test. A row without a defense is a **gap**.

Done when every entry point has an evidenced answer to every question and every defense has its failure test.

## Questions

1. **Authenticity.** Who can send this, and how do they prove it: signature, secret, token with audience and expiry, signed mini-app init data? Is the secret compared in constant time? What does a request forged from another site's page do (CSRF, CORS)?
2. **Object and action rights.** Is _this_ caller allowed _this_ action on _this_ object, when the id in the request belongs to someone else? The server checks the role; a role or owner sent by the client counts for nothing.
3. **Input as code.** Where does outside data become SQL, a shell command, HTML, a file path, a regex, a template, or a URL the server fetches itself (SSRF)? Is it checked against an allowlist at the boundary? Which values does the server take on the client's word: price, role, status?
4. **Cost per sender.** How much can one sender spend: request rate, payload size, open connections, algorithmic cost (regex backtracking, decompression, a query without a limit), place in a shared queue? Can one sender delay everyone else?
5. **Replay and race.** The same event delivered twice, two identical requests at once: one effect or two (an order taken twice, a charge applied twice)? Idempotency key, transaction, lock.
6. **Least privilege.** The process runs as non-root; the database role, bot permissions, and container network and file access are cut to what the work needs.
7. **Secrets and personal data.** Where they are stored and who reads them; they stay out of logs, error responses, URLs, git, and images. Responses reveal nothing extra (stack traces, "this user exists"). Denied access is visible in the log.
8. **Platform failure or spoofing.** 429, 403, timeout, a foreign response or address from an outside platform. When a check cannot complete, does the code fail closed or open, and is that choice written down?
9. **Supply chain.** A new dependency or image exists in its registry under that exact name (models invent package names), is pinned by version or digest, and comes from a known publisher.
10. **Failure test.** Each defense has a test of the refusal: no signature is rejected, a foreign object is rejected, over the limit is rejected, a replay has one effect. The test goes red when the defense is removed.

## A gap

A gap is the user's decision. Report it with one correct fix, the norm it follows (OWASP, the platform's docs), and its cost, then wait.

- **Planning**: the agreed fix becomes a decision in the spec and an acceptance criterion in the ticket.
- **Implementation**: stop before writing code; once the fix is agreed, amend the ticket and spec, then build.
- **Outside the work's scope**: it becomes its own issue in the tracker.
