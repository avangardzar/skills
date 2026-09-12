# zar-skills

A personal fork of [**mattpocock/skills**](https://github.com/mattpocock/skills), the agent skill set built by Matt Pocock.

## Thanks to the source

Everything of substance in this repository was written by [Matt Pocock](https://github.com/mattpocock). He put decades of engineering experience into these skills, took them to the point where they hold up in daily use, and then **gave them away for free under MIT**, together with the documentation, the explanations, and the reasoning behind each choice.

That is rare generosity. Work like this usually becomes a closed product or a paid course. Instead it is an open repository you can read, copy, and reshape for yourself. This fork exists only because that was allowed.

If the methodology helps you too, go to the source rather than here:

- **Repository:** https://github.com/mattpocock/skills
- **Install for everyone:** `claude plugins install mattpocock-skills`
- **His newsletter:** https://www.aihero.dev/s/skills-newsletter

His original essay on why these skills exist is kept below, unchanged.

## What this fork is

The whole set is useful, but not in someone else's edit: some skills are surplus here, some want rewriting, some want adding. At the same time, upstream improvements should not be lost.

The fork does both at once. It is a mirror of the source repository, an edit of my own, and a Claude Code plugin, all in one place.

## Branches

Three branches, each with **exactly one process that writes to it**. Everything else follows from that rule.

| Branch | Written by | Purpose |
| --- | --- | --- |
| `upstream` | the sync robot only | **Mirror.** An exact copy of the source repository's `main` |
| `dev` | a human only | **Work.** Skills are edited and conflicts resolved here |
| `main` | promotion from `dev` only | **Shop window.** The plugin is built from it |

### `upstream`, the mirror

Updated automatically once a day: `.github/workflows/sync-upstream.yml` fetches the source repository's `main` and fast-forwards onto it.

No human ever writes to it. That is not a convention but a rule enforced by GitHub: a ruleset forbids deletion and force-push, and nobody can bypass it, the repository owner included. The moment a stray commit lands in the mirror it stops being a mirror, and the sync starts failing. It fails on purpose: the workflow uses `git merge --ff-only` so a divergence surfaces as an error instead of being papered over with a merge commit.

### `dev`, the work

The only branch that receives commits. Dependabot targets it too.

Picking up new work from upstream happens here as well: `upstream` is merged into `dev` by hand and conflicts are resolved on their merits. This is deliberately not automatic. Whether to take a new skill is a decision for a person, not for a robot.

### `main`, the shop window

What plugin users actually see. The only way in is a promotion.

A commit written straight to `main` costs the next promotion its fast-forward, which is why the branch carries the same protection against deletion and force-push.

## The plugin

The plugin is called `zar-skills`. The repository is its own marketplace: `.claude-plugin/marketplace.json` declares a catalogue named `zar` holding a single plugin.

### It loads from `main`

```json
"source": { "source": "github", "repo": "avangardzar/skills", "ref": "main" }
```

The source is a **branch**, not a commit. One consequence matters more than the rest: **users see only what has reached `main`.** Commits sitting on `dev` do not exist for them.

### Install

```bash
claude plugin marketplace add avangardzar/skills
claude plugin install zar-skills@zar
```

Then restart Claude Code. Skills are invoked as `/zar-skills:<name>`, for example `/zar-skills:grilling`.

### Update

```bash
claude plugin update zar-skills@zar
```

> **Worth knowing.** The update mechanism compares the `version` field in `plugin.json`, not the commit. If `main` has moved ahead but the version has not, the command reports `already at the latest version` and does nothing. That is why bumping the version is a load-bearing step of a promotion rather than a ceremony.

### Try it without installing

```bash
claude --plugin-dir ~/skills
```

Loads the plugin from a directory for the current session only. A local directory takes precedence over an installed plugin of the same name.

## Promotion

Moving finished work from `dev` to `main`:

```bash
git checkout main && git merge --ff-only dev
claude plugin validate .
claude plugin tag                                  # creates zar-skills--v<version>
git push origin main
git push origin refs/tags/zar-skills--v<version>   # by name, never --tags
```

The fork's version counts **promotions**, not upstream releases, and it lives in three files: `plugin.json`, `package.json`, and `package-lock.json`. The last one is regenerated with `npm install --package-lock-only` rather than edited by hand.

Upstream's changesets machinery is unused here, and left on disk untouched. Deleting files that upstream keeps editing would buy a conflict on every mirror sync.

## What the plugin leaves out

Skills live in bucket folders. Only `engineering/` and `productivity/` ship; `misc/`, `in-progress/`, and `deprecated/` stay in the repository without reaching users.

The skill list in `.claude-plugin/plugin.json` is maintained **by hand**. A new skill appearing upstream is a reason to decide whether to take it, not a reason for it to arrive silently. A skill that is not wanted gets dropped from the list, never deleted from disk.

## Licence

MIT, same as the source. See [LICENSE](./LICENSE).

---

*What follows is the original author's text, kept unchanged.*

## Why These Skills Exist

I built these skills as a way to fix common failure modes I see with Claude Code, Codex, and other coding agents.

### #1: The Agent Didn't Do What I Want

> "No-one knows exactly what they want"
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**. The most common failure mode in software development is misalignment. You think the dev knows what you want. Then you see what they've built - and you realize it didn't understand you at all.

This is just the same in the AI age. There is a communication gap between you and the agent. The fix for this is a **grilling session** - getting the agent to ask you detailed questions about what you're building.

**The Fix** is to use:

- [`/grill-me`](./skills/productivity/grill-me/SKILL.md) - for non-code uses
- [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) - same as [`/grill-me`](./skills/productivity/grill-me/SKILL.md), but adds more goodies (see below)

These are my most popular skills. They help you align with the agent before you get started, and think deeply about the change you're making. Use them _every_ time you want to make a change.

### #2: The Agent Is Way Too Verbose

> With a ubiquitous language, conversations among developers and expressions of the code are all derived from the same domain model.
>
> Eric Evans, [Domain-Driven-Design](https://www.amazon.co.uk/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

**The Problem**: At the start of a project, devs and the people they're building the software for (the domain experts) are usually speaking different languages.

I felt the same tension with my agents. Agents are usually dropped into a project and asked to figure out the jargon as they go. So they use 20 words where 1 will do.

**The Fix** for this is a shared language. It's a document that helps agents decode the jargon used in the project.

<details>
<summary>
Example
</summary>

Here's an example [`CONTEXT.md`](https://github.com/mattpocock/course-video-manager/blob/076a5a7a182db0fe1e62971dd7a68bcadf010f1c/CONTEXT.md), from my `course-video-manager` repo. Which one is easier to read?

- **BEFORE**: "There's a problem when a lesson inside a section of a course is made 'real' (i.e. given a spot in the file system)"
- **AFTER**: "There's a problem with the materialization cascade"

This concision pays off session after session.

</details>

This is built into [`/grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md). It's a grilling session, but that helps you build a shared language with the AI, and document hard-to-explain decisions in ADR's.

It's hard to explain how powerful this is. It might be the single coolest technique in this repo. Try it, and see.

> [!TIP]
> A shared language has many other benefits than reducing verbosity:
>
> - **Variables, functions and files are named consistently**, using the shared language
> - As a result, the **codebase is easier to navigate** for the agent
> - The agent also **spends fewer tokens on thinking**, because it has access to a more concise language

### #3: The Code Doesn't Work

> "Always take small, deliberate steps. The rate of feedback is your speed limit. Never take on a task that’s too big."
>
> David Thomas & Andrew Hunt, [The Pragmatic Programmer](https://www.amazon.co.uk/Pragmatic-Programmer-Anniversary-Journey-Mastery/dp/B0833F1T3V)

**The Problem**: Let's say that you and the agent are aligned on what to build. What happens when the agent _still_ produces crap?

It's time to look at your feedback loops. Without feedback on how the code it produces actually runs, the agent will be flying blind.

**The Fix**: You need the usual tranche of feedback loops: static types, browser access, and automated tests.

For automated tests, a red-green-refactor loop is critical. This is where the agent writes a failing test first, then fixes the test. This helps give the agent a consistent level of feedback that results in far better code.

I've built a **[`/tdd`](./skills/engineering/tdd/SKILL.md) skill** you can slot into any project. It encourages red-green-refactor and gives the agent plenty of guidance on what makes good and bad tests.

For debugging, I've also built a **[`/diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md)** skill that wraps best debugging practices into a disciplined loop, gated phase by phase.

### #4: We Built A Ball Of Mud

> "Invest in the design of the system _every day_."
>
> Kent Beck, [Extreme Programming Explained](https://www.amazon.co.uk/Extreme-Programming-Explained-Embrace-Change/dp/0321278658)

> "The best modules are deep. They allow a lot of functionality to be accessed through a simple interface."
>
> John Ousterhout, [A Philosophy Of Software Design](https://www.amazon.co.uk/Philosophy-Software-Design-2nd/dp/173210221X)

**The Problem**: Most apps built with agents are complex and hard to change. Because agents can radically speed up coding, they also accelerate software entropy. Codebases get more complex at an unprecedented rate.

**The Fix** for this is a radical new approach to AI-powered development: caring about the design of the code.

This is built in to every layer of these skills:

- [`/to-spec`](./skills/engineering/to-spec/SKILL.md) quizzes you about which modules you're touching before creating a spec

And crucially, [`/improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) surveys a codebase for deepening opportunities and hands you the candidates. I recommend running it on your codebase once every few days. It is a survey, not a rescue: on a genuinely old codebase it will find real candidates, but it won't untangle the mud for you.

### Summary

Software engineering fundamentals matter more than ever. These skills are my best effort at condensing these fundamentals into repeatable practices, to help you ship the best apps of your career. Enjoy.

## Reference

These split on one axis: who can invoke them. **User-invoked** skills are reachable only when you type them (e.g. `/grill-me`); their job is to orchestrate. **Model-invoked** skills can be invoked by you _or_ reached for automatically by the agent when the task fits; they hold the reusable discipline. A user-invoked skill may invoke model-invoked skills, but never another user-invoked one.

### Engineering

Skills I use daily for code work.

**User-invoked**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)**: Ask which skill or flow fits your situation. A router over the user-invoked skills in this repo.
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)**: Grilling session that also builds your project's domain model, sharpening terminology and updating `CONTEXT.md` and ADRs inline.
- **[grill-one-by-one](./skills/engineering/grill-one-by-one/SKILL.md)**: The same docs-writing grilling session as `grill-with-docs`, except it asks one question at a time and records each answer before the next one.
- **[triage](./skills/engineering/triage/SKILL.md)**: Move issues through a state machine of triage roles.
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)**: Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick.
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)**: Configure this repo for the engineering skills (issue tracker, triage labels, domain doc layout). Run once per repo before using the other engineering skills.
- **[to-spec](./skills/engineering/to-spec/SKILL.md)**: Turn the current conversation into a spec and publish it to the issue tracker. No interview, just synthesizes what you've already discussed.
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)**: Break any plan, spec, or conversation into a set of tracer-bullet tickets, each declaring its blocking edges, written as text in a local file, or as native blocking links on a real tracker.
- **[implement](./skills/engineering/implement/SKILL.md)**: Build the work described by a spec or set of tickets, driving `/tdd` at pre-agreed seams and closing out with `/code-review` before committing.
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)**: Plan a huge chunk of work, more than one agent session can hold, as a shared map of decision tickets on the issue tracker, and resolve them one at a time until the way to the destination is clear.

**Model-invoked**

- **[prototype](./skills/engineering/prototype/SKILL.md)**: Build a throwaway prototype to answer a design question, either a single shareable HTML file for state/logic questions, or several radically different UI variations toggleable from one route.
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)**: Disciplined diagnosis loop for hard bugs and performance regressions: build a feedback loop that goes red on this bug → minimise → hypothesise → instrument → fix → regression-test.
- **[research](./skills/engineering/research/SKILL.md)**: Investigate a question against high-trust primary sources and capture the findings as a cited Markdown file in the repo, run as a background agent.
- **[tdd](./skills/engineering/tdd/SKILL.md)**: Test-driven development with a red-green-refactor loop. Builds features or fixes bugs one vertical slice at a time.
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)**: Actively build and sharpen a project's domain model: challenge terms against the glossary, stress-test with edge-case scenarios, and update `CONTEXT.md` and ADRs inline.
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)**: Shared discipline and vocabulary for designing deep modules: a lot of behaviour behind a small interface, placed at a clean seam, testable through that interface.
- **[code-review](./skills/engineering/code-review/SKILL.md)**: Two-axis review of the diff since a fixed point: **Standards** (does it follow the repo's coding standards, plus a Fowler smell baseline?) and **Spec** (does it faithfully implement the originating issue/spec?), run as parallel sub-agents so neither pollutes the other.
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)**: Work through an in-progress git merge or rebase conflict hunk by hunk, resolving by intent traced to each side's primary source, then finish the operation (never `--abort`).
- **[wizard](./skills/engineering/wizard/SKILL.md)**: Generate an interactive bash wizard that walks a human through steps only they can perform: provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover.

### Productivity

General workflow tools, not code-specific.

**User-invoked**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)**: Get relentlessly interviewed about a plan or design until every branch of the design tree is resolved.
- **[handoff](./skills/productivity/handoff/SKILL.md)**: Compact the current conversation into a handoff document so another agent can continue the work.
- **[teach](./skills/productivity/teach/SKILL.md)**: Teach the user a new skill or concept over multiple sessions, using the current directory as a stateful teaching workspace.
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)**: Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can, filled in async, or together over a meeting. It grills you about the send (who it's for, what you need back), not the subject.
- **[wait-what](./skills/productivity/wait-what/SKILL.md)**: Fire this the moment a message doesn't land. The agent re-pitches it with the context you're missing, in plain English, using your `CONTEXT.md` vocabulary.

**Model-invoked**

- **[grilling](./skills/productivity/grilling/SKILL.md)**: Interview the user relentlessly about a plan, decision, or idea until every branch of the design tree is resolved. The reusable interview primitive behind `grill-me`, `grill-with-docs`, `triage`, `wayfinder` and `improve-codebase-architecture`.
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)**: Writing documents for agents: skills, AGENTS.md/CLAUDE.md, and any doc an agent reaches by a pointer.
