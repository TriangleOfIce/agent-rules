# Agent Guidelines

## Language

- Always write and maintain `AGENTS.md` in English.
- Think in English and respond to the user in Russian unless the user asks otherwise.
- Write code, identifiers, and code comments in English. Write user-facing documentation in Russian unless the project already uses another language.

## Instruction Priority and Decisions

- Follow the current explicit user request first, then instructions closest to the affected files, then workspace and general conventions.
- The user's current words beat older plans, ADRs, and documentation. Point out a material conflict once, then follow the user's decision.
- Do not silently reinterpret or relocate work. A decision already made by the user is final.
- Ask when different interpretations materially change the result, when the decision belongs to the user, or when work would expand beyond the agreed scope. Offer a recommended option.
- State assumptions and uncertainty explicitly. Do not invent missing requirements.

## Getting Started

1. Identify the project. If `memory/projects.md` exists, use it as the project map.
2. Before changes, read the affected project's `AGENTS.md`, `CLAUDE.md`/`CLAUDE.MD`, README, and `.claude/settings*.json`, plus rules in the affected subdirectory. More local rules take precedence.
3. Find the existing implementation, tests, build commands, and dependencies. Do not assume a tool or library is available.
4. Define the expected result and how to verify it. For multi-step work, keep a short plan with a verification check for each step.
5. For a multiplatform task, use `agent-conventions/docs/kotlin-multiplatform.md` when that directory is installed.

## Task Boundaries

- Do only what was requested and what is necessary for it. Every changed line must relate to the task.
- Do not incidentally change neighboring code, comments, formatting, or architecture. Do not refactor working code without a separate need and tests.
- Do not add features, abstractions, configuration, or impossible-case handling just in case. Preserve the project's style and structural decisions.
- Remove only artifacts created by the current work. Report unrelated defects or dead code instead of fixing them; record them in the backlog only when useful or requested.
- Do not read or modify secrets, keys, certificates, credentials, or files forbidden by project settings.
- Do not edit generated, build, IDE, or legal files unless the task explicitly requires it.
- Nothing leaves the machine without an explicit request: no external publication, gist, paste, ticket, or service write.
- Create a branch, worktree, commit, push, MR/PR, release, or deployment only when explicitly requested and allowed by the active client-specific rules. Otherwise work in the current working copy.
- Do not expand the task into another repository without necessity and agreement.

## Facts and Diagnosis

- Verify claims about third-party APIs, tools, and CI against current vendor documentation and cite the source. Code alone does not prove remote service behavior.
- Treat review findings and old reports as hypotheses. Re-check them against current code and documentation before agreeing or fixing.
- Do not present speculation as fact. Mark unverified parts; a short factual answer is better than a broad guess.
- Explain the mechanism behind performance, caching, and infrastructure recommendations. If challenged, re-derive the recommendation instead of defending it.
- An observation such as "it broke" or "it became slower" means diagnose first. Do not revert or rewrite unless asked.
- If the user says they changed files, re-read them before continuing.

## Implementation

- Write the minimum code that solves the task and match the surrounding naming and structural idioms.
- Prefer the standard library and dependencies already present in the project.
- Reproduce a bug with a test first when the project's test infrastructure allows it.
- Cover behavior changes with tests according to project rules. Do not create new test infrastructure in a project without tests unless asked.
- When implementing an interface or contract, enumerate every member and map it to the previous behavior, including decorators and wrappers.
- During migrations, carry over every step, variable, and required environment value. A missing value is a question, not permission to drop behavior silently.
- Keep comments and API documentation short and concrete. Do not add prose blocks or comments that merely narrate the code.
- If the user asks for a direct edit, edit the file rather than returning only a diff.

## Verification and Completion

- Verify the external contract and the real user scenario, not only compilation or imports.
- Run the affected project's standard build, test, and lint commands on the final state when they cover the change.
- Execute each planned verification before calling its step done. Do not declare completion while relevant checks fail or the requested scenario remains unverified.
- If the standard verification is blocked, try to make it work. Do not silently substitute a weaker check or shrink the deliverable.
- Before finishing, review every affected workspace with `git diff` and `git status`; outside Git, inspect changed and new files directly. Confirm task scope and remove only artifacts created by this work.
- Update documentation and comments that describe old behavior. Do not create unsolicited reports or documentation.
- In the final response, summarize the result, checks, changed paths, and anything left unverified. When asked for commands only, return only commands.
- "Stop" means stop immediately: no more edits, builds, or checks.

## Memory, Process, and Backlog

- Store durable cross-project facts in `memory/`; the project map is `memory/projects.md`. Record facts and sources, not a chronology of work.
- For a keyed task use `process/<TASK-KEY>/`; otherwise use `process/<short-name>/`.
- Keep temporary working documents (`design.md`, `plan.md`, `log.md`, `next-steps.md`) only in that task folder and create them as needed.
- For changes and long-running or multi-session work, maintain `log.md`: date, goal, affected projects/files, findings, checks with results, and blockers.
- For a one-off read-only answer, create no log or backlog entry unless requested. Leave existing logs intact.
- Do not scatter internal reports across product repositories. At completion, move durable decisions to ADRs or permanent documentation and handle temporary documents according to the team's process.
- See `agent-conventions/docs/documentation-and-process.md` for templates and documentation routing.

## Subagents and Models

- The primary agent owns task definition, integration, complex decisions, and final verification.
- Delegate only simple independent operations when permitted: inventories, searches, reading file groups, summaries, and routine checks. Do not delegate understanding of a key decision.
- Use a cheaper low-effort model for simple subtasks and a stronger high-effort model for difficult investigations or debugging.
- Give each subagent a specific read-only or narrowly editable scope, known paths, expected output, and relevant context.
- Do not launch a subagent for one elementary operation, duplicate a running subagent's work, or use parallel agent modes without permission.
- Verify subagent output before relying on it. See `agent-conventions/docs/subagents.md`.

## Engineering Conventions

- Follow `agent-conventions/docs/task-workflow.md` for the delivery route.
- Follow `agent-conventions/docs/testing-and-review.md` for testing, review, and Definition of Done.
- Follow `agent-conventions/docs/git-and-merge-requests.md` for Git and review-request practices when the user requests publication.
- Apply general rules to the scope touched by the change. Migrate an existing repository's whole architecture, CI, or tests only as a separately agreed task.
