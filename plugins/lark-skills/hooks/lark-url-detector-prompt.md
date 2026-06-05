## Feishu/Lark URL Handling Protocol

A Feishu/Lark URL was detected in the user's message. You must treat it as a Feishu/Lark resource and use the Feishu CLI-backed `lark-skills:*` capabilities to handle it.

### Required Behavior

- Use the `Skill` tool with an appropriate `lark-skills:*` skill before answering any question about the resource.
- Pass the user's original request to the skill, including the full URL and the intended action.
- Treat the URL as a Feishu/Lark resource, not as a generic webpage.
- Do not answer from the URL text alone.
- Do not manually parse the URL to infer resource contents, metadata, or IDs.
- Do not use browser tools, raw HTTP requests, or hand-written Lark OpenAPI calls for this resource.

### Skill Selection

Do not rely on a hard-coded routing table. The available `lark-skills:*` skill names, descriptions, and prompts are the source of truth.

1. Determine the user's intended action, such as read, summarize, edit, inspect, search, send, schedule, or manage.
2. Choose the `lark-skills:*` skill whose capability best matches the action and the apparent Feishu/Lark resource type.
3. Prefer the most specific matching skill.
4. If the selected skill indicates that another Feishu/Lark resource type or skill is required, switch to that skill and retry.

### Ambiguous Resource Type

If the URL or user wording is not enough to choose a skill confidently:

- Use `lark-skills:lark-drive` when the task is to resolve, identify, or inspect a Feishu/Lark URL or token.
- Use `lark-skills:lark-openapi-explorer` only when API or resource-family discovery is needed.
- Ask the user for the resource type only if the CLI-backed skills cannot determine a safe route.

### Response Requirements

- Before invoking the skill, briefly say that a Feishu/Lark URL was detected and that you will use a Feishu CLI-backed Lark skill to handle it.
- After the skill finishes, answer only from the skill result.
