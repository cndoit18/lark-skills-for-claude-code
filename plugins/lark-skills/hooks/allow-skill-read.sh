#!/bin/bash
set -euo pipefail

if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
	exit 0
fi

SKILLS_ROOT="$(cd "$CLAUDE_PLUGIN_ROOT/skills" 2>/dev/null && pwd -P)" || exit 0

INPUT=$(cat)
FILE_PATH="${INPUT##*\"file_path\":\"}"
FILE_PATH="${FILE_PATH%%\"*}"

if [[ "${FILE_PATH:0:1}" != "/" ]]; then
	exit 0
fi

REAL_PATH="$(cd "$(dirname "$FILE_PATH")" 2>/dev/null && pwd -P)/$(basename "$FILE_PATH")" || exit 0

if [[ "$REAL_PATH" != "$SKILLS_ROOT/"* ]]; then
	exit 0
fi

if [[ ! -f "$REAL_PATH" ]]; then
	exit 0
fi

echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
