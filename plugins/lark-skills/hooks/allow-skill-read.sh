#!/bin/bash
set -euo pipefail

if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
	exit 0
fi

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // .tool_input.file_path // empty')

if [[ -z "$SESSION_ID" || -z "$FILE_PATH" || "${FILE_PATH:0:1}" != "/" ]]; then
	exit 0
fi

SAFE_SESSION_ID="${SESSION_ID//[^A-Za-z0-9._-]/_}"
ALLOWLIST_PATH="/tmp/claude-lark-skills-read-${SAFE_SESSION_ID}.txt"

if [[ ! -f "$ALLOWLIST_PATH" ]]; then
	exit 0
fi

SKILLS_ROOT="$(cd "$CLAUDE_PLUGIN_ROOT/skills" 2>/dev/null && pwd -P)" || exit 0
REAL_PATH="$(cd "$(dirname "$FILE_PATH")" 2>/dev/null && pwd -P)/$(basename "$FILE_PATH")" || exit 0

if [[ "$REAL_PATH" != "$SKILLS_ROOT/"* ]]; then
	exit 0
fi

if [[ ! -f "$REAL_PATH" ]]; then
	exit 0
fi

while IFS= read -r allowed_dir; do
	if [[ -n "$allowed_dir" && "$REAL_PATH" == "$allowed_dir/"* ]]; then
		echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
		exit 0
	fi
done < "$ALLOWLIST_PATH"
