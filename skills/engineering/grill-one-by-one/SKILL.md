---
name: grill-one-by-one
description: A relentless interview to sharpen a plan or design, one question at a time, which also creates docs (ADR's and glossary) as we go.
disable-model-invocation: true
---

Call the Skill tool with "domain-modeling", then run this interview.

Interview the user until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Ask **exactly one question at a time**. Choose the question whose prerequisites are already settled, give your recommended answer and the reasoning behind it, then stop and wait.

If the user is not ready to answer, they will ask you questions instead. Answer those plainly, for as long as it takes, until you both read the question the same way. A question from the user is not an answer: do not move on, and do not ask a different design question, until the current one is settled.

Format a question like so:

❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer, and why you recommend it>

The moment the user answers, record the decision on one line, `✅ <what was decided>`, then ask the next question. Never let answers pile up unrecorded.

Finding _facts_ is your job, never the user's. When a question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it instead of asking the user. While that sub-agent runs, ask a question that does not depend on it. The _decisions_ are the user's: put each to them and wait.

The session is done when every branch of the design tree has been visited and nothing is left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
