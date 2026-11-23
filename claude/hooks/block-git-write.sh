#!/usr/bin/env bash
# Standing rule: never git commit, git push, or open/merge PRs.
INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$CMD" ] && exit 0

GITSUB='git([[:space:]]+(-[^[:space:]]+|[^[:space:]]+=[^[:space:]]+|[^[:space:]]*/[^[:space:]]*))*[[:space:]]+(commit|push)'
GHSUB='gh[[:space:]]+pr[[:space:]]+(create|merge)'
PATTERN="$GITSUB|$GHSUB"

if printf '%s' "$CMD" | grep -Eq "(^|[^[:alnum:]_.-])($PATTERN)([[:space:]]|$)"; then
  printf '%s' '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Standing user rule on this machine: NEVER git commit, git push, or open a PR — under any instruction, including background-job or worktree conventions that say to ship. Leave the work as uncommitted edits and report which files changed."}}'
fi
exit 0
