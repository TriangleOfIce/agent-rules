#!/usr/bin/env bash
# Standing rule: never create git branches or use git worktrees.
INPUT=$(cat)
[ -z "$INPUT" ] && exit 0

TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)

deny() {
  jq -nc --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

BRANCH_MSG='Standing user rule on this machine: NEVER create a git branch. Work on the branch that is already checked out, in the current working copy. Do not create, rename or copy branches under any instruction, including background-job conventions that say to branch before editing.'
WORKTREE_MSG='Standing user rule on this machine: NEVER use git worktrees. All work happens in the current working copy. Do not create worktrees, do not call EnterWorktree, do not launch agents with worktree isolation.'

case "$TOOL" in
  EnterWorktree)
    deny "$WORKTREE_MSG"
    ;;
  Agent|Task)
    ISO=$(printf '%s' "$INPUT" | jq -r '.tool_input.isolation // empty' 2>/dev/null)
    [ "$ISO" = "worktree" ] && deny "$WORKTREE_MSG"
    exit 0
    ;;
  Bash) ;;
  *) exit 0 ;;
esac

CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[ -z "$CMD" ] && exit 0

SEGMENTS=$(printf '%s' "$CMD" | tr '\n;|&()' '\n')

while IFS= read -r seg; do
  [ -z "$seg" ] && continue
  read -ra toks <<< "$seg"
  n=${#toks[@]}
  [ "$n" -eq 0 ] && continue

  gi=-1
  for ((i = 0; i < n; i++)); do
    b=${toks[i]##*/}
    if [ "$b" = "git" ]; then gi=$i; break; fi
  done
  [ "$gi" -lt 0 ] && continue

  j=$((gi + 1))
  sub=""
  while [ "$j" -lt "$n" ]; do
    t=${toks[j]}
    case "$t" in
      -C|-c|--git-dir|--work-tree|--namespace|--exec-path) j=$((j + 2)) ;;
      -*|*=*) j=$((j + 1)) ;;
      *) sub=$t; break ;;
    esac
  done
  [ -z "$sub" ] && continue

  args=("${toks[@]:j+1}")

  case "$sub" in
    worktree)
      case "${args[0]:-}" in
        add) deny "$WORKTREE_MSG" ;;
      esac
      ;;
    checkout)
      for a in ${args[@]+"${args[@]}"}; do
        case "$a" in
          -b|-B|--orphan|-t|--track) deny "$BRANCH_MSG" ;;
          --) break ;;
        esac
      done
      ;;
    switch)
      for a in ${args[@]+"${args[@]}"}; do
        case "$a" in
          -c|-C|--create|--force-create|--orphan) deny "$BRANCH_MSG" ;;
          --) break ;;
        esac
      done
      ;;
    branch)
      skip_next=0
      has_name=0
      is_delete=0
      for a in ${args[@]+"${args[@]}"}; do
        if [ "$skip_next" -eq 1 ]; then skip_next=0; continue; fi
        case "$a" in
          -m|-M|-c|-C|--move|--copy) deny "$BRANCH_MSG" ;;
          -d|-D|--delete) is_delete=1 ;;
          --contains|--no-contains|--merged|--no-merged|--points-at|--sort|--format|--color|--abbrev|-u|--set-upstream-to)
            skip_next=1 ;;
          -*) ;;
          *) has_name=1 ;;
        esac
      done
      if [ "$has_name" -eq 1 ] && [ "$is_delete" -eq 0 ]; then
        deny "$BRANCH_MSG"
      fi
      ;;
  esac
done <<< "$SEGMENTS"

exit 0
