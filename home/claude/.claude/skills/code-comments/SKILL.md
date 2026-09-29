---
name: code-comments
description: "Write code comments that comment the non-obvious and delete the rest. Use when writing or editing comments in source code, adding explanatory comments to a change, or when the user asks to add, trim, or review comments. Steers toward brief, intent-focused comments and away from backstory, justification, or restating the code."
---

# Code comments

Comment the non-obvious; delete the rest. A comment is a cost (it rots, it adds noise); it has to buy more than it costs.

## A comment earns its place only if it says something the code can't
- Intent that isn't visible in the code itself
- A non-obvious decision or trade-off: *why here, why this way, not the obvious alternative*
- A constraint, invariant, or gotcha that will bite a later editor
- A pointer to context the reader needs (spec, ticket) as a link, not a retelling

## Never
- Restate what the code plainly does (`// increment i`) or echo the function/variable name
- Narrate the backstory or justify the change: what was broken, what you investigated, why it matters. That's PR / commit / ticket territory, not source.
- Leave a comment the next edit will quietly make false

## The test
Before keeping a comment, ask: **does this describe what the code does or why it's here, or is it justifying the change / telling a story?** A story or a justification gets cut, or moved to the commit or PR.

## Style
- Usually one line. Say the thing and stop.
- Match the file's existing comment density and idiom; don't import a different house style.
- Prefer *why* over *what*. The what is in the code and rots fast; the why rots slowly.
- Rich context (root cause, the investigation, environment-specific findings) belongs in the PR, ticket, or commit message, not the source.

## Worked example: trim to the one non-obvious fact

A `collectDefaultMetrics()` call added to a shared metrics module:

```
v1 (7 lines): full backstory — idle process serves empty /metrics, looks
              identical to a broken endpoint, makes the partner metric a
              clean signal…                                    → an essay
v2 (2 lines): "…so an idle process still exposes a non-empty /metrics;
              every other metric here is labelled…"            → still justifying the change
v3 (1 line):  "Here, not per-app, so every app importing these metrics
              also gets the process_*/nodejs_* baseline."      → the one non-obvious fact: placement
```

Each trim drops a layer of justification until only the thing a reader can't infer from the code remains: *why the call lives in this shared module*.
