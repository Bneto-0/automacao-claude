#!/usr/bin/env bash
set -euo pipefail

if [[ "${CLAUDE_CODE_REMOTE:-}" != "true" && -z "${GITHUB_TOKEN:-}" ]]; then
  exit 0
fi

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'gh\s+(issue|pr)\s+close'; then
  echo "Blocked: do not close issues/PRs directly in cloud sessions. End your comment with <!-- close --> instead." >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'gh\s+pr\s+create'; then
  echo "Blocked: do not create PRs directly in cloud sessions. Push to a data/** branch and the workflow will open the PR." >&2
  exit 2
fi
