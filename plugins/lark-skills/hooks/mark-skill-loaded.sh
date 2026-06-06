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
SKILLS_ROOT="$(cd "$CLAUDE_PLUGIN_ROOT/skills" 2>/dev/null && pwd -P)" || exit 0
SKILL_DIR_PATH="$(cd "$SKILLS_ROOT/$SKILL_DIR_NAME" 2>/dev/null && pwd -P)" || exit 0
SKILL_MD_PATH="$SKILL_DIR_PATH/SKILL.md"
SAFE_SESSION_ID="${SESSION_ID//[^A-Za-z0-9._-]/_}"
ALLOWLIST_PATH="/tmp/claude-lark-skills-read-${SAFE_SESSION_ID}.txt"

if [[ ! -d "$SKILL_DIR_PATH" ]]; then
	exit 0
fi

append_allow_skill() {
	local skill_dir_name="$1"
	local dir_path="$SKILLS_ROOT/$skill_dir_name"

	if [[ ! "$skill_dir_name" =~ ^lark-[A-Za-z0-9._-]+$ || ! -d "$dir_path" ]]; then
		return
	fi

	if [[ -f "$ALLOWLIST_PATH" ]] && grep -Fxq "$skill_dir_name" "$ALLOWLIST_PATH"; then
		return
	fi

	printf '%s\n' "$skill_dir_name" >> "$ALLOWLIST_PATH"
}

append_allow_skill "$SKILL_DIR_NAME"

if [[ ! -f "$SKILL_MD_PATH" ]]; then
	exit 0
fi

while IFS= read -r sibling_skill; do
	append_allow_skill "$sibling_skill"
done < <(
	grep -oE '\.\./lark-[A-Za-z0-9._-]+' "$SKILL_MD_PATH" | while IFS= read -r match; do
		printf '%s\n' "${match#../}"
	done | sort -u
)
