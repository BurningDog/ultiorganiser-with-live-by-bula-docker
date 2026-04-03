#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Usage: $0 <short name of patch>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CODEBASE_DIR="$(cd "$SCRIPT_DIR/../../uo-with-live-1.9.16" && pwd)"

TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TITLE="$*"
SLUG="$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')"
BASE="$SCRIPT_DIR/${TIMESTAMP}-${SLUG}"

git -C "$CODEBASE_DIR" diff > "${BASE}.patch"

STAT="$(git -C "$CODEBASE_DIR" diff --stat)"

cat > "${BASE}.md" <<EOF
# ${TITLE}

## Reason

<!-- Describe why this patch is needed -->

## Files changed

\`\`\`
${STAT}
\`\`\`
EOF

echo "Saved: ${BASE}.patch"
echo "Saved: ${BASE}.md"
