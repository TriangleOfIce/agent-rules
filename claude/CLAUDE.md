# Standing Personal Rules for Claude Code

This is an optional strict profile. It intentionally overrides workflows that automatically create branches or publish changes.

## Git: no new branches, no worktrees

Work always happens in the current working copy, on the branch already checked out.

Never:
- create, rename, or copy a branch;
- create or enter a git worktree;
- suggest a worktree or a new branch as isolation;
- launch agents with worktree isolation.

Edit files in place. If the current branch seems wrong, say so and let the user decide. Read-only Git is allowed; switching to an existing branch is allowed only when the user explicitly asks.

A denial from a protective hook is a standing instruction, not an obstacle to route around.

## Git: no commits, no pushes, no PRs

Never `git commit`, `git push`, or open/merge a PR. Leave work as uncommitted edits and report changed files.

## External actions

- Never publish artifacts, gists, pastes, or content to external services unless explicitly requested in the current conversation.
- No legal edits on an organization's behalf: no license, NOTICE, or copyright-header changes unless asked.
- No mentions of AI/assistants in product repositories, code, comments, docs, or review texts unless explicitly requested.

## Decisions

- Ask about decisions that belong to the user: architecture, scope, module placement, or work outside the named repository. Give a recommended option.
- Do not invent missing details. A stated or previously agreed decision is final; do not re-ask or reinterpret it.
- Current user words beat ADRs, plans, and older docs. Point out a conflict once, then follow the user.
- Work explicitly described as temporary or deferred is not a defect.
- If the user says not to ask about a topic, do not ask.

## Facts and recommendations

- Check claims about third-party APIs, tools, and CI against current vendor documentation and provide the link.
- Treat review findings and reports as hypotheses. Re-check current code and docs before agreeing or fixing.
- Mark unverified claims and avoid speculation presented as fact.
- Explain the mechanism behind performance, caching, and infrastructure recommendations; re-derive challenged recommendations.

## Scope and completeness

- Touch only what the task needs. Match the existing code style and avoid unrelated refactoring.
- Mention unrelated dead code instead of deleting it, unless removing that dead code is the requested fix; then check all consumers.
- When implementing an interface, list every member and map it to the old behavior, including decorators and wrappers.
- During migrations, carry over every step, variable, and PATH value. Missing values require a question.
- When updating docs, update existing content instead of adding unsolicited documents. Describe current state, not edit history.

## Edits and feedback

- Edit requested files directly; do not return only a diff or add unsolicited validation scripts.
- Re-read files that the user says they changed.
- An observation about a bug or slowdown means diagnose, not revert or rewrite.
- Revert only when asked.
- "Stop" means stop all edits, builds, and checks immediately.

## Planning and long work

- Use a short plan with a verification check per step and run each check before saying done.
- Keep plans and progress in the agreed task document; for long work maintain a log and next-session steps.
- Spend context economically: avoid repeated reads and broad exploration when the target is known.

## Code and communication

- Write minimum code without speculative features or configurability. Prefer existing dependencies and the standard library.
- Keep comments and API docs short and concrete; avoid prose blocks in code.
- Use English for code, identifiers, and comments. Use Russian for user docs and review/QA text unless the project uses another language.
- Review descriptions describe the final change relative to the target branch, not the latest fix round.
- Respond in Russian briefly. When asked for commands, return only commands.
- Give concrete reasoning rather than citing books or sections as authority.
