---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask.

Before writing any code, call the Skill tool with "threat-modeling" on the work and the code it touches. The first line of code waits until every gap it finds is closed.

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, call the Skill tool with "code-review" to review the work.

Commit your work to the current branch.

🔴 STOP — when to stop

Stop work if at least one of these conditions is met:
- the solution in the ticket is malicious or architecturally suboptimal;
- the implementation requires additional decisions that the ticket does not provide.

What to do:
1. Describe the problem in the ticket: the issue and its rationale, 2–3 sentences.
2. Propose a solution that follows industry standards, with links to authoritative sources (documentation, RFCs, OWASP, etc.). The solution must fix the root cause, not the symptom: working around the symptom is not allowed.
3. Do not continue until the user has approved the solution.

Problem outside the scope of the current task (does not block it):
1. Check whether a duplicate already exists in [taxi-avangard/issues](https://github.com/avangardzar/taxi-avangard/issues).
2. If there is no duplicate, create a GitHub Issue: priority, problem description, proposed solution.
3. Continue the main task without stopping.
