## What it does

`grill-one-by-one` interviews you about a plan or design until you and the [agent](https://www.aihero.dev/ai-coding-dictionary/agent) share one understanding of it, and writes the vocabulary and the hard decisions into your repo while it does. It asks **exactly one question at a time**: one question, your answer, a one-line `✅` record of what was decided, then the next question.

That cadence is the whole skill. [grill-with-docs](https://aihero.dev/skills-grill-with-docs) asks in rounds, putting the whole frontier to you at once, and it leaves the same paper trail. Which one you want is decided by your own state, not by the subject: if you know the topic, rounds are faster; if you do not, a round is a queue of questions you cannot answer yet.

## When to reach for it

You invoke this by typing `/grill-one-by-one`; the agent will not reach for it on its own.

Reach for it when the topic is new to you and you expect to interrogate the agent before you can answer it. It holds the current question open while you do: a question back from you is treated as working out what the question means, never as an answer to it, so the interview does not advance until the two of you read it the same way.

| What you have | Reach for |
| --- | --- |
| A repo, and a topic you know well enough to answer in batches | [grill-with-docs](https://aihero.dev/skills-grill-with-docs) |
| A repo, and a topic you have to learn as you go | `grill-one-by-one` |
| No working directory at all | [grill-me](https://aihero.dev/skills-grill-me) |
| An effort too big to hold in one [session](https://www.aihero.dev/ai-coding-dictionary/session) | [wayfinder](https://aihero.dev/skills-wayfinder) |

## Prerequisites

It is [stateful](https://www.aihero.dev/ai-coding-dictionary/stateful), so you need to be somewhere it is safe to write. Resolved terms go to a `CONTEXT.md` glossary at the root, or to the relevant context's `CONTEXT.md` if a `CONTEXT-MAP.md` marks the repo as multi-context; decisions hard enough to earn one go to an ADR under `docs/adr/`. Both are created lazily, so there is nothing to scaffold first.

It also needs [domain-modeling](https://aihero.dev/skills-domain-modeling) present, because that is the skill it calls to do the writing. Installed alone, it interviews you and records nothing on disk.

## One question, then a record

The `✅` line is the load-bearing part, and it is what the rounds version has no need for. A round is answered as a block, so nothing can go missing between question and answer. One question at a time spreads the same ground over many more turns, and an answer that is never written down is an answer the [context window](https://www.aihero.dev/ai-coding-dictionary/context-window) eventually loses. So the decision is recorded in the conversation the moment you give it, before the next question is asked.

The record lives in the dialogue. Nothing on disk is a decision log: the glossary and the ADRs stay exactly what [domain-modeling](https://aihero.dev/skills-domain-modeling) makes them, written as terms resolve rather than as questions close.

Facts remain the agent's job. When a question turns on something the filesystem or the tools can answer, it dispatches a [subagent](https://www.aihero.dev/ai-coding-dictionary/subagent) and asks you a question that does not depend on the answer meanwhile. You are only ever asked for decisions.

## Common questions

**I already told my `CLAUDE.md` to ask one question at a time. Is this different?**
Yes, and the difference is where the instruction lives. That line sits in your own instructions file, outside the skill, and it is regularly reported not to survive: agents bundle questions anyway, because nothing in the skill they are running acknowledges the rule. Here the cadence is the skill's own text, and the file you keep your instructions in stops mattering.

**Does it write different files from `grill-with-docs`?**
No. Same `CONTEXT.md`, same ADRs, same gates on what earns one, because both hand the writing to the same skill. Only the question cadence differs.

**Can I ask the agent questions instead of answering?**
That is what it is for. Ask as many as it takes. The skill is instructed to answer plainly and to stay on the current question until it is settled, so the interview will not move on while you are still working out what is being asked.

**Which do I pick if I know half the topic?**
Start with `grill-one-by-one`. The cost of a question you could have answered in a batch is one extra turn; the cost of a round you cannot answer is a queue of questions that go stale while you catch up.

## It's working if

- You see one question, and nothing else, before you reply.
- Your question back gets an answer, and the same question is still on the table afterwards.
- A `✅` line naming what you just decided appears before the next question does.
- `CONTEXT.md` changes during the session, term by term, rather than in one lump at the end.
- Questions the codebase could answer are not put to you.

## Where it fits

`grill-one-by-one` is an alternative head of the main build chain:

```txt
grill-one-by-one → to-spec → to-tickets → implement → code-review
```

It occupies the same slot as [grill-with-docs](https://aihero.dev/skills-grill-with-docs) and produces the same thing: the shared understanding and settled vocabulary that [to-spec](https://aihero.dev/skills-to-spec) then turns into a [spec](https://www.aihero.dev/ai-coding-dictionary/spec) without interviewing you again. Its other neighbours are [grill-me](https://aihero.dev/skills-grill-me), the stateless interview for when there is no repo, and [domain-modeling](https://aihero.dev/skills-domain-modeling), the glossary-and-ADR discipline it drives. When you are unsure which skill or flow fits, [ask-matt](https://aihero.dev/skills-ask-matt) routes you.
