#!/usr/bin/env bash
set -euo pipefail

SOURCE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET=${1:-}

if [ -z "$TARGET" ]; then
  printf 'Usage: %s /path/to/workspace\n' "$0" >&2
  exit 2
fi

mkdir -p "$TARGET"
TARGET=$(cd "$TARGET" && pwd)

check_link() {
  local destination=$1
  local expected=$2
  if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$expected" ]; then
    return
  fi
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'Refusing to overwrite: %s\n' "$destination" >&2
    exit 1
  fi
}

make_link() {
  local source=$1
  local destination=$2
  if [ -L "$destination" ]; then
    return
  fi
  ln -s "$source" "$destination"
}

CONVENTIONS_LINK=1
if [ "$TARGET/agent-conventions" = "$SOURCE" ]; then
  CONVENTIONS_LINK=0
fi

check_link "$TARGET/AGENTS.md" "$SOURCE/AGENTS.md"
check_link "$TARGET/CLAUDE.md" "$SOURCE/CLAUDE.md"
if [ "$CONVENTIONS_LINK" -eq 1 ]; then
  check_link "$TARGET/agent-conventions" "$SOURCE"
fi

make_link "$SOURCE/AGENTS.md" "$TARGET/AGENTS.md"
make_link "$SOURCE/CLAUDE.md" "$TARGET/CLAUDE.md"
if [ "$CONVENTIONS_LINK" -eq 1 ]; then
  make_link "$SOURCE" "$TARGET/agent-conventions"
fi

mkdir -p "$TARGET/memory" "$TARGET/process" "$TARGET/backlog"
if [ ! -e "$TARGET/memory/projects.md" ]; then
  cp "$SOURCE/templates/memory.projects.md" "$TARGET/memory/projects.md"
fi
if [ ! -e "$TARGET/backlog/README.md" ]; then
  cp "$SOURCE/templates/backlog.README.md" "$TARGET/backlog/README.md"
fi

printf 'Connected agent guidelines to %s\n' "$TARGET"
