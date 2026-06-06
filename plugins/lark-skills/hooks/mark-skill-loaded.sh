#!/bin/bash
set -euo pipefail

if [[ -z "${CLAUDE_PLUGIN_ROOT:-}" ]]; then
	exit 0
fi

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
SKILL_NAME=$(echo "$INPUT" | jq -r '.tool_input.skill // empty')

if [[ -z "$SESSION_ID" || "$SKILL_NAME" != lark-skills:* ]]; then
	exit 0
fi

SKILL_DIR_NAME="${SKILL_NAME#lark-skills:}"
SKILL_DIR_PATH="$(cd "$CLAUDE_PLUGIN_ROOT/skills/$SKILL_DIR_NAME" 2>/dev/null && pwd -P)" || exit 0
SAFE_SESSION_ID="${SESSION_ID//[^A-Za-z0-9._-]/_}"
ALLOWLIST_PATH="/tmp/claude-lark-skills-read-${SAFE_SESSION_ID}.txt"

if [[ ! -d "$SKILL_DIR_PATH" ]]; then
	exit 0
fi

if [[ -f "$ALLOWLIST_PATH" ]] && grep -Fxq "$SKILL_DIR_PATH" "$ALLOWLIST_PATH"; then
	exit 0
fi

printf '%s\n' "$SKILL_DIR_PATH" >> "$ALLOWLIST_PATH"
