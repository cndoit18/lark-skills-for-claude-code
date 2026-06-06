# Lark Skills Plugin for Claude Code

Claude Code plugin for installing and using Lark/Feishu skills from the Lark CLI.

## Features

- Lark/Feishu skills for Claude Code
- Remote installation through Claude Code plugin marketplace
- Automatic Lark/Feishu URL detection for `larkoffice.com` and `larksuite.com`

## Installation

```bash
claude plugin marketplace add https://github.com/cndoit18/lark-skills-for-claude-code.git
claude plugin install lark-skills@lark-skills-marketplace
```

## Usage

After installation, use the `lark-skills:*` skills in Claude Code.

Example prompts:

- Use `lark-skills:lark-calendar` to check my agenda
- Use `lark-skills:lark-doc` to summarize a Lark document
- Use `lark-skills:lark-im` to send a Lark message

When a prompt contains a `larkoffice.com` or `larksuite.com` URL, the plugin suggests the appropriate Lark/Feishu skill.

## Limitations

- Requires Claude Code plugin support
- Lark/Feishu operations require valid `lark-cli` authentication and permissions
- Install plugins only from trusted repositories
