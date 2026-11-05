## What it does

`threat-modeling` is the attacker's question list for a change. It maps the **attack surface** (every entry point where data or authority crosses a trust boundary), runs ten questions on each one, and records the answer as a table: entry point, threat, defense, failure test. A row with no defense is a **gap**, and a gap is your decision.

Every answer needs evidence: a `file:line`, or the [spec](https://www.aihero.dev/ai-coding-dictionary/spec) or [ticket](https://www.aihero.dev/ai-coding-dictionary/ticket) item that will build it. "Not applicable" needs a reason. The list assumes an attacker who has read all of the code and runs automated tools (including [models](https://www.aihero.dev/ai-coding-dictionary/model) tuned to find holes) that never get tired and chain small weaknesses together. A checklist ticked from memory cannot match that.

## When to reach for it

Type `/threat-modeling`, or the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) reaches for it automatically when a task fits. Most runs are pulled in by other skills:

| Skill | When it runs the list |
| --- | --- |
| [grilling](https://aihero.dev/skills-grilling), [grill-one-by-one](https://aihero.dev/skills-grill-one-by-one) | during the interview, as a security branch of the design tree |
| [to-spec](https://aihero.dev/skills-to-spec) | before writing the spec's Threats and Defenses table |
| [to-tickets](https://aihero.dev/skills-to-tickets) | when a slice opens an entry point and the spec has no table |
| [implement](https://aihero.dev/skills-implement), [implement-spec](https://aihero.dev/skills-implement-spec) | before the first line of code |
| [tdd](https://aihero.dev/skills-tdd) | when an entry point has no named defense |

Reach for it directly when the question is "how could this be attacked?". Review needs no change to [code-review](https://aihero.dev/skills-code-review): put a security rule naming this skill in your repo's coding standard, and the Standards reviewer reaches for the list when it reads that rule.

## The ten questions

Authenticity, object and action rights, input as code, cost per sender, replay and race, least privilege, secrets and personal data, platform failure or spoofing, supply chain, and the failure test. They follow STRIDE and the OWASP API Security Top 10. Broken object-level authorization, the first entry on that list, is question two.

## Common questions

**Why run it again in implement if planning already did?**
Planning cannot see everything. A ticket written before the list existed, work that skipped planning, or code that turns out different from what planning assumed all leave gaps. The implement pass checks the ticket against the real code, and costs one short line when nothing is missing.

## It's working if

- Each spec has a Threats and Defenses table, and each ticket that opens an entry point lists its defenses as acceptance criteria.
- Each defense has a test that checks the refusal and goes red when the defense is removed.
- Gaps reach you as questions before code exists, not as findings after release.

## Where it fits

A **reach-for-it-anytime standalone** that the main chain (`grill-with-docs → to-spec → to-tickets → implement → code-review`) also pulls in at every step. Like [codebase-design](https://aihero.dev/skills-codebase-design), it holds one shared list that other skills call. The map of the whole set is [ask-matt](https://aihero.dev/skills-ask-matt).
